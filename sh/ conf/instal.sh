#!/bin/bash
if [ `whoami` = "root" ];then
	echo "Go"
else
  { mane=$(pwd)
    echo "需使用root用户"
	echo "请执行sudo -i 或者 su"
	echo "然后执行 bash $mane/install.sh"
	echo "-------------------------------"
	exit 0;
	}
fi

sudo apt-get install -y wget ca-certificates    apt-transport-https  curl net-tools  dpkg nano unzip gnupg lsof

rc_local=$(wget https://github.com/netend/demo/raw/master/sh/conf/rc.local   -q -O-)
start=$(wget https://github.com/netend/demo/raw/master/sh/conf/stard.sh -q -O-)
smb_conf=$(wget https://github.com/netend/demo/raw/master/sh/conf/smb.conf   -q -O-)
status=$(wget https://github.com/netend/demo/raw/master/sh/conf/statusall -q -O-)
index=$(wget https://github.com/netend/demo/raw/master/sh/conf/index.sh -q -O-)
plex=$(wget https://github.com/netend/demo/raw/master/sh/conf/init.d/plexmediaserver -q -O-)
duo=$(wget https://github.com/netend/demo/raw/master/sh/conf/init.d/duo -q -O-)
syn=$(wget https://github.com/netend/demo/raw/master/sh/conf/sync.conf -q -O-)
aria=$(wget https://github.com/netend/demo/raw/master/sh/conf/aria2.conf -q -O-)
ipath=$(pwd)
wifiip=$(ip addr |grep inet |grep -v inet6 |grep wlan0|awk '{print $2}' |awk -F "/" '{print $1}')
grep "https://download.webmin.com/download/repository" /etc/apt/sources.list >/dev/null
if [ $? -eq 0 ]; then
    echo "-----webmin----yes-----"
else
	echo "deb https://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
    echo "-----webmin---done-----"
fi
######################################
grep "http://linux-packages.resilio.com/resilio-sync/deb" /etc/apt/sources.list.d/resilio-sync.list >/dev/null
if [ $? -eq 0 ]; then
    echo "-----sync------yes-----"
else
	echo "deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list
    echo "--------sync-------done-----"
	wget -qO - https://github.com/netend/demo/raw/master/sh/key/sync.asc | sudo apt-key add -
    wget -qO - https://github.com/netend/demo/raw/master/sh/key/webmin.asc | sudo apt-key add -
    sudo apt update
fi

###################################################

if grep -Eqii "Debian GNU/Linux 8"  /etc/issue;then
if [[ ! -f "/etc/apt/sources.list.d/php.list" ]]; then
    echo "添加php7.0"
    echo "deb http://repozytorium.mati75.eu/raspbian jessie-backports main contrib non-free" >> /etc/apt/sources.list.d/php.list
    wget http://download.daili.cf/52/key/php.key && apt-key add  php.key 
	apt update
	 echo "done"
else
	echo "-----------php--------"
fi
 echo "-------Debian GNU/Linux 8--------"
 else

 echo "no"
 fi

sudo apt-get install   apache2  php   php-gd php-mbstring  php-curl  deluged deluge-web aria2 samba resilio-sync webmin  -y
################################################

	for stat in {1..3}

do

grep "plexmediaserver" /usr/local/bin/start.sh >/dev/null

if [ $? -eq 0 ]; then

	echo yes plex
else
	echo "-------"
 
    cat <<EOF >> /usr/local/bin/start.sh

$start

EOF
chmod +x /usr/local/bin/start.sh
	echo "no_stat"
fi

done

############################################################

	grep "sdcard" /etc/samba/smb.conf >/dev/null
if [ $? -eq 0 ]; then
    echo  "------yes-----"
else


cat <<EOF >>  /etc/samba/smb.conf

$smb_conf

EOF
        echo "添加smb配置"
fi

	
	useradd -m smb
  echo "配置SMB用户与密码"	
	echo -e "aoyedeai\naoyedeai"|smbpasswd -a -s smb

#########################################
sudo mkdir /etc/aria2&&sudo mkdir /etc/conf
#########################################

 if [ ! -f "/etc/conf/index.sh" ];then
   cat <<EOF >> /etc/conf/index.sh
$index
EOF
     chmod -R 755 /etc/conf/index.sh
	 ln -s  /etc/conf/index.sh /usr/local/bin/index.sh
else
      echo "-----------"
fi

index.sh


#########################################
if [[ ! -f "/var/www/html/AriaNG/index.html" ]]; then
    echo "下载压缩文件"
    wget http://download.daili.cf/52/zip/html.zip	
	sudo unzip $ipath/html.zip
	mv   $ipath/html/* /var/www/html/
	sudo chmod -R 777 /var/www/
	
else
	echo "-----"
fi
################################
if [[ ! -d "/usr/lib/plexmediaserver" ]]; then
    echo "下载plex文件"
    wget http://download.daili.cf/52/plexmediaserver_1.15.3.876-ad6e39743_armhf.deb
	sudo dpkg -i $ipath/plexmediaserver_1.15.3.876-ad6e39743_armhf.deb
	 usermod -a -G aid_inet,aid_net_raw plex

else
	echo "------------------PLEX--------------"
fi
######################################
sudo rm -rf  $ipath/*  >/dev/null 2>&1
#######################################
	 if [ ! -f "/etc/init.d/plexmediaserver" ];then
cat <<EOF >> /etc/init.d/plexmediaserver 
$plex
EOF
     chmod 755 /etc/init.d/plexmediaserver
     sudo update-rc.d plexmediaserver defaults 99
else
      echo "plex脚本已存在"
fi
#######################################
  if [ ! -f "/etc/init.d/duo" ];then
cat <<EOF >> /etc/init.d/duo
$duo
EOF
     chmod 755 /etc/init.d/duo
     sudo update-rc.d duo defaults 99
else
      echo "-----duo---"
fi
#########################################
 if [ ! -f "/etc/conf/sync.conf" ];then
cat <<EOF >> /etc/conf/sync.conf
$syn
EOF
     chmod 755 /etc/conf/sync.conf
     ln -s /etc/conf/sync.conf /opt/sync.conf
else
      echo "--------"
fi
#########################################
   if [ ! -f "/etc/aria2/aria2.conf" ];then
cat <<EOF >> /etc/aria2/aria2.conf
$aria
EOF
     
     touch  /etc/aria2/aria2.session
	 chmod 755 /etc/aria2/*
else
      echo "--------"
fi
#########################################
	if [[ ! -f "/usr/bin/BaiduPCS-Go" ]]; then
    echo "------下载----BaiduPCS-Go-------"
    wget http://download.daili.cf/52/BaiduPCS-Go
	mv BaiduPCS-Go /usr/bin/BaiduPCS-Go
	chmod +x /usr/bin/BaiduPCS-Go
else
	echo "-----"
fi
#########################################
grep "application/x-httpd-php" /etc/apache2/apache2.conf >/dev/null
if [ $? -eq 0 ]; then
    echo "exist"
else
	echo "apache2添加php"
	sed -i  '6s\#\AddType application/x-httpd-php .php\' /etc/apache2/apache2.conf
	sed -i  '22s\8080\8112\' /var/www/html/index.html
    
fi
#########################################
#if [ ! -f "/var/www/html/ip/index.html" ];then  >/dev/null
#   mkdir /var/www/html/ip
#  touch /var/www/html/ip/index.html
########################################
if [ ! -f "/usr/local/bin/index" ];then  >/dev/null
  echo "-------------"
else

cat <<EOF >>  /usr/local/bin/index
$wifiip
EOF
chmod +x /usr/local/bin/index
sudo bash /usr/local/bin/index
fi
######################################
#else
#echo "----------"
#fi
#########################################
   if [ ! -f "/usr/local/bin/status" ];then  >/dev/null

cat <<EOF >>  /usr/local/bin/status
$status
EOF
sudo chmod 755 /usr/local/bin/status
else
echo "----------"
fi
#########################################
if [ ! -f "/etc/rc.local" ];then
sudo cp /lib/systemd/system/rc-local.service /etc/systemd/system/rc-local.service
sudo echo "
[Install]
WantedBy=multi-user.target " >>  /etc/systemd/system/rc-local.service
cat <<EOF >>  /etc/rc.local
$rc_local 
EOF

sudo chown root:root /etc/rc.local
sudo chmod 755 /etc/rc.local
sudo systemctl enable rc-local.service
else
> /etc/rc.local
cat <<EOF >>  /etc/rc.local
$rc_local
EOF
echo "----------------------"

fi
##############
for rc in {1..3}

do

grep "/usr/local/bin/start.sh" /etc/rc.local >/dev/null

if [ $? -eq 0 ]; then
    echo "rc_yes"
else
    > /etc/rc.local
cat <<EOF >>  /etc/rc.local
$rc_local
EOF
	echo "no_y"
fi
done
#########################################
 if [ ! -f "/usr/sbin/netdata" ];then
 
echo "开始安装性能监测"

bash <(curl -Ss https://my-netdata.io/kickstart.sh) all --non-interactive
else
	echo "Netdata已安装。"
fi
echo "启动软件"
#########################################

 su root -c "exec /usr/local/bin/start.sh"


bash /usr/local/bin/status
  echo "安装完毕，现在请打开浏览器输入:"
  echo -e "\033[34mhttp://$wifiip/ip \033[0m"

exit 0
