storage "consul" {
  address = "127.0.0.1:8500"
  path = "vault"
}

listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = true // dev only
}

disable_mlock = true // dev only, or encrypted swap, or `sudo setcap cap_ipc_lock=+ep $(readlink -f $(which vault))`
