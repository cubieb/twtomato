########################################
#		Tomato GUI
#		Copyright (C) 2006-2009 Jonathan Zarate
#		http://www.polarcloud.com/tomato/
#
#		For use with Tomato Firmware only.
#		No part of this file may be used without permission.	
#--------------------------------------------------------
#		Tomato GUI �����(zh_TW.UTF-8)
#		����: 1.27
#		���v: GNU General Public License v2
#		http://code.google.com/p/twtomato/
#		http://digiland.tw/
########################################

:a $!N;s/text {\(\n\)	font: 11px monospace;/text {\1	font-family: "Trebuchet MS", "Lucida Sans", Arial, monospace;font-size: 0.9em;/
s/var week = \['Sun','Mon','Tue','Wed','Thu','Fri','Sat'\];/var week = \['�P����','�P���@','�P���G','�P���T','�P���|','�P����','�P����'\];/g
:a $!N;s/#info {\(\n\)	font: 11px sans-serif;/#info {\1	font-family: "Trebuchet MS", "Lucida Sans", Arial, sans-serif;font-size: 0.9em;/
:a $!N;s/#tip-text {\(\n\)	font: 11px sans-serif;/#tip-text {\1	font-family: "Trebuchet MS", "Lucida Sans", Arial, sans-serif;font-size: 0.9em;/
s/var abc = \['Unclassified', 'Highest', 'High', 'Medium', 'Low', 'Lowest', 'Class A', 'Class B', 'Class C', 'Class D', 'Class E'\];/var abc = \['������', '�̰���', '����', '����', '�C��', '�̧C��', '�ϵ�', '�е�', '�ѵ�', '�ҵ�', '�ӵ�'\];/g
s/z += ' am';/z += ' �W��';/g
s/z += ' pm';/z += ' �U��';/g