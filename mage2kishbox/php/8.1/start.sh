#!/usr/bin/env bash

_term() {
  echo "Caught SIGTERM signal!"
  kill -TERM "$child"
  exit 0
}

trap _term SIGTERM

# Start Cron
if [[ -d /var/log/cron ]]; then
    chmod -R 777 /var/log/cron;
fi
service cron start

# Start PHP
if [[ -d /var/log/php ]]; then
    chmod -R 777 /var/log/php;
fi
mkdir -p /run/php/;
php-fpm8.1 -F -R &

child=$!
wait "$child"
