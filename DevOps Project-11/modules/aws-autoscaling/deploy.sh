#!/bin/bash

apt-get update -y
apt-get upgrade -y
apt-get -y install nginx
cd /var/www/html
wget https://www.tooplate.com/zip-templates/2135_mini_finance.zip
apt install unzip
unzip 2135_mini_finance.zip
rm -rf 2135_mini_finance.zip index.nginx-debian.html
cd 2135_mini_finance/
mv * ../
rm -rf 2135_mini_finance/
systemctl enable nginx
systemctl restart nginx
apt install mysql-server -y