#!/bin/sh

set -xe

: ${YC_FOLDER_ID:=b1gj8t6a23qthe0mdeck}
: ${SSH_PUB_KEY:=ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRy2xTx1XiYIsphsrJyZtQ3qguTFxwIfHOY+v7/j7yB (none)}

terraform init -input=false
terraform apply -input=false -auto-approve \
          -var="folder_id=${YC_FOLDER_ID}" \
          -var="ssh_public_key=${SSH_PUB_KEY}"
terraform output -raw instance_ip
