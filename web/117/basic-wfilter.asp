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
<title>[<% ident(); %>] 基本設定：無線 - 存取控制</title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<link rel='stylesheet' type='text/css' href='color.css'>
<script type='text/javascript' src='tomato.js'></script>

<!-- / / / -->

<style type='text/css'>
#sm-grid {
	width: 80%;
}
#sm-grid .co1 {
	width: 30%;
}
#sm-grid .co2 {
	width: 70%;
}
</style>

<script type='text/javascript' src='debug.js'></script>

<script type='text/javascript'>

//	<% nvram("wl_macmode,wl_maclist,macnames"); %>

var smg = new TomatoGrid();

smg.verifyFields = function(row, quiet) {
	return v_mac(fields.getAll(row)[0], quiet);
}

smg.setup = function() {
	var i, i, m, s, t, n;
	var macs, names;
	
	this.init('sm-grid', 'sort', 50, [
		{ type: 'text', maxlen: 17 },
		{ type: 'text', maxlen: 48 }
	]);
	this.headerSet(['MAC 位址', '註解']);
	macs = nvram.wl_maclist.split(/\s+/);
	names = nvram.macnames.split('>');
	for (i = 0; i < macs.length; ++i) {
		m = fixMAC(macs[i]);
		if ((m) && (!isMAC0(m))) {
			s = m.replace(/:/g, '');
			t = '';
			for (j = 0; j < names.length; ++j) {
				n = names[j].split('<');
				if ((n.length == 2) && (n[0] == s)) {
					t = n[1];
					break;
				}
			}
			this.insertData(-1, [m, t]);
		}
	}
	this.sort(0);
	this.showNewEditor();
	this.resetNewEditor();
}

function save()
{
	var fom;
	var d, i, macs, names, ma, na;
	
	if (smg.isEditing()) return;

	fom = E('_fom');
	
	macs = [];
	names = [];
	d = smg.getAllData();
	for (i = 0; i < d.length; ++i) {
		ma = d[i][0];
		na = d[i][1].replace(/[<>|]/g, '');
		
		macs.push(ma);
		if (na.length) {
			names.push(ma.replace(/:/g, '') + '<' + na);
		}
	}
	fom.wl_maclist.value = macs.join(' ');
	fom.wl_macmode.value = E('_f_disable').checked ? 'disabled' : (E('_f_deny').checked ? 'deny' : 'allow');
	fom.macnames.value = names.join('>');
	form.submit(fom, 1);
}

function earlyInit()
{
	smg.setup();
	if (nvram.wl_macmode == 'allow') E('_f_allow').checked = 1;
		else if (nvram.wl_macmode == 'deny') E('_f_deny').checked = 1;
		else E('_f_disable').checked = 1;
}

function init()
{
	smg.recolor();
}
</script>
</head>
<body onload='init()'>
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

<input type='hidden' name='_nextpage' value='basic-wfilter.asp'>
<input type='hidden' name='_nextwait' value='10'>
<input type='hidden' name='_service' value='*'>

<input type='hidden' name='wl_macmode'>
<input type='hidden' name='wl_maclist'>
<input type='hidden' name='macnames'>


<div class='section-title'>無線 - 存取控制</div>
<div class='section'>
	<input type='radio' name='f_type' id='_f_disable' value='disabled'> 關閉<br>
	<input type='radio' name='f_type' id='_f_allow' value='allow'> 允許下列的 MAC 連線<br>
	<input type='radio' name='f_type' id='_f_deny' value='deny'> 拒絕下列的 MAC 連線<br>
	<br>
	<table id='sm-grid' class='tomato-grid'></table>
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
<script type='text/javascript'>earlyInit()</script>
</body>
</html>
