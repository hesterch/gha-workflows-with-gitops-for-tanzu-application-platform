#!/usr/bin/env bash

# Converts .tpl files in this package to .yml
# A .env file should be colocated in the same directory as this script with all environment variable values defined

if [ -f ".env" ]; then
  source .env
else
  echo " You forgot to provide a .env file with environment variable values set appropriately.  See .env.sample."
  exit 1
fi

# Convert .init/ingress-install-config.tpl to .init/ingress-install-config.yml
sed \
  -e "s/{{ .domain }}/$DOMAIN/g" \
  .init/ingress-install-config.tpl > .init/ingress-install-config.yml

# Convert .init/ingress-install-secrets.tpl to .init/ingress-install-secrets.yml
sed \
  -e "s/{{ .oracle_compartment_id }}/$ORACLE_COMPARTMENT_ID/g" \
  -e "s/{{ .oracle_region }}/$ORACLE_REGION/g" \
  -e "s/{{ .oracle_tenancy_id }}/$ORACLE_TENANCY_ID/g" \
  -e "s/{{ .oracle_user_id }}/$ORACLE_USER_ID/g" \
  -e "s/{{ .oracle_fingerprint }}/$ORACLE_FINGERPRINT/g" \
  -e "s/{{ .oracle_key_file_contents }}/$ORACLE_KEY_FILE_CONTENTS/g" \
  -e "s/{{ .git_ssh_private_key }}/$GIT_SSH_PRIVATE_KEY/g" \
  -e "s/{{ .git_ssh_known_hosts }}/$GIT_SSH_KNOWN_HOSTS/g" \
  .init/ingress-install-secrets.tpl > .init/ingress-install-secrets.yml
