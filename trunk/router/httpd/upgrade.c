/*

	Tomato Firmware
	Copyright (C) 2006-2008 Jonathan Zarate

*/

#include "tomato.h"

#include <fcntl.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/statfs.h>
#include <sys/wait.h>
#include <typedefs.h>
#include <sys/reboot.h>

#if 1
#define MTD_WRITE_CMD	"mtd-write"
#else
#define DEBUG_TEST
#define MTD_WRITE_CMD	"/tmp/mtd-write"
#endif

void prepare_upgrade(void)
{
	int n;

	// stop non-essential stuff & free up some memory
	exec_service("upgrade-start");
	for (n = 30; n > 0; --n) {
		sleep(1);
		if (nvram_match("action_service", "")) break;	// this is cleared at the end
	}
	unlink("/var/log/messages");
	unlink("/var/log/messages.0");
	sync();
}

void wi_upgrade(char *url, int len, char *boundary)
{
	uint8 buf[1024];
	const char *error = "讀取檔案時發生錯誤";
	int ok = 0;
	int n;
	
	check_id();

	// quickly check if JFFS2 is mounted by checking if /jffs/ is not squashfs
	struct statfs sf;
	if ((statfs("/jffs", &sf) != 0) || (sf.f_type != 0x73717368)) {
		error = "JFFS2 正在使用. 升級時資料可能會遺失 "
			"請備份資料後 關閉 JFFS2 並重開 ROUTER";
		goto ERROR;
	}
	
	// skip the rest of the header
	if (!skip_header(&len)) goto ERROR;

	if (len < (1 * 1024 * 1024)) {
		error = "不正確的檔案";
		goto ERROR;
	}

	// -- anything after here ends in a reboot --
	
	rboot = 1;

	led(LED_DIAG, 1);
	
	signal(SIGTERM, SIG_IGN);
	signal(SIGINT, SIG_IGN);
	signal(SIGHUP, SIG_IGN);
	signal(SIGQUIT, SIG_IGN);

	prepare_upgrade();
	system("cp reboot.asp /tmp");	// copy to memory

	char fifo[] = "/tmp/flashXXXXXX";
	int pid = -1;
	FILE *f = NULL;
	
	if ((mktemp(fifo) == NULL) ||
		(mkfifo(fifo, S_IRWXU) < 0)) {
		error = "無法建立 fifo";
		goto ERROR2;
	}

	char *wargv[] = { MTD_WRITE_CMD, "-w", "-i", fifo, "-d", "linux", NULL };
	if (_eval(wargv, ">/tmp/.mtd-write", 0, &pid) != 0) {
		error = "無法啟動 flash program";
		goto ERROR2;
	}

	if ((f = fopen(fifo, "w")) == NULL) {
		error = "Unable to start pipe for mtd write";
		goto ERROR2;
	}
	
	// !!! This will actually write the boundary. But since mtd-write
	// uses trx length... -- zzz

	while (len > 0) {
		 if ((n = web_read(buf, MIN(len, sizeof(buf)))) <= 0) {
			 goto ERROR2;
		 }
		 len -= n;
		 if (safe_fwrite(buf, 1, n, f) != n) {
			 error = "Error writing to pipe";
			 goto ERROR2;
		 }
	}

	error = NULL;
	ok = 1;

ERROR2:
	rboot = 1;
	set_action(ACT_REBOOT);

	if (f) fclose(f);
	if (pid != -1) waitpid(pid, &n, 0);

	resmsg_fread("/tmp/.mtd-write");

	web_eat(len);
	return;

ERROR:
	resmsg_set(error);
	web_eat(len);
}

void wo_flash(char *url)
{
	if (rboot) {
		parse_asp("/tmp/reboot.asp");
		web_close();

#ifdef DEBUG_TEST
		printf("\n\n -- reboot -- \n\n");
		set_action(ACT_IDLE);
#else
		killall("pppoecd", SIGTERM);
		sleep(2);
		//	kill(1, SIGTERM);
		reboot(RB_AUTOBOOT);
#endif
		exit(0);
	}

	parse_asp("error.asp");
}
