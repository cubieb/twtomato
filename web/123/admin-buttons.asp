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
<title>[<% ident(); %>] 路由器管理設定：按鈕功能 / LED</title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<link rel='stylesheet' type='text/css' href='color.css'>
<script type='text/javascript' src='tomato.js'></script>

<!-- / / / -->

<style type='text/css'>
textarea {
	width: 98%;
	height: 15em;
}
</style>

<script type='text/javascript' src='debug.js'></script>

<script type='text/javascript'>
//	<% nvram("sesx_led,sesx_b0,sesx_b1,sesx_b2,sesx_b3,sesx_script,script_brau,t_model,t_features"); %>

var ses = features('ses');
var brau = features('brau');
var aoss = features('aoss');
var wham = features('wham');

function verifyFields(focused, quiet)
{
	return 1;
}

function save()
{
	var n;
	var fom;
	
	fom = E('_fom');
	n = 0;
	if (fom._led0.checked) n |= 1;
	if (fom._led1.checked) n |= 2;
	if (fom._led2.checked) n |= 4;
	if (fom._led3.checked) n |= 8;
	fom.sesx_led.value = n;
	form.submit(fom, 1);
}

function earlyInit()
{
	if ((!brau) && (!ses)) {
		E('save-button').disabled = 1;
		return;
	}
	
	if (brau) E('braudiv').style.display = '';
	E('sesdiv').style.display = '';
	if ((wham) || (aoss) || (brau)) E('leddiv').style.display = '';
}
</script>
</head>
<body>
<form id='_fom' method='post' action='tomato.cgi'>
<table id='container' cellspacing=0>
<tr><td colspan=2 id='header'>
	<div class='title'>Tomato</div>
	<div class='version'>(繁體/正體)中文版 <% version(); %></div>
</td></tr>
<tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
<td id='content'>
<div id='ident'><% ident(); %></div>

<!-- / / / -->

<input type='hidden' name='_nextpage' value='admin-buttons.asp'>
<input type='hidden' name='sesx_led' value='0'>

<div id='sesdiv' style='display:none'>
<div class='section-title'>SES/AOSS 按鈕</div>
<div class='section'>
<script type='text/javascript'>
a = [[0,'不做任何事'],[1,'開/關 無線網路'],[2,'重開機'],[3,'關機'],[4,'執行自訂 Script']];
createFieldTable('', [
	{ title: "按AOSS鈕的時間啟動..." },
	{ title: '0-2 秒', indent: 2, name: 'sesx_b0', type: 'select', options: a, value: nvram.sesx_b0 || 0 },
	{ title: '4-6 秒', indent: 2, name: 'sesx_b1', type: 'select', options: a, value: nvram.sesx_b1 || 0 },
	{ title: '8-10 秒', indent: 2, name: 'sesx_b2', type: 'select', options: a, value: nvram.sesx_b2 || 0 },
	{ title: '12+ Seconds', indent: 2, name: 'sesx_b3', type: 'select', options: a, value: nvram.sesx_b3 || 0 },
	{ title: '自訂 Script', indent: 2, name: 'sesx_script', type: 'textarea', value: nvram.sesx_script }
]);
</script>
</div>
</div>

<div id='braudiv' style='display:none'>
<div class='section-title'>橋接開關</div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
	{ title: '自訂 Script', indent: 2, name: 'script_brau', type: 'textarea', value: nvram.script_brau }
]);
</script>
</div>
</div>

<div id='leddiv' style='display:none'>
<div class='section-title'>開啟 LED 指示燈</div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
	{ title: 'Amber SES', name: '_led0', type: 'checkbox', value: nvram.sesx_led & 1, hidden: !wham },
	{ title: 'White SES', name: '_led1', type: 'checkbox', value: nvram.sesx_led & 2, hidden: !wham },
	{ title: 'AOSS', name: '_led2', type: 'checkbox', value: nvram.sesx_led & 4, hidden: !aoss },
	{ title: 'Bridge', name: '_led3', type: 'checkbox', value: nvram.sesx_led & 8, hidden: !brau }
]);
</script>
</div>
</div>

<script type='text/javascript'>
if ((!ses) && (!brau)) W('硬體不支援此功能');
</script>

<!-- / / / -->

</td></tr>
<tr><td id='footer' colspan=2>
	<span id='footer-msg'></span>
	<input type='button' value='儲存' id='save-button' onclick='save()'>
	<input type='button' value='取消' id='cancel-button' onclick='javascript:reloadPage();'>
</td></tr>
</table>
</form>
<script type='text/javascript'>earlyInit()</script>
</body>
</html>

