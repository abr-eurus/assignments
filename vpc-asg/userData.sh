#!/bin/bash
apt update -y
apt install apache2 php php-mysql -y
chmod -R 755 /var/www/html
cd /var/www/html
rm -rf *
wget "${OBJ_URL}"
tar -xzf "${FILE}"
sed -i "s%HOST_IP%""${HOST}%" includes/config.php