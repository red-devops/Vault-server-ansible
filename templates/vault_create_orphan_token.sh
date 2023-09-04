#!/bin/bash 
export VAULT_ADDR=http://{{ private_ip_address }}:8200
export VAULT_TOKEN=$(aws secretsmanager get-secret-value --secret-id {{ vault_init_secret }} --region {{ region }} | jq -r .SecretString | jq -r .vault_initial_root_token)

TOKEN=$(vault token create -policy=vault-admin-policy -orphan -format=json | jq -r '.auth.client_token')

# Try to create the secret
aws secretsmanager create-secret --name cicd-vault-{{ env }}-token --description "Long term CICD token for Vault-{{ env }}" --secret-string '{"cicd-token":"'"$TOKEN"'"}' --region {{ region }} > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Created a new secret."
else
    echo "Failed to create a new secret. Trying to update the existing one..."
    aws secretsmanager update-secret --secret-id cicd-vault-{{ env }}-token --description "Long term CICD token for Vault-{{ env }}" --secret-string '{"cicd-token":"'"$TOKEN"'"}' --region {{ region }} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Overwrote the existing secret."
    else
        echo "An error occurred while creating or overwriting the secret."
    fi
fi
