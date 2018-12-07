
###  docker image for php contain nginx  and supervisor

common php program can use this image:  

yinfu/php-nginx:latest

```

docker run -d -p 80:80  -v /www:/var/www/html yinfu/php-nginx:latest

```
            


if you use thinkphp5 program ,you can use this image :  
yinfu/php-nginx:thinkphp5

```
docker run -d -p 80:80  -v /www:/var/www/html yinfu/php-nginx:thinkphp5
```


if you want to diy php-fpm options  ,you can use ENV  to set some options 


```


docker run -d -p 80:80  -v /www:/var/www/html -e PM=dynamic -e MAX_CHILDREN=30 -e START_SERVERS=15 -e MIN_SPARE_SERVERS=11 -e MAX_SPARE_SERVERS=30 -e MAX_REQUESTS=1024 yinfu/php-nginx:thinkphp5

```