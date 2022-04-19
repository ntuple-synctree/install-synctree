#!/bin/bash
(crontab -l 2>/dev/null; echo "* * * * * php /usr/local/bin/syrn schedule:run:bizunit production > /dev/null 2>&1") | crontab -

### for debug ###
# (crontab -l 2>/dev/null; echo "* * * * * php /usr/local/bin/syrn schedule:run:bizunit production >> /home/ubuntu/apps/synctree-tool/logs/syrn.log 2>&1") | crontab -
