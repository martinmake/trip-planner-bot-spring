#!/bin/sh

set -xeu

sudo install -D --target-directory /usr/local/lib/tripplanner/ /tmp/app.jar
sudo install -D --target-directory /etc/tripplanner/ /tmp/env
sudo install -D --target-directory /usr/local/lib/systemd/system/ /tmp/tripplanner.service

sudo systemctl restart tripplanner
