FROM php:8.1.4-apache

RUN apt update && apt install -y libzip-dev zlib1g-dev libpng-dev libmagickwand-dev cron supervisor \
&& rm -rf /var/lib/apt/lists/*

RUN pecl install redis imagick xdebug

RUN docker-php-ext-install gd bcmath zip mysqli pdo_mysql gettext calendar exif

RUN docker-php-ext-enable redis imagick

RUN cp /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/ \
&& mv /var/www/html /var/www/public \
&& sed -i 's/\/var\/www\/html/\/var\/www\/public/' /etc/apache2/sites-available/default-ssl.conf \
&& sed -i 's/\/var\/www\/html/\/var\/www\/public/' /etc/apache2/sites-available/000-default.conf

RUN mkdir /etc/supervisord \
&& mkdir /etc/supervisord/conf.d \
&& mkdir /var/log/supervisord

RUN echo "* * * * * php /var/www/artisan schedule:run >> /dev/null 2>&1" | crontab

COPY supervisord.conf /etc/supervisord/

COPY laravel-worker.conf /etc/supervisord/conf.d/

COPY apached.conf /etc/supervisord/conf.d/

COPY crond.conf /etc/supervisord/conf.d/

WORKDIR /var/www

CMD ["/usr/local/bin/supervisord","-c","/etc/supervisord/supervisord.conf"]
