listener "tcp" {
  address = "{{ private_ip_address }}:8200"
  tls_disable = 1
}

storage "dynamodb" {
  region     = "{{ region }}"
  table      = "vault-{{ env }}-storage-table"
}

api_addr = "http://{{ private_ip_address }}:8200"
cluster_addr = "http://{{ private_ip_address }}:8201"

ui = false

seal "awskms" {
region     = "{{ region }}"
kms_key_id = "{{ kms_key_id }}"
}