# 刷機很簡單 #

隨著 非官方韌體的流行,許多人想躍躍欲試,問題是 更新方法 大多是 command 介面,不夠親切.
非官方韌體中 [Open-WRT](http://www.openwrt.org) ,[DD-WRT](http://www.dd-wrt.com) ,[Tomato](http://www.polarcloud.com) 為大多數人使用. 今天以 Tomato 為範本 圖解刷新過程.
tftp 為視窗版 retry 次數可自由設定.


## **注意:** ##
刷機有風險,機器保固可能會喪失

恢復原廠預設值(reset 按鈕)  非常重要.

這個IP分享器 更新非常簡單且失敗率非常低 (幫朋友更新 & 自己亂刷 從未失敗)

tomato.trx 需更名為 tomato.bin

**[tftp 程式 由 DD-WRT 官方網站 獲得](http://www.dd-wrt.com/dd-wrtv2/down.php?path=downloads%2Fothers%2Ftornado%2FWindows-TFTP/)**


# 圖解 #

`
full reset = 斷電 ,按著 RESET 不放 ,開啟電源 30秒後放開 RESET.

> reset = 恢復原廠值
`

1 原廠韌體 執行 reset

2 電腦上的網卡只開啟一片

3 固定電腦 IP (192.168.11.2)

![http://lh5.google.com/ddwrt.taiwan/R8ZmB0-DonI/AAAAAAAAAC4/swX2SvToWco/s400/buff2toma.jpg](http://lh5.google.com/ddwrt.taiwan/R8ZmB0-DonI/AAAAAAAAAC4/swX2SvToWco/s400/buff2toma.jpg)


3.5 請同時開啟 TFTP 程式 和 原廠GUI介面.

4 TFTP 程式 選擇韌體並點選 **Upgrade** (**要緊接著執行第 5 個步驟**)

![http://lh3.google.com/ddwrt.taiwan/R8ZmBU-DokI/AAAAAAAAACg/awsyJ7HrTyM/s400/buff2toma2.jpg](http://lh3.google.com/ddwrt.taiwan/R8ZmBU-DokI/AAAAAAAAACg/awsyJ7HrTyM/s400/buff2toma2.jpg)

5 原廠GUI介面 (192.168.11.1) 點選 **Restar Now**

![http://lh6.google.com/ddwrt.taiwan/R8ZmBE-DojI/AAAAAAAAACY/xR9l2JIWbVg/s400/buff2toma1.jpg](http://lh6.google.com/ddwrt.taiwan/R8ZmBE-DojI/AAAAAAAAACY/xR9l2JIWbVg/s400/buff2toma1.jpg)"

6.TFTP上傳成功的畫面

![http://lh4.google.com/ddwrt.taiwan/R8ZmBk-DolI/AAAAAAAAACo/NgZsu-E7XsM/s400/buff2toma3.jpg](http://lh4.google.com/ddwrt.taiwan/R8ZmBk-DolI/AAAAAAAAACo/NgZsu-E7XsM/s400/buff2toma3.jpg)

7 **靜待數分鐘 (約3~5 分鐘 觀察 DIAG燈的變化)<------ 請注意**

8 改回 DHCP發放電腦IP

![http://lh4.google.com/ddwrt.taiwan/R8ZmBk-DomI/AAAAAAAAACw/U0tTKgpfDE4/s400/buff2toma4.jpg](http://lh4.google.com/ddwrt.taiwan/R8ZmBk-DomI/AAAAAAAAACw/U0tTKgpfDE4/s400/buff2toma4.jpg)

9 此時 WEBGUI 已經更換至 192.168.1.1 ,使用者名稱 root 密碼 admin

10 做一次 full reset.

11 完成


如何恢復至 BUFFALO 原廠韌體[點擊這裡](http://code.google.com/p/twtomato/wiki/flash2)