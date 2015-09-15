http://wl500g.info/showthread.php?p=88858

有些版本的 WL-500GPv1 上的
WL-120 卡上 [R17](https://code.google.com/p/twtomato/source/detail?r=17) 應該為 62 Ω 電阻 但似乎放上 62K.

http://wl500g.info/showthread.php?t=13321&page=2

http://alexba2004.narod.ru/WL-500gp.htm

# 測試方法 #
1.
機器序號判斷

http://wl500g.info/showpost.php?p=87664&postcount=11
http://wl500g.info/showthread.php?t=13261&page=7


2.

原廠韌體由這裡進入

http://192.168.1.1/Main_AdmStatus_Content.asp

輸入 wl noise



-99 ～ -92 [R17](https://code.google.com/p/twtomato/source/detail?r=17) 為 62K 歐母 （錯誤的阻值）

-89 以下 [R17](https://code.google.com/p/twtomato/source/detail?r=17) 為 62 歐母 （正確的阻值）