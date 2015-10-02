FROM wordpress:fpm

RUN apt-get update && apt-get -y install curl unzip

# Install phpredis extension
RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/2.2.7.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mv phpredis-2.2.7 /usr/src/php/ext/redis \
    && docker-php-ext-install redis

# Add scripts
COPY set-config.php /set-config.php
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
