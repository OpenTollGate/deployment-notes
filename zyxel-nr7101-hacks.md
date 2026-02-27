# Zyxel NR7101 Hacks, Tips, and Tweaks

This document summarizes the most useful information from the Gist "zyxel_nr7101_setup_hacks_tips_and_tweaks.txt".

## Supervisor/Root Password

The supervisor password is the root password, and it should allow for a Linux shell login via SSH. The username is `supervisor`.

## New Password Generation Method (for newer hardware/firmware)

If the `zyxel_pwgen` tool doesn't work, there is an alternative method for obtaining the root password:

1.  **Set up FTP** via the web GUI.
2.  **Access FTP as the `admin` user.**
3.  **Download the `zcfg_config.json` file.**
4.  **Copy the encrypted password** under the `root` user.
5.  **Use the DynamicDNS password field as a decryption oracle:**
    *   Set a fake DDNS in the web GUI.
    *   Download the configuration backup file.
    *   Replace the encrypted password under `DynamicDNS` with the encrypted root password.
    *   Save and restore the configuration file.
    *   Go to the DDNS settings in the web GUI and read the plaintext password.

## SSH Access

You can log in via SSH as `supervisor@the.router.ip.address`.
