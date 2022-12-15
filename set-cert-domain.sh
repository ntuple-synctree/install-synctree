#!/bin/bash

script_name=$0

if [ "$1" == "" ] || [ "$2" == "" ]
then
	echo -e "usage: $script_name [cert_arn] [domain]\n";
	echo -e "example: $script_name arn:aws:acm:ap-northeast-2:013817514782:certificate/2e7d0g9b-134b-4253-c3e4-57f0b2e5615f mydomain.com" 
	exit
fi

CERT_ARN="$1"
DOMAIN_NAME="$2"

# Ingress
cp ./synctree/alb/ingress.yaml ./synctree/alb/ingress.yaml.bak
cp ./templates/ingress-https.yaml ./synctree/alb/ingress.yaml

sed -Ei "s|YOUR-CERT-ARN|$CERT_ARN|g" ./synctree/alb/ingress.yaml
sed -i "s/YOUR-DOMAIN/$DOMAIN_NAME/g" ./synctree/alb/ingress.yaml

# backup credentials
if [ ! -e "./synctree/deploy/credentials.bak" ]
then
    cp ./synctree/deploy/credentials ./synctree/deploy/credentials.bak
fi

# Change http to https
cp ./synctree/deploy/credentials.bak ./synctree/deploy/credentials
sed -Ei "s|http://studio|https://studio|g" ./synctree/deploy/credentials
sed -Ei "s|http://tool|https://tool|g" ./synctree/deploy/credentials
sed -Ei "s|http://api|https://api|g" ./synctree/deploy/credentials
sed -Ei "s|http://portal|https://portal|g" ./synctree/deploy/credentials

# Change domain name
sed -i "s/your-domain.com/$DOMAIN_NAME/g" ./synctree/deploy/credentials



