#!/bin/bash 
export VAULT_ADDR=http://{{ private_ip_address }}:8200
export VAULT_TOKEN=$(aws secretsmanager get-secret-value --secret-id {{ vault_init_secret }} --region {{ region }} | jq -r .SecretString | jq -r .vault_initial_root_token)

vault secrets enable -version=2 -path=secret/kv kv
exit 0