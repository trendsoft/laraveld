FROM php:8.3.30-apache

RUN apt update && apt install -y libzip-dev zlib1g-dev libpng-dev libmagickwand-dev cron supervisor curl git \
&& rm -rf /var/lib/apt/lists/*

RUN pecl install redis imagick xdebug

RUN docker-php-ext-install gd bcmath zip mysqli pdo_mysql gettext calendar exif pcntl && pecl install sqlsrv pdo_sqlsrv

RUN docker-php-ext-enable redis imagick pcntl sqlsrv pdo_sqlsrv

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

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

CMD ["/usr/bin/supervisord","-c","/etc/supervisord/supervisord.conf"]
