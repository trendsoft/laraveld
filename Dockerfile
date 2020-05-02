FROM php:7.3.17-apache

RUN apt-get update && apt-get install -y zip libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng-dev \
&& pecl install mcrypt-1.0.1 \
&& docker-php-ext-enable mcrypt \
&& docker-php-ext-install -j$(nproc) iconv bcmath && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql zip \
&& cp /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/ \
&& mv /var/www/html /var/www/public \
&& sed -i 's/\/var\/www\/html/\/var\/www\/public/' /etc/apache2/sites-available/default-ssl.conf \
&& sed -i 's/\/var\/www\/html/\/var\/www\/public/' /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www