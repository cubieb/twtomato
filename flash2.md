# WHR-HP-G54 恢復至 BUFFALO 原廠韌體 #

隨著 非官方韌體的流行,許多人想躍躍欲試,問題是 用不慣 如何 恢復至 BUFFALO 官方韌體 ?
今天以 [Tomato](http://www.polarcloud.com/) 為範本 圖解恢復過程.


## **注意:** ##

恢復原廠預設值(reset 按鈕)  非常重要.

**[韌體 由 DD-WRT 官方網站 獲得](http://www.dd-wrt.com/dd-wrtv2/down.php?path=downloads%2Fothers%2Fbuffalo+factory+revert+/) (WHR-HP-G54 和 WHR-G54S)**


# 圖解 #

`
full reset = 斷電 ,按著 RESET 不放 ,開啟電源 30秒後放開 RESET.

> reset = 恢復原廠值
`

1 執行 full reset

2 電腦上的網卡只開啟一片

3 固定電腦 IP (192.168.1.2)

4 開啟 GUI介面 選擇 韌體 (192.168.1.1)

![http://lh4.google.com/ddwrt.taiwan/R8ZmGk-DopI/AAAAAAAAADI/O66jMQmlSm0/s800/ctoo.jpg](http://lh4.google.com/ddwrt.taiwan/R8ZmGk-DopI/AAAAAAAAADI/O66jMQmlSm0/s800/ctoo.jpg)

5 靜待數分鐘 (約3~5 分鐘 觀察 DIAG燈的變化)

6 改回 DHCP發放電腦IP

7 此時 WEBGUI 已經更換至 192.168.11.1 ,使用者名稱 root 密碼

8 做一次 full reset.

9 從 原廠 GUI 更新至您想要的 BUFALLO 版本即可.

10 完成