FROM php:7.2.30-apache

RUN apt-get update && apt-get install -y zip libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng-dev \
&& docker-php-ext-install -j$(nproc) iconv mcrypt bcmath && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql zip \
&& cp /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/ \
&& mv /var/www/html /var/www/public \
&& sed -i 's/\/var\/www\/html/\/var\/www\/public/' /etc/apache2/sites-available/default-ssl.conf \
&& sed -i 's/\/var\/www\/html/\/var\/www\/public/' /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www