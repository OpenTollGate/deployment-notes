# TFTP Server Setup Guide for Linux

This guide will walk you through setting up a TFTP server on a Debian-based Linux distribution (like Ubuntu) to flash firmware to your router.

## 1. Install the TFTP Server

First, you need to install the `tftpd-hpa` package. Open a new terminal on your computer and run the following command:

```bash
sudo apt-get update
sudo apt-get install tftpd-hpa
```

## 2. Configure the TFTP Server

Next, you need to configure the TFTP server. The configuration file is located at `/etc/default/tftpd-hpa`.

1.  **Open the configuration file** in a text editor with root privileges:
    ```bash
    sudo nano /etc/default/tftpd-hpa
    ```

2.  **Modify the file** to look like this:
    ```
    # /etc/default/tftpd-hpa

    TFTP_USERNAME="tftp"
    TFTP_DIRECTORY="/srv/tftp"
    TFTP_ADDRESS=":69"
    TFTP_OPTIONS="--secure --create"
    ```
    This configuration tells the TFTP server to run as the `tftp` user, use the `/srv/tftp` directory as its root, listen on all interfaces on port 69, and allow the creation of new files.

3.  **Save and close the file.** (In `nano`, press `Ctrl+X`, then `Y`, then `Enter`).

## 3. Create the TFTP Directory and Set Permissions

Now, create the directory you specified in the configuration file and set the correct permissions:

```bash
sudo mkdir -p /srv/tftp
sudo chown -R tftp:tftp /srv/tftp
sudo chmod -R 777 /srv/tftp
```

## 4. Restart the TFTP Server

To apply the new configuration, restart the TFTP server:

```bash
sudo systemctl restart tftpd-hpa
```

## 5. Place the Firmware in the TFTP Directory

Finally, copy the firmware file you want to flash into the TFTP server's root directory and rename it to `factory.bin`:

```bash
cp ~/Downloads/openwrt-24.10.5-ramips-mt7621-dlink_covr-x1860-a1-squashfs-factory.bin /srv/tftp/factory.bin
```

## 6. Verify the Setup

Your TFTP server is now ready. You can proceed with the flashing instructions in the U-Boot section of the main guide.

## 7. Summary of What Worked

After some trial and error, the successful recovery process was as follows:

1.  **Entered U-Boot:** The router's boot process was interrupted to get to the U-Boot command line (`=>`).
2.  **Used `mtkautoboot`:** The `mtkautoboot` command was used to access the interactive boot menu.
3.  **Selected Firmware Upgrade:** The "Upgrade firmware" option was chosen from the menu.
4.  **Used TFTP:** The TFTP client was selected as the transfer method.
5.  **Used `recovery.bin`:** The `openwrt-...-recovery.bin` image was the correct file to use for flashing from the U-Boot menu on this device. The `factory.bin` image, while transferred successfully, was not in a bootable format for this specific U-Boot version.
6.  **Set Correct IPs:** The router's IP was set to `192.168.1.1` and the TFTP server's IP was set to `192.168.1.2`.

This process successfully flashed the router, and it is now working correctly.
