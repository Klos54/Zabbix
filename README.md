# Zabbix

This script allows a user to install a zabbix server on a linux machine and add monitored devices.

The first option allows to install Zabbix Server including Nginx, MariaDB & PHP 7.4 FPM.  You will be asked to create a password for the Zabbix user in order to assign SQL rights, this will be saved in the configuration file "/etc/zabbix/zabbix_server.conf".

The second option is to install Zabbix Agent to monitor the necessary computers. The script will then ask you for the IP address of the previously created Zabbix server, the IP address is saved in the Zabbix Agent configuration file "/etc/zabbix/zabbix_agentd.conf".
