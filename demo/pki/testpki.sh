#!/bin/bash

set -xe

source ../export_vaultvars

read -p "Do you want to unmount the rootpki and intermediatepki?: " confirmation
if [[ "$confirmation" =~ [nN] ]]; then
	exit 1
else
	vault unmount rootpki
	vault unmount intermediatepki
fi

# create mount rootpki
vault mount -path=rootpki pki
vault mount-tune -max-lease-ttl="175200h" rootpki

# create mount intermediatepki
vault mount -path=intermediatepki pki
vault mount-tune -max-lease-ttl="8760h" intermediatepki

# configure CRL and issuing URLs
vault write intermediatepki/config/urls issuing_certificates="http://127.0.0.1:8200/v1/intermediatepki/ca" crl_distribution_points="http://127.0.0.1:8200/v1/intermediatepki/crl"


# get rootpki cert
curl -s -XPOST -H "X-Vault-Token:$(cat ~/.seeds/vault_root_token)" -H "Content-Type: application/json" -d '{"common_name":"demo.com","ttl":"175200h"}' ${VAULT_ADDR}/v1/rootpki/root/generate/exported | jq -r .data.certificate > currroot.pem

openssl x509 -in currroot.pem -noout -text


# generate CSR for intermediate CA
curl -s -XPOST -H "X-Vault-Token:$(cat ~/.seeds/vault_root_token)" -H "Content-Type: application/json" -d '{"common_name":"demo-int.com","alt_names":"foo,bar"}' ${VAULT_ADDR}/v1/intermediatepki/intermediate/generate/exported | jq -r .data.csr > currcsr.pem

openssl req -in currcsr.pem -noout -text


# sign intermediate cert
curl -s -XPOST -H "X-Vault-Token:$(cat ~/.seeds/vault_root_token)" -H "Content-Type: application/json" -d "$(jq -R -s --argfile json sign_intermediate_csr.json -f inject_cert_in_file.jq currcsr.pem)" ${VAULT_ADDR}/v1/rootpki/root/sign-intermediate |jq -r .data.certificate > currcert.pem

openssl x509 -in currcert.pem -noout -text

# submit the signed ca certificate
vault write intermediatepki/intermediate/set-signed certificate=@currcert.pem

# create role
# put usr_csr_* to false to be able to override with json data
vault write intermediatepki/roles/demo-dot-com allowed_domains="demo.com" allow_subdomains=true max_ttl="72h" use_csr_common_name=false use_csr_sans=false


# generate a CSR and ask for a cert
openssl genrsa -out req.key 2048
openssl req -new -batch -sha256 -key req.key -out req.csr

# this one will fail, wrong domain!
# vault write intermediatepki/sign/demo-dot-com common_name="demo-host.com" alt_names="foo.demo.com,bar.demo.com" csr=@req.csr

# this one will work
vault write intermediatepki/sign/demo-dot-com common_name="test.demo.com" alt_names="foo.demo.com,bar.demo.com" csr=@req.csr


# same via curl, get the cert out with jq
curl -s -XPOST -H "X-Vault-Token:$(cat ~/.seeds/vault_root_token)" -d "$(jq -R -s --argfile json sign_request_csr.json -f inject_cert_in_file.jq req.csr)" ${VAULT_ADDR}/v1/intermediatepki/sign/demo-dot-com | jq -r .data.certificate > req.cert

openssl x509 -in req.cert -noout -text

# List all current certificates
curl -s -XLIST -H "X-Vault-Token:$(cat ~/.seeds/vault_root_token)" ${VAULT_ADDR}/v1/intermediatepki/certs | jq
