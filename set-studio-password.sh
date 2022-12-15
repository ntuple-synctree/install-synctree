#!/bin/bash

script_name=$0

if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ]
then
	echo -e "usage: $script_name [username] [email] [password\n";
	echo -e "example: $script_name root root@test.com Password1!" 
	exit
fi

NEW_STUDIO_USER_NAME="$1"
NEW_STUDIO_USER_EMAIL="$2"
NEW_STUDIO_USER_PASSWORD="$3"


if [[ `cat ~/env.sh | grep STUDIO_USER_NAME` == "" ]]
then
	echo "export STUDIO_USER_NAME=$NEW_STUDIO_USER_NAME" >> ~/env.sh
else
	sed -i "/STUDIO_USER_NAME/d" ~/env.sh
	echo "export STUDIO_USER_NAME=$NEW_STUDIO_USER_NAME" >> ~/env.sh
fi

if [[ `cat ~/env.sh | grep STUDIO_USER_EMAIL` == "" ]]
then
	echo "export STUDIO_USER_EMAIL=$NEW_STUDIO_USER_EMAIL" >> ~/env.sh
else
	sed -i "/STUDIO_USER_EMAIL/d" ~/env.sh
	echo "export STUDIO_USER_EMAIL=$NEW_STUDIO_USER_EMAIL" >> ~/env.sh
fi


if [[ `cat ~/env.sh | grep STUDIO_USER_PASSWORD` == "" ]]
then
	echo "export STUDIO_USER_PASSWORD=$NEW_STUDIO_USER_PASSWORD" >> ~/env.sh
else
	sed -i "/STUDIO_USER_PASSWORD/d" ~/env.sh
	echo "export STUDIO_USER_PASSWORD=$NEW_STUDIO_USER_PASSWORD" >> ~/env.sh
fi

cp ./templates/03.DataDB_Account_Data_Insert.sql ./sql/

sed -Ei "s|YOUR-STUDIO-USERNAME|$NEW_STUDIO_USER_NAME|g" ./sql/03.DataDB_Account_Data_Insert.sql
sed -Ei "s|YOUR-STUDIO-EMAIL|$NEW_STUDIO_USER_EMAIL|g" ./sql/03.DataDB_Account_Data_Insert.sql
sed -Ei "s|YOUR-STUDIO-PASSWORD|$NEW_STUDIO_USER_PASSWORD|g" ./sql/03.DataDB_Account_Data_Insert.sql

