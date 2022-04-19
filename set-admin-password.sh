#!/bin/bash

script_name=$0

if [ "$1" == "" ] 
then
	echo -e "usage: $script_name [admin_password]\n";
	echo -e "example: $script_name 'Password1!'" 
	exit
fi

NEW_ADMIN_PASSWORD="$1"

if [[ `cat ~/env.sh | grep ADMIN_PASSWORD` == "" ]]
then
	echo "export ADMIN_PASSWORD=$NEW_ADMIN_PASSWORD" >> ~/env.sh
else
	sed -i "/ADMIN_PASSWORD/d" ~/env.sh
	echo "export ADMIN_PASSWORD=$NEW_ADMIN_PASSWORD" >> ~/env.sh
fi


cp ./templates/0.Database_User_Create_Data.sql ./sql/data/0.Database_User_Create.sql
cp ./templates/0.Database_User_Create_Log.sql ./sql/log/0.Database_User_Create.sql

sed -Ei "s|YOUR-ADMIN-PASSWORD|$NEW_ADMIN_PASSWORD|g" ./sql/data/0.Database_User_Create.sql
sed -Ei "s|YOUR-ADMIN-PASSWORD|$NEW_ADMIN_PASSWORD|g" ./sql/log/0.Database_User_Create.sql

