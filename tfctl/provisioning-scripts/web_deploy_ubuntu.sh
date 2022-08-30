#!/usr/bin/env bash

sudo apt-get update

sudo apt-get install -y apache2

sudo systemctl --now enable apache2

echo "<h1> hello world </h1>" | sudo tee /var/www/html/index.html