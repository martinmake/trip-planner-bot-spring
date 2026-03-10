#!/bin/sh

set -xeu

command="create"
if openstack stack show "$STACK_NAME" >/dev/null 2>&1; then
    command="update"
fi

exec openstack stack ${command} --wait -t jenkins/orchestrate/heat.yaml \
  --parameter "image=${IMAGE}"                                          \
  --parameter "flavor=${FLAVOR}"                                        \
  --parameter "key_name=${KEY_NAME}"                                    \
  --parameter "network=${NETWORK}"                                      \
  ${STACK_NAME}
