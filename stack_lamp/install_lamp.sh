#!/bin/bash

sudo yum -y update
sudo yum -y install epel-release

#-------------------------------------------------#

echo 'Do you want to install Apache Worker? (Y/N)'
read var_http

if [ "$var_http" == "Y" ]
then
  sudo yum -y install httpd
  sudo bash -c 'cat 00-mpm.conf > /etc/httpd/conf.modules.d/00-mpm.conf'
  sudo service httpd start
  sudo chkconfig httpd on

  httpd -V | grep MPM
  echo ''
  echo 'Installation complete Apache Worker!'
  echo '============================================='
  echo ''
  sleep 2
fi

echo 'Do you want to install PHP 5.6 FPM? (Y/N)'
read var_php

if [ "$var_php" == "Y" ]
then
  sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
  sudo yum -y update

  sudo yum -y install php56w php56w-fpm php56w-opcache php56w-cli php56w-common php56w-gd php56w-imap php56w-mysqlnd php56w-soap php56w-xml php56w-mbstring php56w-mcrypt
  sudo bash -c 'cat php.conf >> /etc/httpd/conf.d/php.conf'
  sudo service php-fpm start
  sudo chkconfig php-fpm on
  sudo service httpd restart
  sudo bash -c 'echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php'

  echo ''
  echo 'Installation complete PHP-FPM!'
  echo '============================================='
  echo ''
  sleep 2
fi

#-------------------------------------------------#

echo 'Do you want to install MariaDB? (Y/N)'
read var_db

if [ "$var_db" == "Y" ]
then
  sudo yum -y install mariadb mariadb-server
  sudo service mariadb start
  sudo chkconfig mariadb on
  sudo mysql_secure_installation

  echo ''
  echo 'Installation complete MARIADB!'
  echo '============================================='
  echo ''
  sleep 2
fi

#-------------------------------------------------#

echo 'Do you want to install PHPMyAdmin? (Y/N)'
read var_phpdb

if [ "$var_phpdb" == "Y" ]
then
  sudo yum -y install phpmyadmin
  sudo cp phpMyAdmin.conf /etc/httpd/conf.d/phpMyAdmin.conf

  echo 'Enter path to PHPMyAdmin (eg: phpmyadmin)'
  read url

  sudo bash -c "sed -i -e 's/{url}/$url/g' /etc/httpd/conf.d/phpMyAdmin.conf"
  sudo service httpd restart

  echo ''
  echo 'Installation complete PHPMyAdmin!'
  echo '============================================='
  echo ''
  sleep 2
fi

echo 'Process completed!'