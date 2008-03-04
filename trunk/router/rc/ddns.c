/*

	Tomato Firmware
	Copyright (C) 2006-2008 Jonathan Zarate

*/

#include "rc.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <arpa/inet.h>


static void update(int num, int *dirty, int force)
{
	char config[2048];
	char *p;
	char *serv, *user, *pass, *host, *wild, *mx, *bmx, *cust;
	time_t t;
	struct tm *tm;
	int n;
	char ddnsx[16];
	char ddnsx_path[32];
	char s[128];
	char v[128];
	char cache_fn[32];
	char conf_fn[32];
	char cache_nv[32];
	char msg_fn[32];
	char ip[32];
	int exitcode;
	int errors;
	FILE *f;

	sprintf(s, "cru d ddns%d", num);
	system(s);
	sprintf(s, "cru d ddnsf%d", num);
	system(s);

	sprintf(ddnsx, "ddnsx%d", num);
	sprintf(ddnsx_path, "/var/lib/mdu/%s", ddnsx);
	strlcpy(config, nvram_safe_get(ddnsx), sizeof(config));
	
	mkdir("/var/lib/mdu", 0700);
	sprintf(msg_fn, "%s.msg", ddnsx_path);
	
	if ((vstrsep(config, "<", &serv, &user, &host, &wild, &mx, &bmx, &cust) != 7) || (*serv == 0)) {
		_dprintf("%s: msg=''\n", __FUNCTION__);
		f_write(msg_fn, NULL, 0, 0, 0);
		return;
	}
	
	if ((pass = strchr(user, ':')) != NULL) *pass++ = 0;
		else pass = "";
	
	if (!f_exists(msg_fn)) {
		_dprintf("%s: msg='Updating...'\n", __FUNCTION__);
		f_write_string(msg_fn, "Updating...\n", 0, 0);
	}

	for (n = 120; (n > 0) && (time(0) < Y2K); --n) {
		sleep(1);
	}
	if (n <= 0) {
		syslog(LOG_INFO, "Time not yet set.");
	}

	if (!wait_action_idle(10)) return;
	if (!check_wanup()) return;

	sprintf(cache_nv, "%s_cache", ddnsx);
	if (force) {
		nvram_set(cache_nv, "");
	}

	simple_lock("ddns");

	strlcpy(ip, nvram_safe_get("ddnsx_ip"), sizeof(ip));
	if (ip[0] == '@') {
		if ((strcmp(serv, "zoneedit") == 0) || (strcmp(serv, "tzo") == 0) || (strcmp(serv, "noip") == 0) || (strcmp(serv, "dnsomatic") == 0)) {
			strcpy(ip + 1, serv);
		}
		else {
			strcpy(ip + 1, "dyndns");
		}
	}
	else if (inet_addr(ip) == -1) {		
		strcpy(ip, get_wanip());
	}
	
	sprintf(cache_fn, "%s.cache", ddnsx_path);
	f_write_string(cache_fn, nvram_safe_get(cache_nv), 0, 0);
	
	sprintf(conf_fn, "%s.conf", ddnsx_path);
	if ((f = fopen(conf_fn, "w")) == NULL) goto CLEANUP;
	// note: options not needed for the service are ignored by mdu
	fprintf(f,
		"user %s\n"
		"pass %s\n"
		"host %s\n"
		"addr %s\n"
		"mx %s\n"
		"backmx %s\n"
		"wildcard %s\n"
		"url %s\n"
		"ahash %s\n"
		"msg %s\n"
		"cookie %s\n"
		"addrcache extip\n"
		"",
		user,
		pass,
		host,
		ip,
		mx,
		bmx,
		wild,
		cust,
		cust,
		msg_fn,
		cache_fn);

	if (nvram_match("debug_ddns", "1")) {
		fprintf(f, "dump /tmp/mdu-%s.txt\n", serv);
	}

	fclose(f);
	
	exitcode = eval("mdu", "--service", serv, "--conf", conf_fn);
	_dprintf("%s: exitcode=%d\n", __FUNCTION__, exitcode);
	
	sprintf(s, "%s_errors", ddnsx);
	if ((exitcode == 1) || (exitcode == 2)) {
		if (nvram_match("ddnsx_retry", "0")) goto CLEANUP;

		if (force) {
			errors = 0;
		}
		else {
			errors = nvram_get_int(s) + 1;
			if (errors < 1) errors = 1;
			if (errors >= 3) {
				nvram_unset(s);
				goto CLEANUP;
			}
		}
		sprintf(v, "%d", errors);
		nvram_set(s, v);
		goto SCHED;
	}
	else {
		nvram_unset(s);
		errors = 0;
	}

	f_read_string(cache_fn, s, sizeof(s));
	if ((p = strchr(s, '\n')) != NULL) *p = 0;
	t = strtoul(s, &p, 10);
	if (*p != ',') goto CLEANUP;
	
	if (!nvram_match(cache_nv, s)) {
		nvram_set(cache_nv, s);
		if (strncmp(serv, "dyndns", 6) == 0) *dirty = 1;
	}
	
	if (!nvram_match("ddnsx_refresh", "0")) {
		// refresh every 28 days
		t += (28 * 86400);
		tm = localtime(&t);
		sprintf(s, "cru a ddnsf%d \"%d %d %d %d * ddns-update %d force\"", num,
			tm->tm_min, (tm->tm_hour < 3) ? 3 : tm->tm_hour, tm->tm_mday, tm->tm_mon + 1, num);
		system(s);
	}

	if (ip[0] == '@') {
SCHED:
#if 0
		t = time(0);
		tm = localtime(&t);
		_dprintf("%s: now: %d:%d errors=%d\n", __FUNCTION__, tm->tm_hour, tm->tm_min, errors);
#endif

		// need at least 10m spacing for checkip
		// +1m to not trip over mdu's ip caching
		// +5m for every error
		n = (11 + (errors * 5));
		if ((exitcode == 1) || (exitcode == 2)) {
			if (exitcode == 2) n = 30;
			sprintf(s, "\n#RETRY %d %d\n", n, errors);	// should be localized in basic-ddns.asp
			f_write_string(msg_fn, s, FW_APPEND, 0);
			_dprintf("%s: msg='retry n=%d errors=%d'\n", __FUNCTION__, n, errors);
		}		
		t = time(0) + (n * 60);
		tm = localtime(&t);
		_dprintf("%s: sch: %d:%d\n", __FUNCTION__, tm->tm_hour, tm->tm_min);
		
		sprintf(s, "cru a ddns%d \"%d * * * * ddns-update %d\"", num, tm->tm_min, num);
		_dprintf("%s: %s\n", __FUNCTION__, s);
		system(s);
			
		//	sprintf(s, "cru a ddns%d \"*/10 * * * * ddns-update %d\"", num);
		//	system(s);
	}

CLEANUP:
	if (!nvram_match("debug_keepfiles", "1")) {
		unlink(cache_fn);
		unlink(conf_fn);
	}
	simple_unlock("ddns");
}

int ddns_update_main(int argc, char **argv)
{
	int num;
	int dirty;
	
	dirty = 0;
	umask(077);
	
	if (argc == 1) {
		update(0, &dirty, 0);
		update(1, &dirty, 0);
	}
	else if ((argc == 2) || (argc == 3)) {
		num = atoi(argv[1]);
		if ((num == 0) || (num == 1)) {
			update(num, &dirty, (argc == 3) && (strcmp(argv[2], "force") == 0));
		}
	}
	if (dirty) {
		if (!nvram_match("debug_nocommit", "1")) nvram_commit();
	}
	return 0;
}

void start_ddns(void)
{
	stop_ddns();

	// cleanup
	simple_unlock("ddns");
	nvram_unset("ddnsx0_errors");
	nvram_unset("ddnsx1_errors");

	xstart("ddns-update");
}

void stop_ddns(void)
{
	system("cru d ddns0");
	system("cru d ddns1");
	system("cru d ddnsf0");
	system("cru d ddnsf1");
	killall("ddns-update", SIGKILL);
	killall("mdu", SIGKILL);	
}
