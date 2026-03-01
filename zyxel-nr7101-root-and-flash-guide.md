# Zyxel NR7101 Root and OpenWrt Flash Guide

This guide summarizes the steps to gain root access to your Zyxel NR7101 and flash it with OpenWrt, based on the information from the OpenWrt forum.

**1. Gaining Initial Access (Admin Login)**

The first step is to get the `admin` password. The forum post suggests two methods:

*   **WiFi Password:** The `admin` password is often the same as the WiFi password. If WiFi is not enabled, you can press the WiFi button for 5 seconds to turn it on. Then, connect to the WiFi network and use the WiFi password as the `admin` password for the serial console.
*   **WPS Button:** If the router has a WPS button, you can use it to connect to the WiFi network without a password. Once connected, you can find the WiFi password in your computer's network settings.

**2. Getting the Supervisor Password**

Once you have `admin` access to the serial console, you can get the supervisor password:

1.  **Log in as `admin`** on the serial console.
2.  **Check the open ports** using the command `zycli mgmtsrvctl show`.
3.  **Enable FTP, SSH, and HTTP** using the following commands:
    ```
    zycli mgmtsrvctl config -s SSH 0
    zycli mgmtsrvctl config -s FTP 0
    zycli mgmtsrvctl config -s HTTP 0
    ```
4.  **Connect to the router via FTP** and download the `zcfg_config.json` file.
5.  **Find the encrypted supervisor password** in the `zcfg_config.json` file. It will look something like this:
    ```json
    "Username":"supervisor",
    "Password":"_encrypt_yLIaQfrt35LUnwy4Tp80g==",
    ```
6.  **Decrypt the password using the DynDNS oracle:**
    *   Log in to the web interface (which you can now access because you enabled HTTP).
    *   Go to the DynDNS settings.
    *   Paste the encrypted supervisor password into the password field and apply the settings.
    *   Click the "show password" button to reveal the decrypted supervisor password.

**3. Flashing OpenWrt**

Now that you have the supervisor password (which is also the root password), you can flash OpenWrt:

1.  **Log in as `supervisor` or `root`** via SSH.
2.  **Follow the OpenWrt installation guide** for the Zyxel NR7101, which we have already documented in `openwrt-installation-guide.md`. This will involve using `tftpboot` to load the OpenWrt initramfs image and then flashing the full sysupgrade image.

**Future Access**

Once you have OpenWrt installed, you will be able to access the router via SSH and the LuCI web interface using the default OpenWrt credentials (username `root`, no password). You can then set a new password and configure the router as you wish.
