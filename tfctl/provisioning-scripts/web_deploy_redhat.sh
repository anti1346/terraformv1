#!/bin/bash

sudo yum update -y

## Apache　Setup
sudo yum install -y httpd

sudo chown -R apache:apache /var/www/html

sudo systemctl --now enable httpd

echo "<h1> hello world </h1>" | sudo tee /var/www/html/index.html
