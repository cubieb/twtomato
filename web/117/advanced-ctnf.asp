﻿<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN'>
<!--
	Tomato GUI
	Copyright (C) 2006-2008 Jonathan Zarate
	http://www.polarcloud.com/tomato/

	For use with Tomato Firmware only.
	No part of this file may be used without permission.
-->
<html>
<head>
<meta http-equiv='content-type' content='text/html;charset=utf-8'>
<meta name='robots' content='noindex,nofollow'>
<title>[<% ident(); %>] 進階設定: 連接跟蹤 / 過濾</title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<link rel='stylesheet' type='text/css' href='color.css'>
<script type='text/javascript' src='tomato.js'></script>

<!-- / / / -->

<script type='text/javascript' src='debug.js'></script>

<script type='text/javascript'>

//	<% nvram("ct_tcp_timeout,ct_udp_timeout,ct_max,nf_l7in,nf_ttl,nf_rtsp,nf_pptp,nf_h323,nf_ftp"); %>

var checker = null;
var timer = new TomatoTimer(check);
var running = 0;

function check()
{
	timer.stop();
	if ((checker) || (!running)) return;

	checker = new XmlHttp();
	checker.onCompleted = function(text, xml) {
		var conntrack, total, i;
		conntrack = null;
		total = 0;
		try {
			eval(text);
		}
		catch (ex) {
			conntrack = [];
		}
		for (i = 1; i < 13; ++i) {
			E('count' + i).innerHTML = '&nbsp; <small>('+ ((conntrack[i] || 0) * 1) + ' 個連線數在這種狀態)</small>';
		}
		E('count0').innerHTML = '(' + ((conntrack[0] || 0) * 1) + ' 個連線數目前使用中)';
		checker = null;
		timer.start(3000);
	}
	checker.onError = function(x) {
		checker = null;
		timer.start(6000);
	}

	checker.post('update.cgi', 'exec=ctcount&arg0=0');
}

function clicked()
{
	running ^= 1;
	E('spin').style.visibility = running ? 'visible' : 'hidden';
	if (running) check();
}


var expireText;

function expireTimer()
{
	var e = E('expire');

	if (!expireText) expireText = e.value;

	if (--expireTime == 0) {
		e.disabled = false;
		e.value = expireText;
	}
	else {
		setTimeout(expireTimer, 1000);
		e.value = 'Expire Scheduled... ' + expireTime;
	}
}

function expireClicked()
{
	expireTime = 18;
	E('expire').disabled = true;
	(new XmlHttp()).post('expct.cgi', '');
	expireTimer();
}


function verifyFields(focused, quiet)
{
	var i, v;

	for (i = 0; i < 10; ++i) {
		if (!v_range('_f_tcp_' + i, quiet, 1, 432000)) return 0;
	}
	for (i = 0; i < 2; ++i) {
		if (!v_range('_f_udp_' + i, quiet, 1, 432000)) return 0;
	}
	return v_range('_ct_max', quiet, 128, 65535);
}

function save()
{
	var i, tcp, udp, fom;

	if (!verifyFields(null, false)) return;

	tcp = [];
	for (i = 0; i < 10; ++i) {
		tcp.push(E('_f_tcp_' + i).value);
	}
	
	udp = [];
	for (i = 0; i < 2; ++i) {
		udp.push(E('_f_udp_' + i).value);
	}
	
	fom = E('_fom');
	fom.ct_tcp_timeout.value = tcp.join(' ');
	fom.ct_udp_timeout.value = udp.join(' ');
	fom.nf_l7in.value = E('_f_l7in').checked ? 1 : 0;
	fom.nf_rtsp.value = E('_f_rtsp').checked ? 1 : 0;
	fom.nf_pptp.value = E('_f_pptp').checked ? 1 : 0;
	fom.nf_h323.value = E('_f_h323').checked ? 1 : 0;
	fom.nf_ftp.value = E('_f_ftp').checked ? 1 : 0;
	form.submit(fom, 1);
}
</script>

</head>
<body>
<form id='_fom' method='post' action='tomato.cgi'>
<table id='container' cellspacing=0>
<tr><td colspan=2 id='header'>
	<div class='title'>蕃茄(Tomato)</div>
	<div class='version'>(繁體/正體)中文版 <% version(); %></div>
