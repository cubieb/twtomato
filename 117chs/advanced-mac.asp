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
<title>[<% ident(); %>] 高级设置:  MAC地址设置</title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<link rel='stylesheet' type='text/css' href='color.css'>
<script type='text/javascript' src='tomato.js'></script>

<!-- / / / -->

<script type='text/javascript' src='debug.js'></script>

<script type='text/javascript'>

//	<% nvram("et0macaddr,mac_wan,mac_wl"); %>

defmac = {
	wan: et0plus(1),
	wl: et0plus(2)
};

function et0plus(plus)
{
	var mac = nvram.et0macaddr.split(':');
	if (mac.length != 6) return '';
	while (plus-- > 0) {
		for (var i = 5; i >= 3; --i) {
			var n = (parseInt(mac[i], 16) + 1) & 0xFF;
			mac[i] = n.hex(2);
			if (n != 0) break;
		}
	}
	return mac.join(':');
}

function bdefault(which)
{
	E('_f_mac_' + which).value = defmac[which];
	verifyFields(null, true);
}

function brand(which)
{
	var mac;
	var i;

	mac = ['00'];
	for (i = 5; i > 0; --i)
		mac.push(Math.floor(Math.random() * 255).hex(2));
	E('_f_mac_' + which).value = mac.join(':');
	verifyFields(null, true);
}

function bclone(which)
{
	E('_f_mac_' + which).value = '<% compmac(); %>';
	verifyFields(null, true);
}

function verifyFields(focused, quiet)
{
	if (v_mac('_f_mac_wan', quiet) && v_mac('_f_mac_wl', quiet)) {
		if (E('_f_mac_wan').value != E('_f_mac_wl').value) return 1;
		ferror.set('_f_mac_wan', '地址不能重复', quiet);
	}
	return 0;
}

function save()
{
	if (!verifyFields(null, false)) return;
	if (!confirm("警告: 改变MAC地址有可能需要把联机到这台路由器的设备, 计算机或调制解调器重新开机. 是否继续执行?")) return

	var fom = E('_fom');
	fom.mac_wan.value = (fom._f_mac_wan.value == defmac.wan) ? '' : fom._f_mac_wan.value;
	fom.mac_wl.value = (fom._f_mac_wl.value == defmac.wl) ? '' : fom._f_mac_wl.value;
	form.submit(fom, 1);
}
</script>
</head>
<body>
<form id='_fom' method='post' action='tomato.cgi'>
<table id='container' cellspacing=0>
<tr><td colspan=2 id='header'>
	<div class='title'>蕃茄(Tomato)</div>
	<div class='version'>简体中文版 <% version(); %></div>
</td></tr>
<tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
<td id='content'>
<div id='ident'><% ident(); %></div>

<!-- / / / -->

<input type='hidden' name='_nextpage' value='advanced-mac.asp'>
<input type='hidden' name='_nextwait' value='10'>
<input type='hidden' name='_service' value='*'>

<input type='hidden' name='mac_wan'>
<input type='hidden' name='mac_wl'>

<div class='section-title'>MAC地址</div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
	{ title: 'WAN的MAC地址', indent: 1, name: 'f_mac_wan', type: 'text', maxlen: 17, size: 20,
		suffix: ' <input type="button" value="默认" onclick="bdefault(\'wan\')"> <input type="button" value="随机" onclick="brand(\'wan\')"> <input type="button" value="克隆 PC 的 MAC" onclick="bclone(\'wan\')">',
		value: nvram.mac_wan || defmac.wan },
	{ title: 'Wireless 的 MAC', indent: 1, name: 'f_mac_wl', type: 'text', maxlen: 17, size: 20,
		suffix:' <input type="button" value="默认" onclick="bdefault(\'wl\')"> <input type="button" value="随机" onclick="brand(\'wl\')"> <input type="button" value="克隆 PC 的 MAC" onclick="bclone(\'wl\')">',
		value: nvram.mac_wl || defmac.wl }
]);
</script>
<br>
<table border=0 cellpadding=1>
	<tr><td>路由器 MAC地址:</td><td><b><% nv('et0macaddr'); %></b></td></tr>
	<tr><td>电脑网卡MAC地址:</td><td><b><% compmac(); %></b></td></tr>
</table>
</div>



<!-- / / / -->

</td></tr>
<tr><td id='footer' colspan=2>
	<span id='footer-msg'></span>
	<input type='button' value='保存设置' id='save-button' onclick='save()'>
	<input type='button' value='取消设置' id='cancel-button' onclick='reloadPage();'>
</td></tr>
</table>
</form>
<script type='text/javascript'>verifyFields(null, 1);</script>
</body>
</html>