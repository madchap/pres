#### Harden your secrets management with Vault
![hashicorpvault](assets/Vault_PrimaryLogo_FullColor.png?style=centerimg)

<span style="color:gray; display:block; text-align:center">Fred Blaise</span>

---
<span style="color:gray; display:block; text-align:center">How we used to manage secrets</span>


---
<span style="color:gray; display:block; text-align:center">High-level features</span>
- Platform independant and - HA (provided you've got the right backend)
- Store static or dynamic secrets
- (Dynamic) secrets have leases (automatic revokation)
- Audit logs
- 100% REST API
- Plugin architecture (authentication, secrets, audit, plugin)
- Not reached API stability yet (should be as of v1.0, currently at v.0.8.2)

---
<span style="color:gray; display:block; text-align:center">High level architecture</span>
- A simple binary file (mainly a wrapper around the REST API)
- Uses Shamir's secret sharing to unlock encryption key (which is not stored)
- The backend storage mechanism never sees the unencrypted value and doesn't have the means necessary to decrypt it without Vault

---
<span style="color:gray; display:block; text-align:center">Shamir's secret sharing</span>
"Unsealing" is the process of constructing the master key necessary to read the decryption key to decrypt the data, allowing access to the Vault.
![keys_graph](assets/vault-shamir-secret-sharing-key-schema.svg?style=centerimg)

---
<span style="color:gray; display:block; text-align:center">Open-source Vs Enterprise</span>
* Support (obviously)
* multiDC replication
* UI to manage Vault
* Apprently certains features, like MFA-related backends (e.g TOTP, Duo)

---
<span style="color:gray; display:block; text-align:center">AWS fan?</span>
Deploy Vault with ready-to-go AWS template, with prod best practices

https://aws.amazon.com/quickstart/architecture/vault/

---
<span style="color:gray; display:block; text-align:center">A word about HA</span>
* Your backend is really the redundant piece (e.g. Consul)
* You can deploy many Vault for availability, but not scalability
* Active node gets a lock, others become standby and forward requests
* Vault servers can be configured for direct access, LB or with cluster addresses

---
<span style="color:gray; display:block; text-align:center">Libraries</span>
* Official: Go, Ruby
* Community: Python, haskell, scala, java, clojure...

---
<span style="color:gray; display:block; text-align:center">Demo coverage</span>
* Initial set-up, initialization with Keybase/PGP
* Basic generic secret storage i/o
* Quick look at policies and authentication backends
* Generating on-the-fly access keys for AWS
* Encryption as a service
* PKI

---
<span style="color:gray; display:block; text-align:center">Links</span>
[![asciicast](https://asciinema.org/a/14.png)](https://asciinema.org/a/14?autoplay=1 target="_blank")
