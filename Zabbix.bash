#!/bin/bash

if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit
fi

clear
read -p "	Choose a number
	1 - Install Zabbix Server v6, Mariadb, Nginx with php-fpm v7.4
	2 - Deploy Zabbix Agent to connect to Zabbix Server
" choise

case $choise in
	1)
	cd /tmp
	wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-1+debian11_all.deb
	dpkg -i zabbix-release_6.0-1+debian11_all.deb
	apt update
	apt upgrade -y
	apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent mariadb-server
	sed -i {'s/listen 80 default_server;/# listen 80 default_server;/;s/listen \[::\]:80 default_server;/# listen [::]:80 default_server;/'} /etc/nginx/sites-enabled/default
	read -p "Password for mysql zabbix user:
" password
	echo "create database zabbix character set utf8mb4 collate utf8mb4_bin;" | mysql
	echo "create user zabbix@localhost identified by '$password';" | mysql
	echo "grant all privileges on zabbix.* to zabbix@localhost;" | mysql
	echo "Enter again your password recently created"
	zcat /usr/share/doc/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -p zabbix
	sed -i {'s/# DBPassword=/DBPassword\=$password/'} /etc/zabbix/zabbix_server.conf
	systemctl restart zabbix-server zabbix-agent nginx php7.4-fpm
	systemctl enable zabbix-server zabbix-agent nginx php7.4-fpm
	echo "en_US.UTF-8" | tee -a /etc/locale.gen; locale-gen
	reboot
	;;
	
	2)
	cd /tmp
	wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-1+debian11_all.deb
	dpkg -i zabbix-release_6.0-1+debian11_all.deb
	apt update
	apt upgrade -y
	apt install zabbix-agent -y
	read -p "Quelle est l'adresse du serveur Zabbix ?
What's Zabbix server addresse ?
" host
	sed -i "s/Server=127.0.0.1/Server\=$host/" /etc/zabbix/zabbix_agentd.conf
	systemctl restart zabbix-agent.service
	;;
esac