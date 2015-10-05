FROM php:5.6-apache

RUN apt-get update && apt-get install -y git

RUN requirements="libpng12-dev libmcrypt-dev libmcrypt4 libcurl3-dev libfreetype6 libjpeg62-turbo libpng12-dev libfreetype6-dev libjpeg62-turbo-dev" \
    && apt-get update && apt-get install -y $requirements && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mbstring \
    && requirementsToRemove="libpng12-dev libmcrypt-dev libcurl3-dev libpng12-dev libfreetype6-dev libjpeg62-turbo-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove

RUN cd /tmp \
  && curl -O https://www.magentocommerce.com/downloads/assets/1.9.1.0/magento-1.9.1.0.tar.gz \
  && tar xvf magento-1.9.1.0.tar.gz \
  && mv magento/* magento/.htaccess /var/www/html

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/2.2.7.tar.gz \
  && tar xfz /tmp/redis.tar.gz \
  && rm -r /tmp/redis.tar.gz \
  && mv phpredis-2.2.7 /usr/src/php/ext/redis \
  && docker-php-ext-install redis

WORKDIR /var/www/html

RUN curl -Ss https://raw.githubusercontent.com/colinmollenhour/modman/master/modman-installer | bash \
  && ~/bin/modman init \
  && ~/bin/modman clone https://github.com/colinmollenhour/Cm_Cache_Backend_Redis \
  && ~/bin/modman clone https://github.com/colinmollenhour/Cm_RedisSession

COPY ./setup-config.bash /opt/
COPY ./install-data.bash /opt/

RUN chown -R www-data:www-data .
RUN usermod -u 1000 www-data
RUN a2enmod rewrite
