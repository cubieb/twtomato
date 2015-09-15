# 簡易測試 #

1.TELNET 登入 TOMATO
2. cd /tmp
3.安裝 (裝在RAM 一關機就消失)

wget "http://wiki.openwrt.org/HardwarePerformance?action=AttachFile&do=get&target=openwrt_cpu_bench_v06.bin"

mv HardwarePerformance?action\=AttachFile\&do\=get\&target\=openwrt\_cpu\_bench\_v06.bin cpubench

chmod 777 cpubench

4.執行
> ./cpubench


# 機型 & 數據 #

WL-500GP v1 300MHz OS Tomato 1.19 -SpeedMOD  sdram\_config=0x0062 sdram\_ncdl=0x10505

| 2008-05-01 | ''Author'' | 4.8s | 9.2s | 10.2s | 5.1s | v0.6 | ''OS'' | ''DeviceModel'' | ''CPU model'' | ''CPU Frequency'' | ''LinkToHwPage'' |
|:-----------|:-----------|:-----|:-----|:------|:-----|:-----|:-------|:----------------|:--------------|:------------------|:-----------------|

WL-500GP v1 300MHz OS Tomato 1.19 -SpeedMOD  sdram\_config=0x0022 sdram\_ncdl=0x10005
| 2008-05-02 | ''Author'' | 4.8s | 9.3s | 10.2s | 5.2s | v0.6 | ''OS'' | ''DeviceModel'' | ''CPU model'' | ''CPU Frequency'' | ''LinkToHwPage'' |
|:-----------|:-----------|:-----|:-----|:------|:-----|:-----|:-------|:----------------|:--------------|:------------------|:-----------------|

WL-500GP v1 300MHz OS Tomato 1.19 -SpeedMOD  sdram\_config=0x0062 sdram\_ncdl=0x10308

| 2008-05-02 | ''Author'' | 4.8s | 9.3s | 10.3s | 5.2s | v0.6 | ''OS'' | ''DeviceModel'' | ''CPU model'' | ''CPU Frequency'' | ''LinkToHwPage'' |
|:-----------|:-----------|:-----|:-----|:------|:-----|:-----|:-------|:----------------|:--------------|:------------------|:-----------------|

WL-500GP v1 264MHz OS Tomato 1.19 -SpeedMOD  sdram\_config=0x0062 sdram\_ncdl=0x10406

| 2008-05-02 | ''Author'' | 5.6s | 10.6s | 11.6s | 5.9s | v0.6 | ''OS''| ''DeviceModel'' | ''CPU model'' | ''CPU Frequency'' | ''LinkToHwPage'' |
|:-----------|:-----------|:-----|:------|:------|:-----|:-----|:------|:----------------|:--------------|:------------------|:-----------------|

L-500GP v1 264MHz OS Tomato 1.19 -SpeedMOD  sdram\_config=0x0022 sdram\_ncdl=0x10407

| 2008-05-02 | ''Author'' | 5.4s | 10.6s | 12.5s | 6.6s | v0.6 | ''OS''| ''DeviceModel'' | ''CPU model'' | ''CPU Frequency'' | ''LinkToHwPage'' |
|:-----------|:-----------|:-----|:------|:------|:-----|:-----|:------|:----------------|:--------------|:------------------|:-----------------|

WHR-HP-G54 200MHz OS Tomato 1.19 -SpeedMOD

| 2008-05-01 | ''Author'' | 7.7s | 14.1s | 15.7s | 9.4s | v0.6 | ''OS''| ''DeviceModel'' | ''CPU model'' | ''CPU Frequency'' | ''LinkToHwPage'' |
|:-----------|:-----------|:-----|:------|:------|:-----|:-----|:------|:----------------|:--------------|:------------------|:-----------------|

WHR-HP-G54 240MHz OS Tomato 1.19 -SpeedMOD

| 2008-05-02 | ''Author'' | 6.4s | 11.8s | 13.1s | 7.8s | v0.6 | ''OS''| ''DeviceModel'' | ''CPU model'' | ''CPU Frequency'' | ''LinkToHwPage'' |
|:-----------|:-----------|:-----|:------|:------|:-----|:-----|:------|:----------------|:--------------|:------------------|:-----------------|

WL-500GP v2 240MHz OS DD-WRT RC-7-9433
| 2008-05-01 | ''Author'' | 6.8s | 13.1s | 13.3s | 7.1s | v0.6 | ''OS''| ''DeviceModel'' | ''CPU model'' | ''CPU Frequency'' | ''LinkToHwPage'' |
|:-----------|:-----------|:-----|:------|:------|:-----|:-----|:------|:----------------|:--------------|:------------------|:-----------------|