#!/bin/sh

set -xeu

sudo install -D --target-directory /usr/local/lib/tripplanner/ /tmp/app.jar
sudo install -D --target-directory /etc/tripplanner/ /tmp/env
sudo install -D --target-directory /etc/systemd/system/ /tmp/tripplanner.service
sudo install -d /var/lib/tripplanner

sudo systemctl daemon-reload
sudo systemctl restart tripplanner
