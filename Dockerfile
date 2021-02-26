FROM debian:buster

MAINTAINER Gaetan Fournier <gaefourn@student.42.fr>

WORKDIR /tmp/

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Install wget && php packages #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y wget && \
apt-get install -y php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip php-mysql

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Install nginx && setup SSL #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

RUN apt-get install -y php-fpm && \
apt-get install -y nginx-full && \
apt-get install -y openssl && \
rm -f /ect/nginx/site-available/default && \
rm -f /etc/nginx/sites-enabled/default && \
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=FR/ST=France/L=Paris/O=42/CN=127.0.0.1" -keyout /etc/ssl/private/nginx_server.key -out /etc/ssl/certs/nginx_server.crt && \
openssl dhparam -out /etc/nginx/dhparam.pem 1000

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Install MySQL Wordpress & phpMyAdmin#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

RUN apt-get install -y mariadb-server
RUN wget -c https://wordpress.org/latest.tar.gz && \
tar -zxf latest.tar.gz && \
mv wordpress /var/www/html/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz && \
tar xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz && \ 
mv phpMyAdmin-4.9.0.1-all-languages/ /var/www/html/phpMyAdmin;

#~~~~~~~~~~~~#
# Config all #
#~~~~~~~~~~~~#

COPY srcs/nginx.conf /etc/nginx/sites-enabled/
COPY srcs/wp-config.php /var/www/html/wordpress/
RUN rm -rf /var/www/html/index.php
COPY srcs/index.html /var/www/html/index.html

#~~~~~~~~~~~~~~#
# Start script #
#~~~~~~~~~~~~~~#

COPY srcs/start.sh /tmp/
ENTRYPOINT ["/bin/sh", "/tmp/start.sh"]

#~~~~~~~~~~~~~~~~~#
# Listen to ports #
#~~~~~~~~~~~~~~~~~#

EXPOSE 80 443
