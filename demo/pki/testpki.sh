#!/bin/bash

# Crude demo script for Vault PKI
# Out of lazyness, read and set -x are my friends here
# asciicast available at https://asciinema.org/a/142823

set -xe

source ../export_vaultvars

echo
cat ./testpki_disclaimer.txt
sleep 5

read -p "Destructive action: Do you want to unmount the possibly existing rootpki and intermediatepki?: " confirmation
if [[ "$confirmation" =~ [nN] ]]; then
	exit 1
else
	vault unmount rootpki
	vault unmount intermediatepki
fi

echo
read -p "Let's mount the root CA at path 'rootpki'" 
echo

# create mount and tune rootpki - valid 20 years
vault mount -path=rootpki pki
vault mount-tune -max-lease-ttl="175200h" rootpki

echo
read -p "Now, let's do the intermediate CA"
echo

# create mount and tune intermediatepki - valid 1 year
vault mount -path=intermediatepki pki
vault mount-tune -max-lease-ttl="8760h" intermediatepki

echo
read -p "Configuration of the CRL and issuing URLs happen here"
echo
# configure CRL and issuing URLs
vault write intermediatepki/config/urls issuing_certificates="http://127.0.0.1:8200/v1/intermediatepki/ca" crl_distribution_points="http://127.0.0.1:8200/v1/intermediatepki/crl"

echo
read -p "Get our root CA certificate and show it"
echo
# get rootpki cert
curl -s -XPOST -H "X-Vault-Token:$(cat ~/.seeds/vault_root_token)" -H "Content-Type: application/json" -d '{"common_name":"demo.com","ttl":"175200h"}' ${VAULT_ADDR}/v1/rootpki/root/generate/exported | jq -r .data.certificate > currroot.pem

echo && sleep 2
# output the certificate text
openssl x509 -in currroot.pem -noout -text

echo
read -p "Generate the CSR for our intermediate CA and show it."
echo
# generate CSR for intermediate CA
curl -s -XPOST -H "X-Vault-Token:$(cat ~/.seeds/vault_root_token)" -H "Content-Type: application/json" -d '{"common_name":"demo-int.com","alt_names":"foo,bar"}' ${VAULT_ADDR}/v1/intermediatepki/intermediate/generate/exported | jq -r .data.csr > currcsr.pem

echo && sleep 2
# output CSR text
openssl req -in currcsr.pem -noout -text


echo
read -p "Sign our just created CSR against our root CA and show it"
echo
# sign intermediate cert with our rootpki
curl -s -XPOST -H "X-Vault-Token:$(cat ~/.seeds/vault_root_token)" -H "Content-Type: application/json" -d "$(jq -R -s --argfile json sign_intermediate_csr.json -f inject_cert_in_file.jq currcsr.pem)" ${VAULT_ADDR}/v1/rootpki/root/sign-intermediate |jq -r .data.certificate > currcert.pem

echo && sleep 2
# output the signed intermediate cert text
openssl x509 -in currcert.pem -noout -text


echo
read -p "Now we submit our signed CA to Vault"
echo
# submit the signed ca certificate
vault write intermediatepki/intermediate/set-signed certificate=@currcert.pem

# create role
# put usr_csr_* to false to be able to override with json data
echo
read -p "Creating a role for our intermediate PKI. That role will allow us to generate SSL certificates dynamically for a specific domain and possible subdomains, as specified."
echo
vault write intermediatepki/roles/demo-dot-com allowed_domains="demo.com" allow_subdomains=true max_ttl="72h" use_csr_common_name=false use_csr_sans=false


echo
read -p "Now, let's pretend we want to get a SSL certificate from what we've just setup. Using plain old openssl..."
echo
## client side asking for a ssl cert
# generate a CSR and ask for a cert
openssl genrsa -out req.key 2048
openssl req -new -batch -sha256 -key req.key -out req.csr

# this one will fail, wrong domain! (Remove set -e to get it to continue past the error)
# vault write intermediatepki/sign/demo-dot-com common_name="demo-host.com" alt_names="foo.demo.com,bar.demo.com" csr=@req.csr

# this one will work, that's the right domain
echo
read -p "Simply requesting our 'role' to give us a cert for test.demo.com, with a couple alt names"
echo
vault write intermediatepki/sign/demo-dot-com common_name="test.demo.com" alt_names="foo.demo.com,bar.demo.com" csr=@req.csr

echo
read -p "We could obviously do the same via curl or any other means to tackle the REST API"
echo
# same via curl, get the cert out with jq
curl -s -XPOST -H "X-Vault-Token:$(cat ~/.seeds/vault_root_token)" -d "$(jq -R -s --argfile json sign_request_csr.json -f inject_cert_in_file.jq req.csr)" ${VAULT_ADDR}/v1/intermediatepki/sign/demo-dot-com | jq -r .data.certificate > req.cert

echo && sleep 2
# output the cert text
openssl x509 -in req.cert -noout -text


echo
read -p "Let's list our certs, which reside under our intermediate CA"
echo
# List all current certificates
curl -s -XLIST -H "X-Vault-Token:$(cat ~/.seeds/vault_root_token)" ${VAULT_ADDR}/v1/intermediatepki/certs | jq

echo
echo "That's it folks. You've successfully setup a root CA, intermediate CA as well as requested and got delivered an web SSL certificate!"
