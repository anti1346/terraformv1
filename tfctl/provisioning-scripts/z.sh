#!/bin/bash

# Wait for cloud-init to finish
while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done

sleep 30

echo "script execute"

echo \"FOO is $FOO\" > example.txt
