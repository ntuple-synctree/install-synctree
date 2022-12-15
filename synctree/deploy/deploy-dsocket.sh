#!/bin/bash

### logrotate
cat /root/deploy/logrotate-synctree.conf > /etc/logrotate.d/synctree-nginx-logs &&

### add crontab
(crontab -l 2>/dev/null; echo "59 23 * * * /usr/sbin/logrotate -f /etc/logrotate.d/synctree-nginx-logs > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "59 23 * * * find /home/ubuntu/apps/synctree-*/logs -mtime +3 -delete > /dev/null 2>&1") | crontab -

### nginx conf
cat /root/deploy/nginx.conf > /etc/nginx/nginx.conf &&

### synctree config
cat /root/deploy/dsocket-application.properties > /home/ubuntu/.synctree/dsocket-application.properties &&
cd /home/ubuntu/apps/synctree-dsocket/ && ./start.sh &&

### add hosts
if [ -f "/root/deploy/hosts" ]; then
    cat /root/deploy/hosts >> /etc/hosts
fi &&

/usr/sbin/service cron start && 
nginx -g 'daemon off;'
