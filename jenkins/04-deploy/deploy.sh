#!/bin/sh

set -xe

if [ -z "$VM_HOST" ]; then
    VM_HOST=$(openstack stack output show ${STACK_NAME} instance_ip -f value -c output_value 2>/dev/null)
    if [ "$?" != 0 ]; then
       echo "VM_HOST is empty and could not get from Heat stack.  Set VM_HOST parameter or run infra job first."
       exit 1
    fi
fi

VM_HOST=$VM_HOST

JAR_PATH="TripPlannerBot/build/libs"
JAR=$(ls $JAR_PATH/*.jar | head -1)
if [ -z "$JAR" ]; then
    echo "No JAR found in: ${JAR_PATH}"
    exit 1
fi

echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN" > env
echo "ADMIN_API_KEY=$ADMIN_API_KEY" >> env
scp -o StrictHostKeyChecking=no env ${SSH_USER}@${VM_HOST}:/tmp/env
rm env
scp -o StrictHostKeyChecking=no ${JAR} ${SSH_USER}@${VM_HOST}:/tmp/app.jar
scp -o StrictHostKeyChecking=no "jenkins/deploy/tripplanner.service" ${SSH_USER}@${VM_HOST}:/tmp/
ssh -o StrictHostKeyChecking=no ${SSH_USER}@${VM_HOST} 'sh -s /dev/stdin' < "jenkins/04-deploy/remote.sh"
