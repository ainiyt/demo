#!/bin/bash
wifiip=$(ip addr |grep inet |grep -v inet6 |grep wlan0|awk '{print $2}' |awk -F "/" '{print $1}')

for rc in {1..3}

do
{
   if [ ! -f "/var/www/html/ip/index.html" ];then  >/dev/null
   mkdir /var/www/html/ip
   touch /var/www/html/ip/index.html

else


    > /var/www/html/ip/index.html
 cat <<EOF >>  /var/www/html/ip/index.html
       
	<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"> 
<title>导航</title> 
<style>
.center {
    text-align: center;
    border: 3px solid green;
}
</style>
</head>
<body>

<h2>地址导航2.6</h2>
<!--于2019/4/7更新
一键脚本-->
<div class="center">		
<h1><p>

        <a href="http://$wifiip:32400/web">PLEX在线家庭影院</a> </p>
        <a href="http://$wifiip:19999">性能实时监测 </a></p>	
	    <a href="http://$wifiip:8112">BT下载 </p>	
		<a href="http://$wifiip/AriaNG">AriaNG </p>
        <a href="http://$wifiip:5299">百度云下载 </p>
<!---->
        <a href="http://$wifiip:7788">文件同步 </p>	
        <a href="https://$wifiip:10000">终端</p>	
	
	    <a href="http://$wifiip/markdown-notepad">文档编辑</a></p>
        <a href="http://$wifiip/KodExplorer">可道云 </a> </p> 
		<a href="http://$wifiip/download">下载服务器 </a></p>	
		<h4><p style="text-align:left"><a href="https://www.52pojie.cn/thread-873221-1-1.html">.</a>
<!---->
<!---->

		

</h1>
</div>
<body background="1.jpg">
</body>
</html> 
EOF
	echo "--------html------done-----------"
echo "----------"
fi
}
done
