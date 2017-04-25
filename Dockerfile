#Dir for extensions config /usr/local/etc/php/conf.d/
FROM php:5.6-fpm

MAINTAINER Lyberteam <lyberteamltd@gmail.com>
LABEL Vendor="Lyberteam"
LABEL Description="PHP-FPM v5.6-fpm"
LABEL Version="1.0.1"
LABEL Source="http://bpteam.net/blog/2015/11/08/%D1%80%D0%B0%D0%B7%D0%B2%D0%B5%D1%80%D1%82%D1%8B%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D1%81%D1%80%D0%B5%D0%B4%D1%8B-%D1%80%D0%B0%D0%B7%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%BA%D0%B8-%D1%81-%D0%BF%D0%BE/"

RUN apt-get update
RUN apt-get install -y php5-dev php-pear php5-common

# curl уже входит в образ 5.6-fpm но на всякие пожарные попробуем установить
RUN apt-get install -y curl libcurl4-openssl-dev
RUN docker-php-ext-install curl
RUN docker-php-ext-enable curl

# Устанавливаем все расширения
RUN docker-php-ext-install json
RUN docker-php-ext-enable json

RUN apt-get install -y libpng-dev
RUN apt-get install -y libjpeg-dev
RUN docker-php-ext-install gd
RUN docker-php-ext-enable gd

RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install xml
RUN docker-php-ext-enable xml

RUN docker-php-ext-install opcache
RUN docker-php-ext-enable opcache

RUN docker-php-ext-install session
RUN docker-php-ext-enable session

RUN docker-php-ext-install mbstring
RUN docker-php-ext-enable mbstring

RUN docker-php-ext-install mysqli
RUN docker-php-ext-enable mysqli

RUN docker-php-ext-install pdo
RUN docker-php-ext-enable pdo

RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-enable pdo_mysql

RUN apt-get install -y libpq-dev
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-enable pdo_pgsql

RUN apt-get install -y php5-memcached

RUN pecl install redis
RUN docker-php-ext-enable redis

RUN docker-php-ext-install pcntl
RUN docker-php-ext-enable pcntl

# Настройка xDebug (КЭП)
RUN pecl install xdebug-2.3.2
RUN docker-php-ext-enable xdebug
RUN touch /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.remote_autostart=true >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.remote_mode=req >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.remote_handler=dbgp >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.remote_connect_back=1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.remote_port=9000 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo xdebug.remote_host=127.0.0.1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.idekey=PHPSTORM >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.remote_enable=1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.profiler_append=0 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.profiler_enable=0 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.profiler_enable_trigger=1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.profiler_output_dir=/var/debug >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.profiler_output_name=cachegrind.out.%s.%u >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.var_display_max_data=-1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.var_display_max_children=-1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.var_display_max_depth=-1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN apt-get install -y geoip-bin geoip-database libgeoip-dev
RUN apt-get install -y php5-geoip

# Install composer globally
RUN echo "Install composer globally"
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

RUN apt-get install -y wget mc vim
RUN wget https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit

WORKDIR /var/www/lyberteam

CMD ["php-fpm"]