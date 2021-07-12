#!/bin/bash
apt update -y
apt install mysql-server -y
mysql -e "CREATE DATABASE elms;"
mysql -e "CREATE USER ammar@'%' IDENTIFIED BY 'ammar';"
mysql -e "GRANT ALL PRIVILEGES ON elms.* TO ammar@'%';"
mysql -e "FLUSH PRIVILEGES;"
sed -i 's%127.0.0.1%0.0.0.0%' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql.service