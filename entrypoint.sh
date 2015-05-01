#!/bin/bash
set -e

if [ -z "$DB_NAME" ]; then
    echo >&2 'Error: Did you forget to add -e DB_NAME=... ?'
    exit 1
fi

if [ -z "$DB_PASSWORD" ]; then
    echo >&2 'Error: Did you forget to add -e DB_PASSWORD=... ?'
    exit 1
fi

if [ -z "$DB_HOST" ]; then
    echo >&2 'Error: Did you forget to add -e DB_HOST=... ?'
    exit 1
fi

if [ -z "$DB_USER" ]; then
    echo >&2 'Error: Did you forget to add -e DB_USER=... ?'
    exit 1
fi

echo 'Setting up database configuration'
sed -e "s/^define('DB_NAME', 'database_name_here')/define('DB_NAME', '$DB_NAME')/" \
    -e s"/^define('DB_PASSWORD', 'password_here');/define('DB_PASSWORD', '$DB_PASSWORD');/" \
    -e s"/^define('DB_USER', 'username_here');/define('DB_USER', '$DB_USER');/" \
    -e s"/^define('DB_HOST', 'localhost');/define('DB_HOST', '$DB_HOST');/" \
    < /wordpress/wp-config-sample.php > /var/www/html/wp-config.php

echo 'Starting server'
exec /usr/bin/supervisord
