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
<cache>\n
    <backend>Cm_Cache_Backend_Redis</backend>\n
    <backend_options>\n
        <server>redis</server>\n
        <port>6379</port>\n
        <persistent></persistent>\n
        <database>0</database>\n
        <password></password>\n
        <force_standalone>0</force_standalone>\n
        <connect_retries>1</connect_retries>\n
        <read_timeout>10</read_timeout>\n
        <automatic_cleaning_factor>0</automatic_cleaning_factor>\n
        <compress_data>1</compress_data>\n
        <compress_tags>1</compress_tags>\n
        <compress_threshold>20480</compress_threshold>\n
        <compression_lib>gzip</compression_lib>\n
        <use_lua>0</use_lua>\n
    </backend_options>\n
</cache>\n
<session_save><![CDATA[db]]></session_save>\n
<redis_session>\n
    <host>redis</host>\n
    <port>6379</port>\n
    <password></password>\n
    <timeout>2.5</timeout>\n
    <persistent></persistent>\n
    <db>0</db>\n
    <compression_threshold>2048</compression_threshold>\n
    <compression_lib>gzip</compression_lib>\n
    <log_level>1</log_level>\n
    <max_concurrency>6</max_concurrency>\n
    <break_after_frontend>5</break_after_frontend>\n
    <break_after_adminhtml>30</break_after_adminhtml>\n
    <first_lifetime>600</first_lifetime>\n
    <bot_first_lifetime>60</bot_first_lifetime>\n
    <bot_lifetime>7200</bot_lifetime>\n
    <disable_locking>0</disable_locking>\n
    <min_lifetime>60</min_lifetime>\n
    <max_lifetime>2592000</max_lifetime>\n
</redis_session>
"

file="/var/www/html/app/etc/local.xml"

touch $file
chmod 644 $file
chown www-data:www-data $file

content="$(echo $data | sed 's/\//\\\//g')"
sed -i -e "/<\/global>/ s/.*/${content}\n&/" $file
