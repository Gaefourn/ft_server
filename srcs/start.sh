#!/bin/sh

service php7.3-fpm start
service mysql start
service nginx start
mysql -e "
create database wordpress;
create user wordpress@localhost identified by 'password';
grant all privileges on wordpress.* to wordpress@localhost;
flush privileges;"
/bin/sh
