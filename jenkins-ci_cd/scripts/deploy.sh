#!/bin/bash

HOST_NAME="ubuntu@$1"

rsync -avz -e "sudo ssh -o StrictHostKeyChecking=no -i /path/to/Key.pem" ./ $HOST_NAME:/var/www/html
ssh  -o StrictHostKeyChecking=no -i /path/to/Key.pem  $HOST_NAME 'sudo systemctl restart nodeapp'