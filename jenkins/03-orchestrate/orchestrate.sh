#!/bin/sh

set -xeu

. /var/lib/jenkins/.venv/bin/activate

command="create"
if openstack stack show "${STACK_NAME}" >/dev/null 2>&1; then
    command="update"
fi

if ! openstack stack ${command} --wait -t jenkins/orchestrate/heat.yaml \
     --parameter "image=${IMAGE}"                                       \
     --parameter "flavor=${FLAVOR}"                                     \
     --parameter "key_name=${KEY_NAME}"                                 \
     --parameter "network=${NETWORK}"                                   \
     "${STACK_NAME}"; then
    openstack stack delete "${STACK_NAME}"
    exit 1
fi
