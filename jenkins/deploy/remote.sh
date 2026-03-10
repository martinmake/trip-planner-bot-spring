#!/bin/sh

set -xeu

sudo install /tmp/app.jar /opt/tripplanner/
sudo install /tmp/tripplanner.service /etc/systemd/system/

sudo systemctl restart tripplanner
