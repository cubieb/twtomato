<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN'>
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
<title>[<% ident(); %>] 路由器管理設定：網路芳鄰設定</title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<link rel='stylesheet' type='text/css' href='color.css'>
<script type='text/javascript' src='tomato.js'></script>

<!-- / / / -->

<script type='text/javascript' src='debug.js'></script>

<script type='text/javascript'>

//	<% nvram("cifs1,cifs2"); %>

function v_nodelim(e, quiet, name)
{
	e.value = e.value.trim();
	if (e.value.indexOf('<') != -1) {
		ferror.set(e, '錯誤的 ' + name, quiet);
		return 0;
	}
	ferror.clear(e);
	return 1;
}

function verifyFields(focused, quiet)
{
	var i, p, b;
	var unc, user, pass, dom, exec;

	for (i = 1; i <= 2; ++i) {
		p = '_f_cifs' + i;
		unc = E(p + '_unc');
		user = E(p + '_user');
		pass = E(p + '_pass');
		dom = E(p + '_dom');
		exec = E(p + '_exec');

		b = !E(p + '_enable').checked;
		unc.disabled = b;
		user.disabled = b;
		pass.disabled = b;
		exec.disabled = b;
		dom.disabled = b;
		if (!b) {
			if ((!v_nodelim(unc, quiet, 'UNC')) || (!v_nodelim(user, quiet, 'username')) || (!v_nodelim(pass, quiet, 'password')) ||
				 (!v_nodelim(dom, quiet, 'domain')) || (!v_nodelim(exec, quiet, 'exec path'))) return 0;
			if ((!v_length(user, quiet, 1)) || (!v_length(pass, quiet, 1))) return 0;
			unc.value = unc.value.replace(/\//g, '\\');
			if (!unc.value.match(/^\\\\.+\\/)) {
				ferror.set(unc, '錯誤的 UNC', quiet);
				return 0;
			}
		}
		else {
			ferror.clear(unc, user, pass, dom, exec);
		}
	}

	return 1;
}

function save()
{
	var i, p;

	if (!verifyFields(null, 0)) return;

	for (i = 1; i <= 2; ++i) {
		p = '_f_cifs' + i;
		E('cifs' + i).value = (E(p + '_enable').checked ? '1' : '0') + '<' + E(p + '_unc').value + '<' +
			E(p + '_user').value + '<' + E(p + '_pass').value + '<' + E(p + '_dom').value + '<' + E(p + '_exec').value
	}
	form.submit('_fom', 0);
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

<input type='hidden' name='_nextpage' value='admin-cifs.asp'>
<input type='hidden' name='_nextwait' value='10'>
<input type='hidden' name='_service' value='cifs-restart'>

<input type='hidden' name='cifs1' id='cifs1'>
<input type='hidden' name='cifs2' id='cifs2'>

<div class='section-title'>網路芳鄰</div>
<div class='section'>
<script type='text/javascript'>
a = b = [0, '\\\\192.168.1.5\\shared_example', '', '', '', ''];

if (r = nvram.cifs1.match(/^(0|1)<(\\\\.+)<(.*)<(.*)<(.*)<(.*)$/)) a = r.splice(1, 6);
if (r = nvram.cifs2.match(/^(0|1)<(\\\\.+)<(.*)<(.*)<(.*)<(.*)$/)) b = r.splice(1, 6);

//	<% statfs("/cifs1", "cifs1"); %>
//	<% statfs("/cifs2", "cifs2"); %>

createFieldTable('', [
	{ title: '/cifs1' },
	{ title: '開啟', indent: 2, name: 'f_cifs1_enable', type: 'checkbox', value: a[0]*1 },
	{ title: 'UNC', indent: 2, name: 'f_cifs1_unc', type: 'text', maxlen: 128, size: 64, value: a[1] },
	{ title: '使用者名稱', indent: 2, name: 'f_cifs1_user', type: 'text', maxlen: 32, size: 34, value: a[2] },
	{ title: '密碼', indent: 2, name: 'f_cifs1_pass', type: 'password', maxlen: 16, size: 34, value: a[3] },
	{ title: '網域', indent: 2, name: 'f_cifs1_dom', type: 'text', maxlen: 32, size: 34, value: a[4] },
	{ title: '掛載', indent: 2, name: 'f_cifs1_exec', type: 'text', maxlen: 64, size: 34, value: a[5] },
	{ title: '總容量/可用空間', indent: 2, text: cifs1.size ? (scaleSize(cifs1.size) + ' / ' + scaleSize(cifs1.free)) : '(未掛載)' },
	null,
	{ title: '/cifs2' },
	{ title: '開啟', indent: 2, name: 'f_cifs2_enable', type: 'checkbox', value: b[0]*1 },
	{ title: 'UNC', indent: 2, name: 'f_cifs2_unc', type: 'text', maxlen: 128, size: 64, value: b[1] },
	{ title: '使用者名稱', indent: 2, name: 'f_cifs2_user', type: 'text', maxlen: 64, size: 34, value: b[2] },
	{ title: '密碼', indent: 2, name: 'f_cifs2_pass', type: 'password', maxlen: 16, size: 34, value: b[3] },
	{ title: '網域', indent: 2, name: 'f_cifs2_dom', type: 'text', maxlen: 32, size: 34, value: b[4] },
	{ title: '掛載', indent: 2, name: 'f_cifs2_exec', type: 'text', maxlen: 64, size: 34, value: b[5] },
	{ title: '總容量/可用空間', indent: 2, text: cifs2.size ? (scaleSize(cifs2.size) + ' / ' + scaleSize(cifs2.free)) : '(未掛載)' }
]);
</script>
</div>

<script type='text/javascript'>show_notice1('<% notice("cifs"); %>');</script>


<!-- / / / -->

</td></tr>
<tr><td id='footer' colspan=2>
	<span id='footer-msg'></span>
	<input type='button' value='儲存' id='save-button' onclick='save()'>
	<input type='button' value='取消' id='cancel-button' onclick='javascript:reloadPage();'>
</td></tr>
</table>
</form>
<script type='text/javascript'>verifyFields(null, 1);</script>
</body>
</html>
