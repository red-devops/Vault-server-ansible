# HashiCorp Vault Server - Post Provisioning Ansible

The content of this project is part of the post on blog https://red-devops.pl/<br>

The repository includes ansible playbook which installs and run HashiCorp Vault server on ubuntu host. Vault's configuration includes storage hosted in AWS DynamoDB, as well as auto unsealing with AWS Key Management Service (KMS). Ansible automatically reads and uploads the recovery key in JSON to AWS Secrets Manager, and creates, a token with administrative policy in the Vault server for build tools such as GitHub Actions.
