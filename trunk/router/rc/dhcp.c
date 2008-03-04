/*

	Copyright 2003, CyberTAN  Inc.  All Rights Reserved

	This is UNPUBLISHED PROPRIETARY SOURCE CODE of CyberTAN Inc.
	the contents of this file may not be disclosed to third parties,
	copied or duplicated in any form without the prior written
	permission of CyberTAN Inc.

	This software should be used as a reference only, and it not
	intended for production use!

	THIS SOFTWARE IS OFFERED "AS IS", AND CYBERTAN GRANTS NO WARRANTIES OF ANY
	KIND, EXPRESS OR IMPLIED, BY STATUTE, COMMUNICATION OR OTHERWISE.  CYBERTAN
	SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS
	FOR A SPECIFIC PURPOSE OR NONINFRINGEMENT CONCERNING THIS SOFTWARE

*/
/*

	Copyright 2005, Broadcom Corporation
	All Rights Reserved.

	THIS SOFTWARE IS OFFERED "AS IS", AND BROADCOM GRANTS NO WARRANTIES OF ANY
	KIND, EXPRESS OR IMPLIED, BY STATUTE, COMMUNICATION OR OTHERWISE. BROADCOM
	SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS
	FOR A SPECIFIC PURPOSE OR NONINFRINGEMENT CONCERNING THIS SOFTWARE.

 */
/*

	Modified for Tomato Firmware
	Portions, Copyright (C) 2006-2008 Jonathan Zarate

*/

#include "rc.h"

#include <sys/sysinfo.h>
#include <sys/ioctl.h>


#define IFUP (IFF_UP | IFF_RUNNING | IFF_BROADCAST | IFF_MULTICAST)

static void expires(unsigned int seconds)
{
	struct sysinfo info;
	char s[32];

   	sysinfo(&info);
	sprintf(s, "%u", (unsigned int)info.uptime + seconds);
	f_write_string("/var/lib/misc/dhcpc.expires", s, 0, 0);
}

// copy env to nvram
// returns 1 if new/changed, 0 if not changed/no env
static int env2nv(char *env, char *nv)
{
	char *value;
	if ((value = getenv(env)) != NULL) {
		if (!nvram_match(nv, value)) {
			nvram_set(nv, value);
			return 1;
		}
	}
	return 0;
}

static void env2nv_gateway(const char *nv)
{
	char *v;
	char *b;
	if ((v = getenv("router")) != NULL) {
		if ((b = strdup(v)) != NULL) {
			if ((v = strchr(b, ' ')) != NULL) *v = 0;	// truncate multiple entries
			nvram_set(nv, b);
			free(b);
		}
	}
}

static const char renewing[] = "/var/lib/misc/dhcpc.renewing";

static int deconfig(char *ifname)
{
	_dprintf("%s: begin\n", __FUNCTION__);

	ifconfig(ifname, IFUP, "0.0.0.0", NULL);

	nvram_set("wan_ipaddr", "0.0.0.0");
	nvram_set("wan_netmask", "0.0.0.0");
	nvram_set("wan_gateway", "0.0.0.0");
	nvram_set("wan_get_dns", "");
	nvram_set("wan_lease", "0");
	expires(0);

	//	int i = 10;
	//	while ((route_del(ifname, 0, NULL, NULL, NULL) == 0) && (i-- > 0)) { }

	_dprintf("%s: end\n", __FUNCTION__);
	return 0;
}

static int renew(char *ifname)
{
	char *a, *b;
	int changed;

	_dprintf("%s: begin\n", __FUNCTION__);

	unlink(renewing);

	changed = env2nv("ip", "wan_ipaddr");
	changed |= env2nv("subnet", "wan_netmask");
	if (changed) {
		ifconfig(ifname, IFUP, nvram_safe_get("wan_ipaddr"), nvram_safe_get("wan_netmask"));
	}

	if (get_wan_proto() == WP_L2TP) {	
		env2nv_gateway("wan_gateway_buf");
	}
	else {
		a = strdup(nvram_safe_get("wan_gateway"));
		env2nv_gateway("wan_gateway");
		b = nvram_safe_get("wan_gateway");
		if ((a) && (strcmp(a, b) != 0)) {
			route_del(ifname, 0, "0.0.0.0", a, "0.0.0.0");
			route_add(ifname, 0, "0.0.0.0", b, "0.0.0.0");
			changed = 1;
		}
		free(a);
	}
	
	changed |= env2nv("domain", "wan_get_domain");
	changed |= env2nv("dns", "wan_get_dns");

	if ((a = getenv("lease")) != NULL) {
		nvram_set("wan_lease", a);
		expires(atoi(a));
	}

	if (changed) {
		set_host_domain_name();
		stop_dnsmasq();
		dns_to_resolv();
		start_dnsmasq();
	}
	
	_dprintf("wan_ipaddr=%s\n", nvram_safe_get("wan_ipaddr"));
	_dprintf("wan_netmask=%s\n", nvram_safe_get("wan_netmask"));
	_dprintf("wan_gateway=%s\n", nvram_safe_get("wan_gateway"));
	_dprintf("wan_get_domain=%s\n", nvram_safe_get("wan_get_domain"));
	_dprintf("wan_get_dns=%s\n", nvram_safe_get("wan_get_dns"));
	_dprintf("wan_lease=%s\n", nvram_safe_get("wan_lease"));
	_dprintf("%s: end\n", __FUNCTION__);
	return 0;
}

