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
  -e "s/{{ .email_address }}/$EMAIL_ADDRESS/g" \
  -e "s/{{ .azure_ad_tenant_id }}/$AZURE_AD_TENANT_ID/g" \
  -e "s/{{ .azure_subscription_id }}/$AZURE_SUBSCRIPTION_ID/g" \
  -e "s/{{ .azure_ad_client_id }}/$AZURE_AD_CLIENT_ID/g" \
  -e "s/{{ .azure_ad_client_secret }}/$AZURE_AD_CLIENT_SECRET/g" \
  -e "s/{{ .azure_resource_group_name }}/$AZURE_RESOURCE_GROUP_NAME/g" \
  -e "s/{{ .git_ssh_private_key }}/$GIT_SSH_PRIVATE_KEY/g" \
  -e "s/{{ .git_ssh_known_hosts }}/$GIT_SSH_KNOWN_HOSTS/g" \
  .init/ingress-install-secrets.tpl > .init/ingress-install-secrets.yml
