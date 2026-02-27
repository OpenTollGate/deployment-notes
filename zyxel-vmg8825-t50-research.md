# Zyxel VMG8825-T50 Hacking Research

This document summarizes the findings from the blog post "Getting root on a Zyxel VMG8825-T50 router" and how they might apply to our Zyxel NR7101.

## Key Findings

*   **The `_encrypt_` Oracle:** The DDNS password field can be used as an encryption and decryption oracle for the `_encrypt_` strings in the configuration backup file. This allows for manipulation of encrypted configuration values.
*   **The `SPTrustDomain` Bypass:** Adding a local subnet to the `SPTrustDomain` in the configuration backup file can bypass privilege checks for services like telnet and SSH.
*   **The `zysh` Escape:** The command `traceroute "a||sh"` can be used to escape the restricted `zysh` shell and get a regular shell.
*   **The `/data/zcfg_config.json` file:** A more complete configuration file exists at this location, which may contain unencrypted passwords or other sensitive information.
*   **The `mtd` command:** The `mtd` command can be used to read from the bootloader flash, which may contain the supervisor password.

## Potential Application to NR7101

While the blog post is for a different model, the underlying software and hardware are likely similar. We can try to apply these techniques to our NR7101:

1.  **Use the `_encrypt_` oracle** to manipulate the configuration file.
2.  **Add our local subnet to the `SPTrustDomain`** to try and get a telnet or SSH shell.
3.  **If we get a `zysh` shell, try the `traceroute` escape.**
4.  **If we get a root shell, look for the `/data/zcfg_config.json` file** and use the `mtd` command to dump the bootloader flash.
