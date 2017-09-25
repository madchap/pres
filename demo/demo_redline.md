# Initial setup
## consul
* Start consul backend (docker)
`$ docker run --name consul1 -p 8500:8500 -p 8600:53/udp -v consul_data_1:/consul/data -v consul_config_1:/consul/config consul agent -server -ui -client 0.0.0.0 -node consul1 -bootstrap`

* check consul members seen
`$ consul members`

* check web UI
http://localhost:8500

## vault
* source vault variable
`source export_vaultvars`

* start vault

`$ vault server -config=config.hcl`

* vault init

To be able to re-init, clean the backend manually. i.e for vault:

`$ curl -X DELETE 'http://localhost:8500/v1/kv/vault?recurse'`

Can check values with

`$ curl http://127.0.0.1:8500/v1/kv/?recurse | jq `

get core config: `consul kv get vault/core/seal-config`

* vault init with keybase (or pgp/gpg)

`$ vault init -key-shares=1 -key-threshold=1 -pgp-keys="keybase:madchap"`

decrypt as:

`$ echo "wcBMA8BJ7HuDcqtYAQgANXBFEEWilppVDkPVyL0ktpI9whPVDaJ2aS+6xxTXgBfAETbBCt+wwxCz9neX518N7juhQD/1M6P5Em+C3kmmV1aFZNDL/QZlGIKOO5J6x5IxcsETAPzZQEf1xPargzY1NLh2imWIgoiJsNfUn/XxJTzST9kFXnS7Te8cEkM9qKefWpwWgJmLjzP86X/fUd+UjIb1oO9WEnN6x58klONAVBSQvnNg03VN53ekwqpIZVV4xSaUiJSBzigZLuGQjyGgWIAYXVYy16ukCmCbxWGv84+TdqrVx9inbD42gTGndejGdOM61oevNWncfRB0hAJfsim1lUs1LHrjD50apvzajdLgAeQDPrEtSbTMt0NZrR6ravtj4VGs4HTgL+FAsuCv4tiB5AfgBubr6/a7bgFunRO9ervldgA7zze7TgbyriRchn3PLMnyqKENrcsJXV7iLibuIryQcX1PF7uqaE8ZlEno6wHMNwYp4HPkJgFJbCYGmPdVzxpLomjHBeL/TdFB4fdHAA==" | base64 -d | keybase pgp decrypt`

* Unseal for operations

`$ vault unseal`

## Enable basic audit to file

`$ vault audit-enable file path=/tmp/vault_audit.log`


# Basics

* basic write/read through CLI

Leveraging the default generic backend 'secret'.

```
$ vault write secret/meetup name=devsecops message="hello devsecops'ers" excited=yes
$ vault read secret/meetup
$ vault read -format json secret/meetup
```

* mounts

`$ vault mounts`

* Create a new generic mount, e.g. for own private secret (can be applied a much restritive policy)

`$ vault mount -description "Private mount for my own dirty secrets" -path fbi-private generic`

# Policies
Quick look to protect my fbi-private mount

```
path "fbi-private/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
```

Create the policy

`$ vault write sys/policy/fbi-private rules=@fbi-private.hcl`

Create a token with this policy (and others potentially)

`$ vault token-create -policy=fbi-private`

Try to create with that token and with another.

> There is no way to modify the policies associated with a token once the token has been issued. The token must be revoked and a new one acquired to receive a new set of policies.

> Policies are evaluated live, any change is directly applicable.

# Auth backends
## Userpass
> Case insensitive!

`$ vault auth-enable userpass`

List enabled auth backends

```
vault auth -methods
Path       Type      Accessor                Default TTL  Max TTL  Replication Behavior  Description
token/     token     auth_token_afb9096b     system       system   replicated            token based credentials
userpass/  userpass  auth_userpass_54f58a84  system       system   replicated
```

## Create a user
If using the cli tool, better put the password in a temporary file, then delete it
* `vi /tmp/temppass`
* `vault write auth/userpass/users/fbi policies=fbi-private password=$(cat /tmp/temppass)`
* `rm -f /tmp/temppass`

## Auth
* `vault auth -method=userpass username=fbi`

