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
  -e "s/{{ .aws_access_key_id }}/$AWS_ACCESS_KEY_ID/g" \
  -e "s/{{ .aws_secret_access_key }}/$AWS_SECRET_ACCESS_KEY/g" \
  -e "s/{{ .aws_region }}/$AWS_REGION/g" \
  -e "s/{{ .aws_route53_hosted_zone_id }}/$AWS_AWS_ROUTE53_HOSTED_ZONE_ID/g" \
  -e "s/{{ .git_ssh_private_key }}/$GIT_SSH_PRIVATE_KEY/g" \
  -e "s/{{ .git_ssh_known_hosts }}/$GIT_SSH_KNOWN_HOSTS/g" \
  .init/ingress-install-secrets.tpl > .init/ingress-install-secrets.yml
