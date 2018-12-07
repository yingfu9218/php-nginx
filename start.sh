#!/bin/bash

#php-fpm 参数调优

if [ -z "$PM" ]; then
  PM="dynamic"
fi
awk -v LINE="pm = $PM" '{ sub(/^pm = dynamic*/, LINE); print; }' /usr/local/etc/php-fpm.d/www.conf > /usr/local/etc/php-fpm.d/www.conf.tmp && mv /usr/local/etc/php-fpm.d/www.conf.tmp /usr/local/etc/php-fpm.d/www.conf

if [ -z "$MAX_CHILDREN" ]; then
  MAX_CHILDREN=30
fi
awk -v LINE="pm.max_children=$MAX_CHILDREN" '{ sub(/^pm.max_children = 5*/, LINE); print; }' /usr/local/etc/php-fpm.d/www.conf > /usr/local/etc/php-fpm.d/www.conf.tmp && mv /usr/local/etc/php-fpm.d/www.conf.tmp /usr/local/etc/php-fpm.d/www.conf

if [ -z "$START_SERVERS" ]; then
  START_SERVERS=15
fi
awk -v LINE="pm.start_servers=$START_SERVERS" '{ sub(/^pm.start_servers = 2*/, LINE); print; }' /usr/local/etc/php-fpm.d/www.conf > /usr/local/etc/php-fpm.d/www.conf.tmp && mv /usr/local/etc/php-fpm.d/www.conf.tmp /usr/local/etc/php-fpm.d/www.conf

if [ -z "$MIN_SPARE_SERVERS" ]; then
  MIN_SPARE_SERVERS=11
fi
awk -v LINE="pm.min_spare_servers=$MIN_SPARE_SERVERS" '{ sub(/^pm.min_spare_servers = 1*/, LINE); print; }' /usr/local/etc/php-fpm.d/www.conf > /usr/local/etc/php-fpm.d/www.conf.tmp && mv /usr/local/etc/php-fpm.d/www.conf.tmp /usr/local/etc/php-fpm.d/www.conf

if [ -z "$MAX_SPARE_SERVERS" ]; then
  MAX_SPARE_SERVERS=30
fi
awk -v LINE="pm.max_spare_servers=$MAX_SPARE_SERVERS" '{ sub(/^pm.max_spare_servers = 3*/, LINE); print; }' /usr/local/etc/php-fpm.d/www.conf > /usr/local/etc/php-fpm.d/www.conf.tmp && mv /usr/local/etc/php-fpm.d/www.conf.tmp /usr/local/etc/php-fpm.d/www.conf

if [ -z "$MAX_REQUESTS" ]; then
  MAX_REQUESTS=1024
fi
awk -v LINE="pm.max_requests=$MAX_REQUESTS" '{ sub(/^;pm.max_requests = 500*/, LINE); print; }' /usr/local/etc/php-fpm.d/www.conf > /usr/local/etc/php-fpm.d/www.conf.tmp && mv /usr/local/etc/php-fpm.d/www.conf.tmp /usr/local/etc/php-fpm.d/www.conf


#/etc/init.d/cron start
/etc/init.d/supervisor start
/usr/local/nginx/sbin/nginx 
php-fpm 