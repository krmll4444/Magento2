FROM ubuntu:16.04

RUN  apt-get update --fix-missing \
  && apt-get install -y language-pack-en-base \
  && apt-get install -y --allow-unauthenticated software-properties-common \
  && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php \
  && apt-get update \
  && apt-get upgrade -y --allow-unauthenticated \
  && apt-get install -y --allow-unauthenticated \
    git \
    msmtp \
    curl \
    cron \
    nano \
    zip \
    unzip \
    php7.1 \
    php7.1-cgi \
    php7.1-fpm \
    php7.1-xml \
    php7.1-gd \
    php7.1-soap \
    php7.1-intl \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-mysql \
    php7.1-zip \
    php7.1-json \
    php7.1-opcache \
    php7.1-curl \
    php7.1-bcmath \
    php-xdebug \
    graphicsmagick \
   && apt-get clean

RUN apt update && \
    apt install -y mysql-client

# Configure php-fpm
RUN mkdir /run/php
RUN echo "TLS_REQCERT never" > /etc/ldap/ldap.conf
RUN usermod -u 1000 www-data

COPY ./pool.conf /etc/php/7.1/fpm/pool.d/zzz.conf
COPY ./xdebug.ini /etc/php/7.1/mods-available/xdebug.ini
COPY ./php.ini /etc/php/7.1/fpm/conf.d/30-user.ini

COPY ./mailhog.ini /etc/php/7.1/fpm/conf.d/31-mailhog.ini
COPY ./mailhog.ini /etc/php/7.1/cli/conf.d/31-mailhog.ini

# Setup composer
RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

# Cronjob setup
COPY ./cron /etc/cron.d/cron
RUN chmod 0644 /etc/cron.d/cron

# Start script
COPY ./start.sh /usr/local/bin/start
RUN chmod +x /usr/local/bin/start

CMD ["/usr/local/bin/start"]
