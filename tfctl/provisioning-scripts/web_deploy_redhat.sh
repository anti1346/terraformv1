#!/usr/bin/env bash

sudo yum install -y httpd

sudo systemctl --now enable httpd

echo "<h1> hello world </h1>" | sudo tee /var/www/html/index.html