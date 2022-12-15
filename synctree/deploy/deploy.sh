#!/bin/bash

### logrotate
cat /root/deploy/logrotate-synctree.conf > /etc/logrotate.d/synctree-nginx-logs &&

### add crontab
(crontab -l 2>/dev/null; echo "59 23 * * * /usr/sbin/logrotate -f /etc/logrotate.d/synctree-nginx-logs > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "59 23 * * * find /home/ubuntu/apps/synctree-*/logs -mtime +3 -delete > /dev/null 2>&1") | crontab -

### nginx conf
cat /root/deploy/nginx.conf > /etc/nginx/nginx.conf &&

### php-fpm php.ini
cat /root/deploy/php.ini > /etc/php/7.3/fpm/php.ini &&

### synctree config
cat /root/deploy/config.ini > /home/ubuntu/apps/secure/config.ini &&
cat /root/deploy/private_key.pem > /home/ubuntu/apps/secure/rsa/private_key.pem &&
cat /root/deploy/credentials > /home/ubuntu/.synctree/credentials &&
cat /root/deploy/providerConfig.json > /home/ubuntu/.synctree/providerConfig.json &&
cat /root/deploy/license.txt > /home/ubuntu/.synctree/license.txt &&
cat /root/deploy/aws.txt > /home/ubuntu/.synctree/aws.txt &&


### add hosts
if [ -f "/root/deploy/hosts" ]; then
    cat /root/deploy/hosts >> /etc/hosts
fi &&


### register-usage
#curl http://localhost/system/mms/registerUsage?region=$REGION&version=$VERSION
#cd /home/ubuntu/apps/synctree-studio/public/mms/ && ./mms.sh 'us-east-1' 'latest'

/usr/sbin/service cron start && 
/usr/sbin/service php7.3-fpm start && 
nginx -g 'daemon off;'
