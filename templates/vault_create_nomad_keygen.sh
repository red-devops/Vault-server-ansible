#!/bin/bash 
export VAULT_ADDR=http://{{ private_ip_address }}:8200
export VAULT_TOKEN=$(aws secretsmanager get-secret-value --secret-id {{ vault_init_secret }} --region {{ region }} | jq -r .SecretString | jq -r .vault_initial_root_token)

NOMAD_KEYGEN=$(/tmp/nomad operator gossip keyring generate)
vault kv put kv/nomad/keygen key=$NOMAD_KEYGEN
exit 0
