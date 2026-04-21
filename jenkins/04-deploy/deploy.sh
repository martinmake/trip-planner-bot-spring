#!/bin/sh

set -xe

JAR_PATH="TripPlannerBot/build/libs"
JAR=$(ls $JAR_PATH/*.jar | head -1)
if [ -z "$JAR" ]; then
    echo "No JAR found in: ${JAR_PATH}"
    exit 1
fi

echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN" > env
echo "ADMIN_API_KEY=$ADMIN_API_KEY" >> env
scp -i "$SSH_KEY" -o StrictHostKeyChecking=no env ${SSH_USER}@${VM_HOST}:/tmp/env
rm env
scp -i "$SSH_KEY" -o StrictHostKeyChecking=no ${JAR} ${SSH_USER}@${VM_HOST}:/tmp/app.jar
scp -i "$SSH_KEY" -o StrictHostKeyChecking=no "jenkins/deploy/tripplanner.service" ${SSH_USER}@${VM_HOST}:/tmp/
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no ${SSH_USER}@${VM_HOST} 'sh -s /dev/stdin' < "jenkins/04-deploy/remote.sh"