</td></tr>
<tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
<td id='content'>
<div id='ident'><% ident(); %></div>

<!-- / / / -->

<input type='hidden' name='_nextpage' value='advanced-ctnf.asp'>
<input type='hidden' name='_service' value='ctnf-restart'>

<input type='hidden' name='ct_tcp_timeout' value=''>
<input type='hidden' name='ct_udp_timeout' value=''>
<input type='hidden' name='nf_l7in' value=''>
<input type='hidden' name='nf_rtsp'>
<input type='hidden' name='nf_pptp'>
<input type='hidden' name='nf_h323'>
<input type='hidden' name='nf_ftp'>

<div class='section-title'>連線數</div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
	{ title: '最大連線數量', name: 'ct_max', type: 'text', maxlen: 5, size: 7,
		suffix: '&nbsp; <a href="javascript:clicked()" id="count0">[ 顯示目前的連線數 ]</a> <img src="spin.gif" style="vertical-align:bottom;padding-left:10px;visibility:hidden" id="spin" onclick="clicked()">',
		value: fixInt(nvram.ct_max || 2048, 128, 65535, 2048) }
]);
</script>
<br>
<input type='button' value='清除逾時' onclick='expireClicked()' id='expire'>
<br><br>
</div>


<div class='section-title'>TCP 逾時</div>
<div class='section'>
<script type='text/javascript'>
if ((v = nvram.ct_tcp_timeout.match(/^(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)$/)) == null) {
	v = [0,1800,14400,120,60,120,120,10,60,30,120];
}
titles = ['-', 'None', 'Established', 'SYN Sent', 'SYN Received', 'FIN Wait', 'Time Wait', 'Close', 'Close Wait', 'Last ACK', 'Listen'];
f = [{ title: ' ', text: '<small>(秒)</small>' }];
for (i = 1; i < 11; ++i) {
	f.push({ title: titles[i], name: ('f_tcp_' + (i - 1)),
		type: 'text', maxlen: 6, size: 8, value: v[i],
		suffix: '<span id="count' + i + '"></span>' });
}
createFieldTable('', f);
</script>
</div>

<div class='section-title'>UDP 逾時</div>
<div class='section'>
<script type='text/javascript'>
if ((v = nvram.ct_udp_timeout.match(/^(\d+)\s+(\d+)$/)) == null) {
	v = [0,30,180];
}
createFieldTable('', [
	{ title: ' ', text: '<small>(秒)</small>' },
	{ title: 'Unreplied', name: 'f_udp_0', type: 'text', maxlen: 6, size: 8, value: v[1], suffix: '<span id="count11"></span>' },
	{ title: 'Assured', name: 'f_udp_1', type: 'text', maxlen: 6, size: 8, value: v[2], suffix: '<span id="count12"></span>' }
]);
</script>
</div>

<div class='section-title'>Tracking / NAT 增強模組</div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
	{ title: 'FTP', name: 'f_ftp', type: 'checkbox', value: nvram.nf_ftp != '0' },
	{ title: 'GRE / PPTP', name: 'f_pptp', type: 'checkbox', value: nvram.nf_pptp != '0' },
	{ title: 'H.323', name: 'f_h323', type: 'checkbox', value: nvram.nf_h323 != '0' },
	{ title: 'RTSP', name: 'f_rtsp', type: 'checkbox', value: nvram.nf_rtsp != '0' }
]);
</script>
</div>

<div class='section-title'>其他</div>
<div class='section'>
<script type='text/javascript'>
v = [];
for (i = -5; i <= 5; ++i) {
	v.push([i, i ? ((i > 0) ? '+' : '') + i : 'None']);
}
createFieldTable('', [
	{ title: 'TTL 調整', name: 'nf_ttl', type: 'select', options: v, value: nvram.nf_ttl },
	{ title: '下載時 啟用應用層過濾', name: 'f_l7in', type: 'checkbox', value: nvram.nf_l7in != '0' }
]);
</script>
</div>

<!-- / / / -->

</td></tr>
<tr><td id='footer' colspan=2>
	<span id='footer-msg'></span>
	<input type='button' value='儲存' id='save-button' onclick='save()'>
	<input type='button' value='取消' id='cancel-button' onclick='reloadPage();'>
</td></tr>
</table>
</form>
<script type='text/javascript'>verifyFields(null, 1);</script>
</body>
</html>
