FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive 

RUN  apt-get update --fix-missing \
  && apt-get upgrade -y \
  && apt-get install -y --allow-unauthenticated \
    git \
    msmtp \
    curl \
    cron \
    nano \
    zip \
    unzip \
    php-cli \
    php-fpm \
    php-xml \
    php-gd \
    php-soap \
    php-intl \
    php-mbstring \
    php-mysql \
    php-zip \
    php-json \
    php-opcache \
    php-curl \
    php-bcmath \
    php-xdebug \
    php-soap \
    graphicsmagick \
   && apt-get clean
   
RUN apt update && \
    apt install -y mysql-client   

# Configure php-fpm
RUN mkdir /run/php
RUN echo "TLS_REQCERT never" > /etc/ldap/ldap.conf
RUN usermod -u 1000 www-data

COPY ./pool.conf /etc/php/7.2/fpm/pool.d/zzz.conf
COPY ./xdebug.ini /etc/php/7.2/mods-available/xdebug.ini

COPY ./php.ini /etc/php/7.2/fpm/conf.d/30-user.ini
COPY ./php-cli.ini /etc/php/7.2/cli/conf.d/30-user.ini

COPY ./mailhog.ini /etc/php/7.2/fpm/conf.d/31-mailhog.ini
COPY ./mailhog.ini /etc/php/7.2/cli/conf.d/31-mailhog.ini

# Setup composer
RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

# Cronjob setup
COPY ./cron /etc/cron.d/cron
RUN chmod 0644 /etc/cron.d/cron

# Start script
COPY ./start.sh /usr/local/bin/start
RUN chmod +x /usr/local/bin/start

WORKDIR /var/www/

RUN phpdismod xdebug && service php7.2-fpm reload

CMD ["/usr/local/bin/start"]
