#!/bin/bash 
export VAULT_ADDR=http://{{ private_ip_address }}:8200
export VAULT_TOKEN=$(aws secretsmanager get-secret-value --secret-id {{ vault_init_secret }} --region {{ region }} | jq -r .SecretString | jq -r .vault_initial_root_token)

CONSUL_KEYGEN=$(/tmp/consul keygen)
vault kv put kv/consul/keygen key=$CONSUL_KEYGEN
exit 0
