# 刷 TOMATO 最高 效能/金錢 比的機器 #

由 [ASUS 機器規格表](http://oleg.wl500g.info/devices.html) 以及手邊機器實測.
WL-500GP V1 推薦使用 .

MINI PCI 內建 方便替換 WIFI 卡

RAM 32 MBytes DDR

FLASH 8 MBytes

CPU 264MHz 可 OC 300MHz

USB 2.0 兩個 方便擴充

便宜


| **Applicant** | ASUSTeK Computer Inc. |
|:--------------|:----------------------|
| **FCC ID**    | MSQWL500GP            |

| **Device** | **Vendor** | **Serial** | **Comment** |
|:-----------|:-----------|:-----------|:------------|
| Network Processor | Broadcom   | BCM4704KPBQ |             |
| WAN        | Broadcom   | AC101L     |             |
| LAN        | Broadcom   | BCM5325EKQMG |             |
| Wireless LAN | Broadcom   | BCM4318    | Mini-PCI    |
| USB Controller | VIA        | VT6212L    |             |


| Flash ROM 型號 | S29GL064M90TFIR7 |
|:-------------|:-----------------|
| 064M         | 64Mbit -> 8MByte |
| 90           | Speed Option     |
| T            | TSOP             |
| F            | Pb-Free          |
| I            | -40度 至 +85度      |
| [R7](https://code.google.com/p/twtomato/source/detail?r=7) | Model NO., x16, Vcc=3.0v 至 3.6v|


http://www.hynix.com/datasheet/pdf/dram/HY5DU281622ETP(Rev1.0).pdf


| Memory 型號 | HY5DU281622ETP-5 |
|:----------|:-----------------|
| Hynix     | 128Mbit(16MByte) CMOS Double Data Rate(DDR) Synchronous DRAM(SDRAM) |

| Power Supply | Clock Freq. | Max Data Rate | Interface | Package |
|:-------------|:------------|:--------------|:----------|:--------|
| VDD/VDQ=2.5v | 200MHz      | 400Mbps/pin   | SSTL\_2   | 66Pin TSOP |

| Freq. | CL | tRC | tRFC | RAS |
|:------|:---|:----|:-----|:----|
| 200MHz (5.0ns) | 3  | 12  | 14   | 8   |


| ID | HW**| boardtype**| boardnum | boardrev | boardflags | others |
|:---|:--|:|:---------|:---------|:-----------|:-------|
| WL-500G Premium | BCM4704\_BCM5325F | 0x042f | 45       | 0x10     | 0x0110     | hardware\_version=WL500gp-01-02-00-00 regulation\_domain=0X10US sdram\_init=0x0009 |
| WL-500G Premium | BCM4704\_BCM5325F | 0x042f | 45       | 0x10     | 0x0110     | hardware\_version=WL500gH-01-00-00-00 regulation\_domain=0X30DE sdram\_init=0x000b |
| WL-500G Premium | BCM4704\_BCM5325F | 0x042f | 45       | 0x10     | 0x0110     | hardware\_version=WL500gH-01-00-00-00 regulation\_domain=0X47TW sdram\_init=0x000b |


http://wl500g.dyndns.org/sdram.html


| **sdram\_init** | determines the memory controller operation mode | 0x000b |
|:----------------|:------------------------------------------------|:-------|
| Field           | Name                                            | Description | WL-500GP V1 |
| Bit 0           | MemType                                         | Memory type in use. |        |
|                 |                                                 | 0: SDR SDRAM |        |
|                 |                                                 | **1: DDR SDRAM** | `*`    |
| Bit 1           | 16BitMem                                        | Memory interface. |        |
|                 |                                                 | 0: 32-bit interface |        |
|                 |                                                 | **1: 16-bit interface** | `*`    |
| Bit 4:2         | ColWidth                                        |Column width in use. |        |
|                 |                                                 | 000: 8-bit column |        |
|                 |                                                 | **010: 9-bit column** | `*`    |
|                 |                                                 | 100: 10-bit column |        |
| Bit 13          | Clock                                           | Clock source |        |
|                 |                                                 | 0: External clock |        |
|                 |                                                 | 1: Internal clock |        |


| **sdram\_config** | initialize the mode register (during MRS cycle) | 0x000b |
|:------------------|:------------------------------------------------|:-------|
| MODE REGISTER SET (MRS) | store the various operating modes such as /CAS latency, burst length. etc. |
| Bit 0:2           | Burst Length                                    |
|                   | Sequential/Interleave                           |
|                   | 001: 2/2                                        |
|                   | 010: 4/4                                        |
|                   | 011: 8/8                                        |
| Bit 3             | Burst Type                                      |
|                   | 0: Sequential                                   |
|                   | 1: Interleave                                   |
| Bit 4:6           | CAS Latency                                     |
|                   | 011: 3                                          |
|                   | 100: 4                                          |
|                   | 101: 5                                          |
| Bit 7             | Test  Mode                                      |
|                   | 0: Normal                                       |
|                   | 1: Vendor test mode                             |
| Bit 8             | DLL Reset                                       |
|                   | 0: No                                           |
|                   | 1: Yes                                          |
| Bit 9:11          | RFU                                             |
|                   | 000 - All zero                                  |


---


WHR-HP-G54

ALL IN ONE  WIFI 卡 無法替換

RAM 16 MBytes SDRAM

FLASH 4 MBytes

CPU 200MHz 可 OC 250MHz

USB 無



簡易 傳輸率測試 比 WHR-HP-G54 好太多了.

在 DD-WRT 的測試下 WL-500GP (用oleg 韌體超過70M)超越 WHR-HP-G54 非常多.

用 TOMATO 之後應該會更好.

# 測試圖-SERVER 和 CLIENT沒變 只更換IP分享器和韌體 #
![http://lh5.google.com/bv22lk/RhjNExXlg-I/AAAAAAAAAEc/SbEOPlZmJv0/wl-500gp_oleg.jpg](http://lh5.google.com/bv22lk/RhjNExXlg-I/AAAAAAAAAEc/SbEOPlZmJv0/wl-500gp_oleg.jpg) WL-500GP FW:OLEG 1.9.2.7



![http://lh3.google.com/bv22lk/RhjNERXlg9I/AAAAAAAAAEU/wmW-kWkIF8M/wl-500gp_thr.jpg](http://lh3.google.com/bv22lk/RhjNERXlg9I/AAAAAAAAAEU/wmW-kWkIF8M/wl-500gp_thr.jpg) WL-500GP FW:DD-WRT 2007-04-06


![http://lh6.google.com/bv22lk/RhjQqBXlhBI/AAAAAAAAAFg/LU7h75PkAMA/whr-hp-g54_thr.jpg](http://lh6.google.com/bv22lk/RhjQqBXlhBI/AAAAAAAAAFg/LU7h75PkAMA/whr-hp-g54_thr.jpg) WHR-HP-G54 FW:DD-WRT 2007\_04\_06

未完 .....




Add your content here.  Format your content with:
  * Text in **bold** or _italic_
  * Headings, paragraphs, and lists
  * Automatic links to other wiki pages