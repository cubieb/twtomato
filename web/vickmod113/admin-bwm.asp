<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN'>
<!--
	Tomato GUI
	Copyright (C) 2006-2007 Jonathan Zarate
	http://www.polarcloud.com/tomato/

	For use with Tomato Firmware only.
	No part of this file may be used without permission.
-->
<html>
<head>
<meta http-equiv='content-type' content='text/html;charset=utf-8'>
<meta name='robots' content='noindex,nofollow'>
<title>[<% ident(); %>] 路由器管理設定：頻寬監控設定</title>
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

//	<% nvram("rstats_enable,rstats_path,rstats_stime,rstats_offset,rstats_exclude,rstats_sshut,et0macaddr,cifs1,cifs2,jffs2_on"); %>

function fix(name)
{
	var i;
	if (((i = name.lastIndexOf('/')) > 0) || ((i = name.lastIndexOf('\\')) > 0))
		name = name.substring(i + 1, name.length);
	return name;
}

function backupButton()
{
	var name;

	name = fix(E('backup-name').value);
	if (name.length <= 1) {
		alert('Invalid filename');
		return;
	}
	location.href = 'bwm/' + name + '.gz';
}

function restoreButton()
{
	var fom;
	var name;
	var i;

	name = fix(E('restore-name').value);
	name = name.toLowerCase();
	if ((name.length <= 3) || (name.substring(name.length - 3, name.length).toLowerCase() != '.gz')) {
		alert('Incorrect filename. Expecting a ".gz" file.');
		return;
	}
	if (!confirm('Restore data from ' + name + '?')) return;

	E('restore-button').disabled = 1;
	fields.disableAll(E('config-section'), 1);
	fields.disableAll(E('backup-section'), 1);
	fields.disableAll(E('footer'), 1);

	E('restore-form').submit();
}

function getPath()
{
	var s = E('_f_loc').value;
	return (s == '*user') ? E('_f_user').value : s;
}

function verifyFields(focused, quiet)
{
	var b, v;
	var path;
	var eLoc, eUser, eTime, eOfs;

	eLoc = E('_f_loc');
	eUser = E('_f_user');
	eTime = E('_rstats_stime');
	eOfs = E('_rstats_offset');

	b = !E('_f_rstats_enable').checked;
	eLoc.disabled = b;
	eUser.disabled = b;
	eTime.disabled = b;
	eOfs.disabled = b;
	E('_f_new').disabled = b;
	E('_f_sshut').disabled = b;
	E('backup-button').disabled = b;
	E('backup-name').disabled = b;
	E('restore-button').disabled = b;
	E('restore-name').disabled = b;
	ferror.clear(eLoc);
	ferror.clear(eUser);
	ferror.clear(eOfs);
	if (b) return 1;

	path = getPath();
	E('newmsg').style.visibility = ((nvram.rstats_path != path) && (path != '*nvram') && (path != '')) ? 'visible' : 'hidden';

	v = eLoc.value;
	b = (v == '*user');
	elem.display(eUser, b);
	if (b) {
		if (!v_length(eUser, quiet, 2)) return 0;
		if (path.substr(0, 1) != '/') {
			ferror.set(eUser, 'Please start at the / root directory.', quiet);
			return 0;
		}
	}
	else if (v == '/jffs/') {
		if (nvram.jffs2_on != '1') {
			ferror.set(eLoc, 'JFFS2 is not enabled.', quiet);
			return 0;
		}
	}
	else if (v.match(/^\/cifs(1|2)\/$/)) {
		if (nvram['cifs' + RegExp.$1].substr(0, 1) != '1') {
			ferror.set(eLoc, 'CIFS #' + RegExp.$1 + ' is not enabled.', quiet);
			return 0;
		}
	}

	return v_range(eOfs, quiet, 1, 31);
}

function save()
{
	var fom, path, en, e, aj;

	if (!verifyFields(null, false)) return;

	aj = 1;
	en = E('_f_rstats_enable').checked;
	fom = E('_fom');
	fom._service.value = 'rstats-restart';
	if (en) {
		path = getPath();
		if (((E('_rstats_stime').value * 1) <= 48) &&
			((path == '*nvram') || (path == '/jffs/'))) {
			if (!confirm('Frequent saving to NVRAM or JFFS2 is not recommended. Continue anyway?')) return;
		}
		if ((nvram.rstats_path != path) && (fom.rstats_path.value != path) && (path != '') && (path != '*nvram') &&
			(path.substr(path.length - 1, 1) != '/')) {
			if (!confirm('Note: ' + path + ' will be treated as a file. If this is a directory, please use a trailing /. Continue anyway?')) return;
		}
		fom.rstats_path.value = path;

		if (E('_f_new').checked) {
			fom._service.value = 'rstatsnew-restart';
			aj = 0;
		}
	}

	fom.rstats_path.disabled = !en;
	fom.rstats_enable.value = en ? 1 : 0;
	fom.rstats_sshut.value = E('_f_sshut').checked ? 1 : 0;

	e = E('_rstats_exclude');
	e.value = e.value.replace(/\s+/g, ',').replace(/,+/g, ',');

	fields.disableAll(E('backup-section'), 1);
	fields.disableAll(E('restore-section'), 1);
	form.submit(fom, aj);
	if (en) {
		fields.disableAll(E('backup-section'), 0);
		fields.disableAll(E('restore-section'), 0);
	}
}
</script>