static int bound(char *ifname)
{
	_dprintf("%s: begin\n", __FUNCTION__);

	unlink(renewing);

	env2nv("ip", "wan_ipaddr");
	env2nv("subnet", "wan_netmask");
	env2nv_gateway("wan_gateway");
	env2nv("dns", "wan_get_dns");
	env2nv("domain", "wan_get_domain");
	env2nv("lease", "wan_lease");
	expires(atoi(safe_getenv("lease")));
	
	_dprintf("wan_ipaddr=%s\n", nvram_safe_get("wan_ipaddr"));
	_dprintf("wan_netmask=%s\n", nvram_safe_get("wan_netmask"));
	_dprintf("wan_gateway=%s\n", nvram_safe_get("wan_gateway"));
	_dprintf("wan_get_domain=%s\n", nvram_safe_get("wan_get_domain"));
	_dprintf("wan_get_dns=%s\n", nvram_safe_get("wan_get_dns"));
	_dprintf("wan_lease=%s\n", nvram_safe_get("wan_lease"));
	

	ifconfig(ifname, IFUP, nvram_safe_get("wan_ipaddr"), nvram_safe_get("wan_netmask"));

	if (get_wan_proto() == WP_L2TP) {
		int i = 0;

		/* Delete all default routes */
		while ((route_del(ifname, 0, NULL, NULL, NULL) == 0) || (i++ < 10));

		/* Set default route to gateway if specified */
		route_add(ifname, 0, "0.0.0.0", nvram_safe_get("wan_gateway"), "0.0.0.0");

		/* Backup the default gateway. It should be used if L2TP connection is broken */
		nvram_set("wan_gateway_buf", nvram_get("wan_gateway"));

		/* clear dns from the resolv.conf */
		nvram_set("wan_get_dns","");
		dns_to_resolv();

		start_firewall();
		start_l2tp(BOOT);
	}
	else {
		start_wan_done(ifname);
	}

	_dprintf("%s: end\n", __FUNCTION__);
	return 0;
}

int dhcpc_event_main(int argc, char **argv)
{
	char *ifname;

	if (!wait_action_idle(10)) return 1;

#if 0
	if (nvram_match("debug_dhcpcenv", "1")) {
		system("( date; env ) >> /tmp/dhcpc_event.env");
	}
#endif

	if ((argc == 2) && (ifname = getenv("interface")) != NULL) {
		if (strcmp(argv[1], "deconfig") == 0) return deconfig(ifname);
		if (strcmp(argv[1], "bound") == 0) return bound(ifname);
		if ((strcmp(argv[1], "renew") == 0) || (strcmp(argv[1], "update") == 0)) return renew(ifname);
	}
	
	_dprintf("%s: unknown event %s\n", __FUNCTION__, argv[1]);
	return 1;
}


// -----------------------------------------------------------------------------


int dhcpc_release_main(int argc, char **argv)
{
	_dprintf("%s: begin\n", __FUNCTION__);

	if (!using_dhcpc()) return 1;

	deconfig(nvram_safe_get("wan_ifname"));
	killall("udhcpc", SIGUSR2);
	unlink(renewing);
	unlink("/var/lib/misc/wan.connecting");
	
	_dprintf("%s: end\n", __FUNCTION__);
	return 0;
}

int dhcpc_renew_main(int argc, char **argv)
{
	int pid;

	_dprintf("%s: begin\n", __FUNCTION__);

	if (!using_dhcpc()) return 1;

	if ((pid = pidof("udhcpc")) > 1) {
		kill(pid, SIGUSR1);
		f_write(renewing, NULL, 0, 0, 0);
	}
	else {
		stop_dhcpc();
		start_dhcpc();
	}
	
	_dprintf("%s: end\n", __FUNCTION__);	
	return 0;
}


// -----------------------------------------------------------------------------


void start_dhcpc(void)
{
	char *argv[5];
	int argc;
	char *ifname;

	_dprintf("%s: begin\n", __FUNCTION__);

	nvram_set("wan_get_dns", "");
	f_write(renewing, NULL, 0, 0, 0);

	ifname = nvram_safe_get("wan_ifname");
	if (get_wan_proto() != WP_L2TP) {
		nvram_set("wan_iface", ifname);
	}

	argc = 0;
	argv[1] = nvram_safe_get("wan_hostname");
	if (*argv[1]) {
		argv[0] = "-H";
		argc = 2;
	}
	if (nvram_match("dhcpc_minpkt", "1")) argv[argc++] = "-m";
	argv[argc] = NULL;

	xstart(
		"udhcpc",
		"-i", ifname,
		"-l", nvram_safe_get("lan_ifname"),
		"-s", "dhcpc-event",
		argv[0],	// -H
		argv[1],	// wan_hostname
		argv[2]		// -m
	);
	
	_dprintf("%s: end\n", __FUNCTION__);
}

void stop_dhcpc(void)
{
	_dprintf("%s: begin\n", __FUNCTION__);

	killall("dhcpc-event", SIGTERM);
	if (killall("udhcpc", SIGUSR2) == 0) {	// release
		sleep(2);
	}
	killall_tk("udhcpc");
	unlink(renewing);
	
	_dprintf("%s: end\n", __FUNCTION__);
}

