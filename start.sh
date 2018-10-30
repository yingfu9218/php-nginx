#!/bin/bash
/etc/init.d/cron start
/etc/init.d/supervisor start
/usr/local/nginx/sbin/nginx 
php-fpm 