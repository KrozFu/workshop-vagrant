#!/bin/bash
set -e

sed "s|define( 'DB_NAME', 'database_name_here' );|define( 'DB_NAME', 'wordpress' );|g" /var/www/wordpress/wp-config-sample.php > wp-config-temp.php

sed "s|define( 'DB_USER', 'username_here' );|define( 'DB_USER', 'wordpressuser' );|g" wp-config-temp.php > wp-config-temp1.php

sed "s|define( 'DB_PASSWORD', 'password_here' );|define( 'DB_PASSWORD', 'wordpresspass' );|g" wp-config-temp1.php > wp-config.php

sudo mv wp-config.php /var/www/wordpress/
sudo chown -R www-data: /var/www/wordpress
sudo mv wordpress /etc/nginx/sites-available/

echo -e "\n\ny\nwordpress\nwordpress\ny\ny\ny\ny" | sudo mysql_secure_installation

sudo mysql -u root -pwordpress -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci"
sudo mysql -u root -pwordpress -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'wordpresspass'"
sudo mysql -u root -pwordpress -e "FLUSH PRIVILEGES"

sudo unlink /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/default
sudo service nginx restart
echo "|     Wordpress Web Server Ready!    |"
echo "º-----------------------------------º"
echo "| Click here > http://localhost:8081 |"
echo "º-----------------------------------º"