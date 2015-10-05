#!/bin/bash

echo "Installing MySQL"
apt-get update; apt-get install -y mysql-client

echo "Download sample-data file. This could take a while..."
cd /tmp
curl -SO https://www.magentocommerce.com/downloads/assets/1.9.1.0/magento-sample-data-1.9.1.0.tar.gz
tar xvf magento-sample-data-1.9.1.0.tar.gz

echo "Copying over assets"
cp -R magento-sample-data-1.9.1.0/media/* /var/www/html/media/
cp -R magento-sample-data-1.9.1.0/skin/* /var/www/html/skin/
chown -R www-data:www-data /var/www/html/media

echo "Importing mysqldump"
mysql -h $MYSQL_HOST \
  -u $MYSQL_USER \
  -p$MYSQL_PASSWORD \
  $MYSQL_DATABASE < magento-sample-data-1.9.1.0/magento_sample_data_for_1.9.1.0.sql
