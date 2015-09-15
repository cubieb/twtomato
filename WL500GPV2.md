# ASUS WL-500GP v2 刷 TOMATO #

## **硬體資訊** ##

由 [ASUS 機器規格表](http://oleg.wl500g.info/devices.html) 獲得硬體資訊.

| **Model** | **CPU** | **Switch** | **Radio** | **RAM** | **FLASH** | **USB** |
|:----------|:--------|:-----------|:----------|:--------|:----------|:--------|
| WL-500g Premium V2 (WL-500gpv2) | BCM5354 240MHz | SoC        | 802.11g (SoC) |	32MB DDR 16bit | 8MB       | 2 x 2.0 (SoC + USB2520)|


| ID | HW**| boardtype**| boardnum | boardrev | boardflags | others |
|:---|:--|:|:---------|:---------|:-----------|:-------|
| WL-500G Premium v2| BCM5354 | 0x48E | 45       | 0x10     | 0x0750     | sdram\_config=0x0062 sdram\_init=0x000B|

WL-500GP V2 為 All in one 機型.

32 MBytes DDR RAM

FLASH 8 MBytes

CPU BCM5354 240MHz

USB 2.0 兩個

# 刷機很簡單 #

這次使用 TFTP 工具軟體.tftp 為視窗版 retry 次數可自由設定(ASUS提供的 Firmware Restoration 也可用).

[tftp 程式 由 DD-WRT 官方網站 獲得](http://www.dd-wrt.com/dd-wrtv2/down.php?path=downloads%2Fothers%2Ftornado%2FWindows-TFTP/)


## **注意:** ##
刷機有風險,機器保固可能會喪失

恢復原廠預設值(restore 按鈕)  非常重要.

可輕易的 TFTP 原廠韌體

需使用 Tomato\_ND 的韌體

WEBGUI 顯示的型號為 Broadcom 5/0x48E/45/0x10/0x0750

# 開始 #

1 原廠韌體 執行 reset 或 按後方的 restore 鈕(ROUTER IP 變成 192.168.1.1.

2 [這裡取得 TOMATO＿ND 的韌體](http://www.polarcloud.com/tomato)

3. 固定電腦 IP (192.168.1.2)

4. 開啟 TFTP 程式

5. 拔除 WL-500GP V2 的電源 ,接著按機器後方的 RESTORE 不放,並恢復電源. 直到面版的 電源指示燈 開始閃爍.

6. TFTP 上傳 TOMATO＿ND.trx

![http://lh3.ggpht.com/ddwrt.taiwan/SF5AuSNnzNI/AAAAAAAAAHo/Z2xhuj4Ri7o/s800/tftp.jpg](http://lh3.ggpht.com/ddwrt.taiwan/SF5AuSNnzNI/AAAAAAAAAHo/Z2xhuj4Ri7o/s800/tftp.jpg)

7. 靜待數分鐘 (約3~5 分鐘)

8. 改回 DHCP發放電腦IP.

![http://lh4.google.com/ddwrt.taiwan/R8ZmBk-DomI/AAAAAAAAACw/U0tTKgpfDE4/s400/buff2toma4.jpg](http://lh4.google.com/ddwrt.taiwan/R8ZmBk-DomI/AAAAAAAAACw/U0tTKgpfDE4/s400/buff2toma4.jpg)

9 此時 WEBGUI 已經換 TOMATO ,使用者名稱 root 密碼 admin

10. 清除 NVRAM ---完整

![http://lh4.ggpht.com/ddwrt.taiwan/SF5Ao4ZupQI/AAAAAAAAAHA/vDw80RTJEL4/s800/reset.jpg](http://lh4.ggpht.com/ddwrt.taiwan/SF5Ao4ZupQI/AAAAAAAAAHA/vDw80RTJEL4/s800/reset.jpg)

11. telnet 進去機器 輸入   (※2008/08/06 註 TOMATO\_1.21\_ND 以後的版本不須修改 ）
```
nvram set vlan1ports="4 5"
nvram commit
reboot
```

![http://lh3.ggpht.com/ddwrt.taiwan/SF5AuD5IW1I/AAAAAAAAAHg/3EzLjtYROe4/s800/fixwan.jpg](http://lh3.ggpht.com/ddwrt.taiwan/SF5AuD5IW1I/AAAAAAAAAHg/3EzLjtYROe4/s800/fixwan.jpg)


# WL-500GP V2 & TOMATO＿ND 抓圖(修改過的風格） #

![http://lh6.ggpht.com/ddwrt.taiwan/SF5Av0p0XuI/AAAAAAAAAHw/w9d07Pw9hvY/s800/index.jpg](http://lh6.ggpht.com/ddwrt.taiwan/SF5Av0p0XuI/AAAAAAAAAHw/w9d07Pw9hvY/s800/index.jpg)

![http://lh3.ggpht.com/ddwrt.taiwan/SF5AwXarZhI/AAAAAAAAAH4/dhxMq_hJISw/s800/wlsurvey.jpg](http://lh3.ggpht.com/ddwrt.taiwan/SF5AwXarZhI/AAAAAAAAAH4/dhxMq_hJISw/s800/wlsurvey.jpg)

![http://lh3.ggpht.com/ddwrt.taiwan/SF5AqSE35BI/AAAAAAAAAHQ/034UXwpmHsk/s800/24bw.jpg](http://lh3.ggpht.com/ddwrt.taiwan/SF5AqSE35BI/AAAAAAAAAHQ/034UXwpmHsk/s800/24bw.jpg)

![http://lh4.ggpht.com/ddwrt.taiwan/SF5Atw2aWqI/AAAAAAAAAHY/YR-dTGDdoY0/s800/bootlog.jpg](http://lh4.ggpht.com/ddwrt.taiwan/SF5Atw2aWqI/AAAAAAAAAHY/YR-dTGDdoY0/s800/bootlog.jpg)

![http://lh3.ggpht.com/ddwrt.taiwan/SF5ApgXyZlI/AAAAAAAAAHI/YRd_r07ExVA/s800/wireless.jpg](http://lh3.ggpht.com/ddwrt.taiwan/SF5ApgXyZlI/AAAAAAAAAHI/YRd_r07ExVA/s800/wireless.jpg)



