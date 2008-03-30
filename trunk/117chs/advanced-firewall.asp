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
<title>[<% ident(); %>] 高级设置: 防火墙设置</title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<link rel='stylesheet' type='text/css' href='color.css'>
<script type='text/javascript' src='tomato.js'></script>

<!-- / / / -->

<script type='text/javascript' src='debug.js'></script>

<script type='text/javascript'>

//	<% nvram("block_wan,multicast_pass,nf_loopback"); %>


function verifyFields(focused, quiet)
{
	return 1;
}

function save()
{
	var fom;

	if (!verifyFields(null, 0)) return;

	fom = E('_fom');
	fom.block_wan.value = E('_f_icmp').checked ? 0 : 1;
	fom.multicast_pass.value = E('_f_multicast').checked ? 1 : 0;
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

<input type='hidden' name='_nextpage' value='advanced-firewall.asp'>
<input type='hidden' name='_service' value='firewall-restart'>

<input type='hidden' name='block_wan'>
<input type='hidden' name='multicast_pass'>

<div class='section-title'>防火墙设置</div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
	{ title: '允许回应ICMP Ping', name: 'f_icmp', type: 'checkbox', value: nvram.block_wan == '0' },
	{ title: '允许多播', name: 'f_multicast', type: 'checkbox', value: nvram.multicast_pass == '1' },
	{ title: 'NAT Loopback', name: 'nf_loopback', type: 'select', options: [[0,'所有'],[1,'仅前转'],[2,'关闭']], value: fixInt(nvram.nf_loopback, 0, 2, 1) }
]);
</script>
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