</head>
<body>
<table id='container' cellspacing=0>
<tr><td colspan=2 id='header'>
	<div class='title'>Tomato</div>
	<div class='version'>Version <% version(); %></div>
</td></tr>
<tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
<td id='content'>
<div id='ident'><% ident(); %></div>

<!-- / / / -->

<div class='section-title'>頻寬監控設定</div>
<div class='section' id='config-section'>
<form id='_fom' method='post' action='tomato.cgi'>
<input type='hidden' name='_nextpage' value='admin-bwm.asp'>
<input type='hidden' name='_service' value='rstats-restart'>
<input type='hidden' name='rstats_enable'>
<input type='hidden' name='rstats_path'>
<input type='hidden' name='rstats_sshut'>

<script type='text/javascript'>
switch (nvram.rstats_path) {
case '':
case '*nvram':
case '/jffs/':
case '/cifs1/':
case '/cifs2/':
	loc = nvram.rstats_path;
	break;
default:
	loc = '*user';
	break;
}
createFieldTable('', [
	{ title: '啟用', name: 'f_rstats_enable', type: 'checkbox', value: nvram.rstats_enable == '1' },
	{ title: '選擇儲存空間', multi: [
		{ name: 'f_loc', type: 'select', options: [['','RAM (Temporary)'],['*nvram','NVRAM'],['/jffs/','JFFS2'],['/cifs1/','CIFS 1'],['/cifs2/','CIFS 2'],['*user','Custom Path']], value: loc },
		{ name: 'f_user', type: 'text', maxlen: 48, size: 50, value: nvram.rstats_path }
	] },
	{ title: '儲存的頻率', indent: 2, name: 'rstats_stime', type: 'select', value: nvram.rstats_stime, options: [
		[1,'每小時'],[2,'每2小時'],[3,'每3小時'],[4,'每4小時'],[5,'每5小時'],[6,'每6小時'],
		[9,'每9小時'],[12,'每12小時'],[24,'每天'],[48,'每兩天'],[72,'每三天'],[96,'每四天'],
		[120,'Every 5 Days'],[144,'Every 6 Days'],[168,'Every Week']] },
	{ title: '關機時儲存', indent: 2, name: 'f_sshut', type: 'checkbox', value: nvram.rstats_sshut == '1' },
	{ title: 'Create New File /<br>Reset Data', indent: 2, name: 'f_new', type: 'checkbox', value: 0,
		suffix: ' &nbsp; <b id="newmsg" style="visibility:hidden"><small>(note: enable if this is a new file)</small></b>' },
	{ title: 'First Day Of The Month', name: 'rstats_offset', type: 'text', value: nvram.rstats_offset, maxlen: 2, size: 4 },
	{ title: '排除的介面', name: 'rstats_exclude', type: 'text', value: nvram.rstats_exclude, maxlen: 64, size: 50, suffix: '&nbsp;<small>(以 逗點 分隔例:eth0,vlan1)</small>' }
]);
</script>
</form>
</div>

<br>

<div class='section-title'>備份</div>
<div class='section' id='backup-section'>
	<form>
	<script type='text/javascript'>
	W("<input type='text' size='40' maxlength='64' id='backup-name' name='backup_name' value='tomato_rstats_" + nvram.et0macaddr.replace(/:/g, '').toLowerCase() + "'>");
	</script>
	.gz &nbsp;
	<input type='button' name='f_backup_button' id='backup-button' onclick='backupButton()' value='備份'>
	</form>
</div>

<br>

<div class='section-title'>回存</div>
<div class='section' id='restore-section'>
	<form id='restore-form' method='post' action='bwm/restore.cgi' encType='multipart/form-data'>
		<input type='file' size='40' id='restore-name' name='restore_name'>
		<input type='button' name='f_restore_button' id='restore-button' value='回存' onclick='restoreButton()'>
		<br>
	</form>
</div>


<!-- / / / -->

</td></tr>
<tr><td id='footer' colspan=2>
	<form>
	<span id='footer-msg'></span>	
	<input type='button' value='儲存' id='save-button' onclick='save()'>
	<input type='button' value='取消' id='cancel-button' onclick='javascript:reloadPage();'>
	</form>
</div>
</td></tr>
</table>
<script type='text/javascript'>verifyFields(null, 1);</script>
</body>
</html>
