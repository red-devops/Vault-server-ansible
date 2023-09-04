#!/bin/bash 
export VAULT_ADDR=http://{{ private_ip_address }}:8200

cleanup() {
  rm -f tmp_file vault_initialization.json
}

trap cleanup EXIT

set -x

sleep 5
      
echo -n "{" > vault_initialization.json
vault operator init > tmp_file
let errors+=$?
let x=1
while [ ${x} -le $(grep "^Recovery Key" tmp_file | wc -l | awk '{print $1;}') ]
do
  echo -n \"vault_recovery_key_${x}\":\"$(grep "^Recovery Key ${x}:" tmp_file | awk '{print $4;}')\", >> vault_initialization.json
  let errors+=$?
  let x+=1
done
echo -n \"vault_initial_root_token\":\"$(grep "^Initial Root Token:" tmp_file | awk '{print $4;}')\" >> vault_initialization.json
let errors+=$?
let  x=1
echo -n "}" >> vault_initialization.json

if [ ${errors} -gt 0 ]
then
  exit ${errors}
else
  aws secretsmanager create-secret --name {{ vault_init_secret }} --description "Vault {{ env }} recovery keys" --secret-string file://vault_initialization.json --region {{ region }}
  if [ $? -eq 0 ]; then
    echo "Created a new secret."
  else
    echo "Failed to create a new secret. Trying to update the existing one..."
    aws secretsmanager update-secret --secret-id {{ vault_init_secret }} --description "Vault {{ env }} recovery keys" --secret-string file://vault_initialization.json --region {{ region }}
    if [ $? -eq 0 ]; then
        echo "Overwrote the existing secret."
        exit 0
    else
        echo "An error occurred while creating or overwriting the secret."
        exit 1
    fi
  fi
fi
