# OpenWrt Tips and Tricks

This document contains useful tips for working with OpenWrt on your router.

## Using `wget` with Invalid SSL Certificates

When using `wget` to download files over HTTPS, you may encounter an "Invalid SSL certificate" error. This can happen if the router's system time is incorrect or if it doesn't have the required root certificates to verify the server's identity.

To bypass this check, you can use the `--no-check-certificate` flag.

### Example

```bash
wget --no-check-certificate <URL>
```

For the specific file you were trying to download, the command would be:

```bash
wget --no-check-certificate https://cmbethpcg000e5el0ehhk5933-blossom.eggstr.com/f31ec1bd49f5f937a03d9d59413b914abee8ece1999018353d288640406e70c5
```
