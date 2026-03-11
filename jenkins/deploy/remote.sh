#!/bin/sh

set -xeu

sudo install /tmp/app.jar /usr/local/lib/tripplanner/
sudo install /tmp/env /etc/tripplanner/env
sudo install /tmp/tripplanner.service /usr/local/lib/systemd/system/

sudo systemctl restart tripplanner
