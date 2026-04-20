#!/bin/sh

set -xe

sleep 30
ansible-playbook \
    -i "$(terraform output -raw instance_ip)," \
    -u ubuntu \
    --ssh-extra-args='-o StrictHostKeyChecking=no' \
    --private-key=$SSH_KEY \
    playbook.yml \
    -e telegram_bot_token=$TG_TOKEN