> Password will be asked, contrary to when creating the user.

Beware, if you have VAULT_TOKEN set, look at the token policy.

```
vault auth -method=userpass username=fbi
==> WARNING: VAULT_TOKEN environment variable set!

  The environment variable takes precedence over the value
  set by the auth command. Either update the value of the
  environment variable or unset it to use the new token.

Password (will be hidden):
Successfully authenticated! You are now logged in.
The token below is already saved in the session. You do not
need to "vault auth" again with the token.
token: 723212d5-1482-3c56-8e67-872347300524
token_duration: 0
token_policies: [root]
```

Unsetting the variable:
```
$ unset VAULT_TOKEN
$ vault auth -method=userpass username=fbi
Password (will be hidden):
Successfully authenticated! You are now logged in.
The token below is already saved in the session. You do not
need to "vault auth" again with the token.
token: fb1114a0-3291-9b67-d7c4-00d48c092915
token_duration: 2764800
token_policies: [default fbi-private]
```

## aws


# Some more use-cases
## AWS
read/write IAM policies and access tokens

`$ vault mount aws`

> Access key age!

## configure credentials
Better to use an IAM user than root.

> Note: root here does not mean 'root' user for aws.

`$ vault write aws/config/root access_key=$(cat ~/.seeds/aws_blaise_akey) secret_key=$(cat ~/.seeds/aws_blaise_skey)`

Note: Can't read back the creds!

## On the fly IAM creds creation
### deploy the policy
Have to have a policy assigned to the user at creation
* Have your AWS policy in json format handy. Example for a read-only cloudtrail policy.

`$ vault write aws/roles/cloudtrail_custom policy=@aws_policy_cloudtrail.json`

or you can directly use a pre-made policy from AWS

`$ vault write aws/roles/aws_cloudtrail_ro arn=arn:aws:iam::aws:policy/AWSCloudTrailReadOnlyAccess`


### create on the fly accounts
Simple as vault

```
$ vault read aws/creds/aws_cloudtrail_ro`
$ curl -X GET -H "X-Vault-Token:$VAULT_TOKEN" http://127.0.0.1:8200/v1/aws/creds/aws_cloudtrail_ro
```

> note the lease ID, needed to later revoke.

### list your leases
`curl -X LIST -H "X-Vault-Token:$VAULT_TOKEN" http://127.0.0.1:8200/v1/sys/leases/lookup/aws/creds/aws_cloudtrail_ro/`

### revoke your account when no longer needed
This could be as early as when your script is actually done running

`$ vault revoke your_lease_id`
`$ curl -X PUT -H "X-Vault-Token:$VAULT_TOKEN" http://127.0.0.1:8200/v1/sys/leases/revoke --data '{"lease_id":"aws/creds/aws_cloudtrail_ro/dc687ee2-0b20-0561-3f65-05c2665510bb"}'

> Danger: could revoke by prefix too, such as `vault revoke -prefix aws/`

## encryption as a service
Welcome backend "transit", does not store anything.

`$ vault mount transit`

### Create a named key
`$ vault write -f transit/keys/useme`

### Encrypt from your app
Need to feed base64
`$ echo -n "We rockz our sockz" |base64 |vault write transit/encrypt/useme plaintext=-`

### Decrypt
```
vault write -format=json transit/decrypt/useme \
	ciphertext=$(echo -n "We rockz our sockz" |base64 \
		|vault write -format=json transit/encrypt/useme plaintext=- \
		|jq -r .data.ciphertext) \
	|jq -r .data.plaintext \
	|base64 -d
```

## PKI
* Root CA outside of vault --> make short-lived intermediate CA's instead in vault
* 1 CA per backend, mount multiple times if want to issue from multiple CAs
* common pattern is to have the `pki` mounted for the root CA, and other `pki` mounts for intermediate CAs


Set the URLs (CRL and for issuing certs)

`$ vault write pki/config/urls issuing_certificates="http://127.0.0.1:8200/v1/pki/ca" crl_distribution_points="http://127.0.0.1:8200/v1/pki/crl"`

Create an intermediary certificate



## ssh
### host signing
### user signing
### key rotations

