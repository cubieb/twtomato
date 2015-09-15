# ASUS WL-520GU 刷 TOMATO #

## **硬體資訊** ##

由 [ASUS 機器規格表](http://oleg.wl500g.info/devices.html) 獲得硬體資訊 備註:CPU 頻率為 240MHZ 非 200MHZ.

| **Model** | **CPU** | **Switch** | **Radio** | **RAM** | **FLASH** | **USB** |
|:----------|:--------|:-----------|:----------|:--------|:----------|:--------|
| WL-520GU  | BCM5354 240MHz | SoC        | 802.11g (SoC) |	16MB SDR 16bit | 4MB       | 1 x 2.0 (SoC + USB2520)|


| ID | HW**| boardtype**| boardnum | boardrev | boardflags | others |
|:---|:--|:|:---------|:---------|:-----------|:-------|
| WL-520GU| BCM5354 | 0x48E | 45       | 0x10     | 0x0750     | sdram\_init=0x000A sdram\_config=0x0032 |

WL-520GU 為 All in one 機型.

16 MBytes SDRAM

FLASH 4 MBytes

CPU BCM5354 240MHz

USB 2.0 一個

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

5. 拔除 WL-520GU 的電源 ,接著按機器後方的 RESTORE 不放,並恢復電源. 直到面版的 電源指示燈 開始閃爍.

6. TFTP 上傳 TOMATO＿ND.trx

![http://lh3.ggpht.com/ddwrt.taiwan/SF5AuSNnzNI/AAAAAAAAAHo/Z2xhuj4Ri7o/s800/tftp.jpg](http://lh3.ggpht.com/ddwrt.taiwan/SF5AuSNnzNI/AAAAAAAAAHo/Z2xhuj4Ri7o/s800/tftp.jpg)

7. 靜待數分鐘 (約3~5 分鐘)

8. 改回 DHCP發放電腦IP.

![http://lh4.google.com/ddwrt.taiwan/R8ZmBk-DomI/AAAAAAAAACw/U0tTKgpfDE4/s400/buff2toma4.jpg](http://lh4.google.com/ddwrt.taiwan/R8ZmBk-DomI/AAAAAAAAACw/U0tTKgpfDE4/s400/buff2toma4.jpg)

9 此時 WEBGUI 已經換 TOMATO ,使用者名稱 root 密碼 admin

10. 清除 NVRAM ---完整

![http://lh4.ggpht.com/ddwrt.taiwan/SF5Ao4ZupQI/AAAAAAAAAHA/vDw80RTJEL4/s800/reset.jpg](http://lh4.ggpht.com/ddwrt.taiwan/SF5Ao4ZupQI/AAAAAAAAAHA/vDw80RTJEL4/s800/reset.jpg)

11. [參考 LeonChiou 於PCZONE所發表](http://www.pczone.com.tw/vbb3/post/1021138/7/)
```
登入主機後
nvram set lan_ifnames="vlan0 eth1"
nvram set vlan1ports="0 5"
nvram commit

reboot
```

# LeonChiou 於PCZONE所發表 #

因為賣了Vigor2910
買了ASUS 520GU
所以最近一直在試第三方的韌體！
DD-WRT v2.4、Oleg\_WL520gu-1.9.2.7-10
自己使用的情況 oleg 好用程度 遠大於DD-WRT（系統資源、開了QoS...）
而且oleg 超支援USB printer.
真是好用！

而剛剛看到說 Tomato\_1\_19\_ND 可支援 520gu
想說試試看！ 試了一段時間，都試不出來.....
於是想想再重慣oleg 去看看其設定，
竟然成功了，哈哈！
但是是否好用及其穩定度？...在等等我試試看了！
520gu真的是一台物超所值，效能大於Vigor2910..（這是我自己的看法！）
因為我有測試其throughput

跟大家講如果你是520gu，且想試試Tomato
那請你自己去下載 Tomato\_1\_19\_ND

登入主機後
```
# nvram set lan_ifnames="vlan0 eth1"
# nvram set vlan1ports="0 5"
# nvram commit
Commit... done.
# reboot
```

就可以使用了....試試吧！

![http://lh3.ggpht.com/ddwrt.taiwan/SGIlTNQo6ZI/AAAAAAAAAIw/xxQ2HRS9YTg/s800/520gu.png](http://lh3.ggpht.com/ddwrt.taiwan/SGIlTNQo6ZI/AAAAAAAAAIw/xxQ2HRS9YTg/s800/520gu.png)




