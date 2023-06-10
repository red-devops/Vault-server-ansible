#!/bin/bash 
export VAULT_ADDR=http://{{ private_ip_address }}:8200
export VAULT_TOKEN=$(aws secretsmanager get-secret-value --secret-id {{ vault_init_secret }} --region {{ region }} | jq -r .SecretString | jq -r .vault_initial_root_token)

vault policy write vault-admin-policy {{ vault_policy_home }}/vault-admin.hcl
exit 0