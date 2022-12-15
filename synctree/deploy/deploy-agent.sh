#!/bin/bash
### deploy-agent config
cat /root/deploy/deploy-agent-env > /home/ubuntu/apps/synctree-deploy-agent/.env &&

### only Sender Agent(운영은 주석처리) ###
(crontab -l 2>/dev/null; echo "* * * * * php /home/ubuntu/apps/synctree-deploy-agent/artisan deploy:projects > /dev/null 2>&1") | crontab -


