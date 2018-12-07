FROM php:7.0-fpm
RUN apt-get update \
	# 相关依赖必须手动安装
	&& apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
    # 安装扩展
    && docker-php-ext-install -j$(nproc) iconv mcrypt mbstring mysqli pdo pdo_mysql shmop iconv bcmath zip opcache \
    # 如果安装的扩展需要自定义配置时
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN pecl install redis-4.0.1 \
    && docker-php-ext-enable redis 
RUN pecl install mongodb \
    && docker-php-ext-enable mongodb 

RUN apt-get install -y libpcre3-dev libssl-dev

ENV NGINX_VERSION 1.15.5

RUN apt-get install -y wget &&wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz  && tar -zxvf nginx-${NGINX_VERSION}.tar.gz && rm -f nginx-${NGINX_VERSION}.tar.gz

RUN  cd nginx-${NGINX_VERSION} && ./configure  --prefix=/usr/local/nginx  --sbin-path=/usr/local/nginx/sbin/nginx --conf-path=/usr/local/nginx/conf/nginx.conf --error-log-path=/var/log/nginx/error.log  --http-log-path=/var/log/nginx/access.log  --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock  --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module --http-client-body-temp-path=/var/tmp/nginx/client/ --http-proxy-temp-path=/var/tmp/nginx/proxy/ --http-fastcgi-temp-path=/var/tmp/nginx/fcgi/ --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi --http-scgi-temp-path=/var/tmp/nginx/scgi  && make && make install
RUN cd ../ && rm -rf nginx-${NGINX_VERSION}

RUN /usr/sbin/useradd nginx && mkdir -p /var/log/nginx && mkdir -p /var/tmp/nginx

RUN apt-get install -y cron vim
RUN apt-get install -y supervisor


ADD ./conf/nginx.conf /usr/local/nginx/conf/nginx.conf  

ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
EXPOSE 80

### 根据环变量修改 /usr/local/etc/php-fpm.d/www.conf配置文件
#pm = dynamic
ENV PM="dynamic"
#pm.max_children
ENV MAX_CHILDREN="30"
#pm.start_servers
ENV START_SERVERS="15"
#pm.min_spare_servers
ENV MIN_SPARE_SERVERS="11"
#pm.max_spare_servers
ENV MAX_SPARE_SERVERS="30"
#pm.max_requests
ENV MAX_REQUESTS="1024"
CMD [ "/usr/local/bin/start.sh" ] 
