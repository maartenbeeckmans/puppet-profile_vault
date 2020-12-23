# Vault

## Manual steps for setting up vault

### First vault server

Initialize vault

```bash
$ vault operator init
```

Unseal vault

```bash
# 3 times
$ vault operator unseal
```

### Other vault servers

Vault only has to be unsealed

```bash
# 3 times
$ vault operator unseal
```
