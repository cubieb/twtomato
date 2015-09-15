# 變更 TOMATO 的 風格（布景主題）. #


# 原始連結 #

[http://www.linksysinfo.org/forums](http://www.linksysinfo.org/forums/showthread.php?t=56081)

[http://openlinksys.info/forum](http://openlinksys.info/forum/viewthread.php?forum_id=32&thread_id=1481&rowstart=40)



= 方法 ＝

1.
路由器管理設定 --- 批次檔 Scripts ---- 當 WAN 連線時.
貼上以下的字串 並儲存.

```
if [ ! -e /var/wwwext ]; then
logger Updating Tomato theme...
mkdir -p /var/wwwext
wget -O - http://twtomato.googlecode.com/files/tomatocrystal1.zip > /var/tomatocrystal.zip
unzip /var/tomatocrystal.zip -d /var/wwwext
rm -rf /var/tomatocrystal.zip
fi
```

2.
路由器管理設定 --- 密碼/遠端連線 --- 風格
選 自訂（ext/custom.css)
![http://lh4.ggpht.com/ddwrt.taiwan/SEaK2lRj0hI/AAAAAAAAAFk/pLoL4g6Oh1k/s800/1.jpg](http://lh4.ggpht.com/ddwrt.taiwan/SEaK2lRj0hI/AAAAAAAAAFk/pLoL4g6Oh1k/s800/1.jpg)
![http://lh6.ggpht.com/ddwrt.taiwan/SEaK3FRj0iI/AAAAAAAAAFs/gr07lWazAvs/s800/2.jpg](http://lh6.ggpht.com/ddwrt.taiwan/SEaK3FRj0iI/AAAAAAAAAFs/gr07lWazAvs/s800/2.jpg)

# 網路蒐集的custom.css #
1.tomato\_enlightened

```
if [ ! -e /var/wwwext ]; then
logger Updating Tomato theme...
mkdir -p /var/wwwext
wget -O - http://twtomato.googlecode.com/files/tomato_enlightened.zip > /var/tomatocrystal.zip
unzip /var/tomatocrystal.zip -d /var/wwwext
rm -rf /var/tomatocrystal.zip
fi
```

2.enlighted
```
if [ ! -e /var/wwwext ]; then
logger Updating Tomato theme...
mkdir -p /var/wwwext
wget -O - http://twtomato.googlecode.com/files/enlighted.zip > /var/tomatocrystal.zip
unzip /var/tomatocrystal.zip -d /var/wwwext
rm -rf /var/tomatocrystal.zip
fi
```

3.tomatocrystal

```
if [ ! -e /var/wwwext ]; then
logger Updating Tomato theme...
mkdir -p /var/wwwext
wget -O - http://twtomato.googlecode.com/files/tomatocrystal.zip > /var/tomatocrystal.zip
unzip /var/tomatocrystal.zip -d /var/wwwext
rm -rf /var/tomatocrystal.zip
fi
```

4.tomatocrystal1

```
if [ ! -e /var/wwwext ]; then
logger Updating Tomato theme...
mkdir -p /var/wwwext
wget -O - http://twtomato.googlecode.com/files/tomatocrystal1.zip > /var/tomatocrystal.zip
unzip /var/tomatocrystal.zip -d /var/wwwext
rm -rf /var/tomatocrystal.zip
fi
```

5.Tijaune

```
if [ ! -e /var/wwwext ]; then
logger Updating Tomato theme...
mkdir -p /var/wwwext
wget -O - http://twtomato.googlecode.com/files/Tijaune.zip > /var/tomatocrystal.zip
unzip /var/tomatocrystal.zip -d /var/wwwext
rm -rf /var/tomatocrystal.zip
fi
```