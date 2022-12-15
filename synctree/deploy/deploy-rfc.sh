#!/bin/bash

### nginx conf
cat /root/deploy/nginx.conf > /etc/nginx/nginx.conf &&

### synctree config
cat /root/deploy/agent-rfc-application.yml > /home/ubuntu/.synctree/agent-rfc-application.yml &&
cd /home/ubuntu/apps/synctree-agent-rfc/ && ./start.sh &&

### add hosts
if [ -f "/root/deploy/hosts" ]; then
    cat /root/deploy/hosts >> /etc/hosts
fi &&

/usr/sbin/service cron start && 
nginx -g 'daemon off;'
