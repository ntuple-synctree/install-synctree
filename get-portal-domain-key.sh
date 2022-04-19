#!/bin/bash

export PORTAL_DOMAIN_KEY=`mysql -h $AURORA_DATA_ENDPOINT -u $AURORA_DATA_USERNAME -p$AURORA_DATA_PASSWORD -D synctree_portal -e "select portal_url from portal_list where portal_list_id = 1;" | sed -n '2p'`


if [[ `cat ~/env.sh | grep "PORTAL_DOMAIN_KEY"` == "" ]]
then
    echo "export PORTAL_DOMAIN_KEY=$PORTAL_DOMAIN_KEY" >> ~/env.sh
else
    sed -i "/PORTAL_DOMAIN_KEY/d" ~/env.sh
    echo "export PORTAL_DOMAIN_KEY=$PORTAL_DOMAIN_KEY" >> ~/env.sh
fi


echo "PORTAL DOMAIN KEY : $PORTAL_DOMAIN_KEY"
