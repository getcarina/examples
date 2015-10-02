#!/bin/bash

php -f /var/www/html/install.php -- \
  --license_agreement_accepted "yes" \
  --locale $MAGENTO_LOCALE \
  --timezone $MAGENTO_TIMEZONE \
  --default_currency $MAGENTO_DEFAULT_CURRENCY \
  --db_host $MYSQL_HOST \
  --db_name $MYSQL_DATABASE \
  --db_user $MYSQL_USER \
  --db_pass $MYSQL_PASSWORD \
  --url $MAGENTO_URL \
  --skip_url_validation "yes" \
  --use_rewrites "no" \
  --use_secure "no" \
  --secure_base_url "" \
  --use_secure_admin "no" \
  --admin_firstname $MAGENTO_ADMIN_FIRSTNAME \
  --admin_lastname $MAGENTO_ADMIN_LASTNAME \
  --admin_email $MAGENTO_ADMIN_EMAIL \
  --admin_username $MAGENTO_ADMIN_USERNAME \
  --admin_password $MAGENTO_ADMIN_PASSWORD

data="
<cache>
    <backend>Cm_Cache_Backend_Redis</backend>
    <backend_options>
        <server>redis</server>
        <port>6379</port>
        <persistent></persistent>
        <database>0</database>
        <password></password>
        <force_standalone>0</force_standalone>
        <connect_retries>1</connect_retries>
        <read_timeout>10</read_timeout>
        <automatic_cleaning_factor>0</automatic_cleaning_factor>
        <compress_data>1</compress_data>
        <compress_tags>1</compress_tags>
        <compress_threshold>20480</compress_threshold>
        <compression_lib>gzip</compression_lib>
        <use_lua>0</use_lua>
    </backend_options>
</cache>
<session_save><![CDATA[db]]></session_save>
<redis_session>
  <host>redis</host>
  <port>6379</port>
  <password></password>
  <timeout>2.5</timeout>
  <persistent></persistent>
  <db>0</db>
  <compression_threshold>2048</compression_threshold>
  <compression_lib>gzip</compression_lib>
  <log_level>1</log_level>
  <max_concurrency>6</max_concurrency>
  <break_after_frontend>5</break_after_frontend>
  <break_after_adminhtml>30</break_after_adminhtml>
  <first_lifetime>600</first_lifetime>
  <bot_first_lifetime>60</bot_first_lifetime>
  <bot_lifetime>7200</bot_lifetime>
  <disable_locking>0</disable_locking>
  <min_lifetime>60</min_lifetime>
  <max_lifetime>2592000</max_lifetime>
</redis_session>
</global>
"

touch /var/www/html/app/etc/local.xml
chmod 644 /var/www/html/app/etc/local.xml
chown www-data:www-data /var/www/html/app/etc/local.xml

sed -i -e "s@<\/global>@${data}@" /var/www/html/app/etc/local.xml
