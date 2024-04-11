#!/bin/bash
yum update -y
aws s3 cp s3://ed-web-config-project/index.html /var/www/html/
systemctl restart httpd
sudo yum install awslogs -y
sudo systemctl start awslogsd
