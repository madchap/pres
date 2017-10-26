### Harden your secrets management with 
![hashicorpvault](assets/Vault_PrimaryLogo_FullColor.png?style=centerimg)

<span style="color:gray; font-size:0.4em">Fred Blaise</span>

--- 
<span style="color:gray; display:block; text-align:center">What is a secret?</span>
<span style="display:block; text-align:right; color:white">"Something that is not known or seen, and not meant to be"</span>

- For most people, just a password (or a lie!?)
- For the rest of us, a private key, a certificate, access keys, API keys, ...


---
<span style="color:gray; display:block; text-align:center">Traditional ways to manage secrets</span>
- A password with a certain complexity, that need to be manually rotated every X days.
- A demand to our admin for a SSL certificate.
- An expensive HSM, keeping keys in actual safes.
- One-time database account, with a password (possibly set to never expire).
- One-time "name-your-cloud" account, with a static set of keys.

- A PITA whenever someone leaves the company.

Everything is very manual, time consuming and not very Dev[Sec]Ops friendly.

 <span style="color:gray; font-size:0.4em">Some fun facts: https://www.itworld.com/article/2823169/security/135075-Sher-locked-12-famous-passwords-used-through-the-ages.html</span>


---
![keys_graph](assets/passwords_like_underwear.png?style=centerimg)


---
<span style="color:gray; display:block; text-align:center">What we want for our secrets</span>
- We want it now and self-service, automated.
- Not have to worry about our secret being out in the wild.
- Possibly not having to worry about revoking secrets.
- We want to be able to track everything.

---
<span style="color:gray; display:block; text-align:center">Vault high-level features</span>
- Platform independant and HA (provided you've got the right backend)
- Securely store static or dynamic secrets
- (Dynamic) secrets have leases (automatic revokation)
- Audit logs
- 100% REST API
- Plugin architecture (authentication, secrets, audit, plugin)
- Not reached API stability yet (should be as of v1.0, currently at v.0.8.2)

All for free as in beer and as in speech (unless you want to go "enterprise")


---
<span style="color:gray; display:block; text-align:center">High level architecture</span>
- A simple binary file (mainly a wrapper around the REST API).
- Plugins architecture for secret and authentication.
- Uses Shamir's secret sharing to unlock encryption key (which is not stored).
- The backend storage mechanism never sees the unencrypted value and doesn't have the means necessary to decrypt it without Vault.
- Solves chicken-egg problem of needing to store the key to access encrypted data.


---
<span style="color:gray; display:block; text-align:center">Shamir's secret sharing</span>
"Unsealing" is the process of constructing the master key necessary to read the decryption key to decrypt the data, allowing access to the Vault.
![keys_graph](assets/shamirs_diagram.png?style=centerimg)


---
<span style="color:gray; display:block; text-align:center">Open-source Vs Enterprise</span>
* Support (obviously)
* multiDC replication
* UI to manage Vault
* Apprently certains features, like MFA-related backends (e.g TOTP, Duo)


---
<span style="color:gray; display:block; text-align:center">A word about HA</span>
* Your backend is really the redundant piece (e.g. Consul)
* You can deploy many Vault for availability, but not scalability
* Active node gets a lock, others become standby and forward requests
* Vault servers can be configured for direct access, LB or with cluster addresses


---
<span style="color:gray; display:block; text-align:center">AWS fan?</span>
Deploy Vault with ready-to-go AWS template, with prod best practices

https://aws.amazon.com/quickstart/architecture/vault/


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
* (Encryption as a service)
* PKI


---
<span style="color:gray; display:block; text-align:center">Links</span>
* My demo asciicasts starting with "vault - ": https://asciinema.org/~madchap
* Source (scripts and slides): https://github.com/madchap/pres/tree/vault_pres


---
<span style="color:gray; display:block; text-align:center">Thank you</span>
