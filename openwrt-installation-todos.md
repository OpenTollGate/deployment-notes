[ ] Enable the DLNA server (if necessary)
[ ] Create a symlink to `/data/zcfg_config.json` on a USB drive
[ ] Download `zcfg_config.json` using a DLNA client
[ ] Decrypt the root password using the `_encrypt_` oracle
[ ] Log in via SSH with the decrypted root password
[ ] Flash OpenWrt from the OEM shell


You're asking for clarification on the steps involving the USB drive, symlink, and DLNA/SMB access. That's a good question, as it's a bit of a workaround.

Let's break down how these steps work, drawing from the `zyxel-vmg8825-t50-research.md` file:

**The Goal:** Our primary goal is to get the `zcfg_config.json` file from the router. This file is crucial because it contains the encrypted root password, which we need to decrypt to gain SSH access.

**The Problem:** We can't directly access the router's filesystem because we don't have a shell (SSH or serial console access). We also can't access the web GUI to enable features or download configuration files easily.

**The Solution: Leveraging the Router's Features (DLNA/SMB and Symlinks)**

The blog post for the VMG8825-T50 (which shares similarities with your NR7101) revealed a clever workaround that exploits how the router handles USB drives and file sharing services like DLNA (Digital Living Network Alliance) and SMB (Server Message Block).

Here's how each step contributes:

1.  **Prepare a USB drive with a supported filesystem:**
    *   **Why:** The router has USB ports and can read from USB drives. It needs a filesystem it understands (FAT32, NTFS, or ext2 are common).
    *   **How:** You'll format a USB drive on your computer to one of these filesystems.

2.  **Create a symlink to `/data/zcfg_config.json` on the USB drive:**
    *   **Why:** A symlink (symbolic link) is like a shortcut. When the router reads the USB drive, it will see this symlink. The trick is that the router's DLNA/SMB server, which often runs with root privileges, will "follow" this symlink. This means that when you try to access the symlink from your computer, the router's server will actually serve you the content of the file the symlink points to, even if that file is located deep within the router's internal filesystem and normally inaccessible.
    *   **`/data/zcfg_config.json`:** This is the specific file we want because the blog post indicated it contains the full configuration, including the encrypted root password.
    *   **How:** On your computer (Linux), you'd use a command like `ln -s /data/zcfg_config.json /path/to/your/usb/drive/config.json.wav`. The `.wav` extension is important because the DLNA server often filters for media file extensions.

3.  **Attach the USB drive to the router:**
    *   **Why:** This makes the symlink available to the router's internal file-sharing services.
    *   **How:** Physically plug the prepared USB drive into one of the router's USB ports.

4.  **Access the USB drive via SMB:**
    *   **Why:** The router has an SMB server (Windows File Sharing) that allows you to access files on attached USB drives from your computer. This is our way of "downloading" the file that the symlink points to.
    *   **How:** From your computer, you would typically open a file explorer and try to connect to a network share, usually something like `\\192.168.1.1\usb` or `\\172.17.1.1\usb`. You might need to use the `admin` username and a default password (or the supervisor password if it works for SMB).

5.  **Download `zcfg_config.json`:**
    *   **Why:** Once you've accessed the USB drive via SMB, you'll see your `config.json.wav` file (or whatever you named it). When you download this file, the router's SMB server will follow the symlink and give you the actual content of `/data/zcfg_config.json`.
    *   **How:** Simply copy the `config.json.wav` file from the network share to your computer.

6.  **Decrypt the root password using the `_encrypt_` oracle:**
    *   **Why:** The `zcfg_config.json` file will contain the root password, but it will be encrypted (e.g., `_encrypt_DTW25ZshjOAAULO3MIcjsi6ysrA793bqPDcDg7KCLiM=`). The blog post discovered a "decryption oracle" using the DDNS password field in the web GUI.
    *   **How:**
        *   You'll need to find a way to access the router's web GUI (even if it's just the login page).
        *   You'll take the encrypted root password from the `zcfg_config.json` file.
        *   You'll then edit a *backup* of the router's configuration (obtained from the web GUI's backup/restore feature) and replace the encrypted DDNS password with the encrypted root password.
        *   Restore this modified backup to the router.
        *   Go to the DDNS settings in the web GUI, and the router will display the *decrypted* root password in plain text.

7.  **Log in via SSH with the decrypted root password:**
    *   **Why:** Once you have the plaintext root password, you can use it to log in via SSH.
    *   **How:** `ssh root@<router_ip_address>`

8.  **Flash OpenWrt from the OEM shell:**
    *   **Why:** With root SSH access, you'll have full control over the router and can proceed with flashing OpenWrt.
    *   **How:** This will involve using commands like `mtd` or other specific tools available on the router's shell to write the OpenWrt firmware to the flash memory.

This is a multi-step process that relies on several assumptions (like the DLNA server being active and the SMB share being accessible). We'll tackle these steps one by one.

Does this explanation clarify the process for you?


I don't have a USB port though...


My apologies! I completely missed that crucial detail. The OpenWrt wiki page for the NR7101 clearly states "USB: none". This means the entire USB-based approach is not viable for your specific router.

This significantly changes our strategy. Since we can't use the USB drive for the symlink trick, we need to find another way to get the `zcfg_config.json` file or gain access to the router.

Let's go back to the drawing board with the information we have.

Here's what we know:

*   We have serial access, but can't interrupt the boot process to get to U-Boot.
*   We have the supervisor password, but it doesn't work for serial login, and we can't access the web GUI.
*   The router is booting up to a functional state, but we can't log in.
*   The `_encrypt_` oracle method is still theoretically sound, but we need a way to get the `zcfg_config.json` file and then access the web GUI to use the oracle.

Given these constraints, our options are limited. We need to find a way to either:

1.  **Interrupt the boot process:** This is still the most direct path to flashing OpenWrt. We need to revisit the "Advanced Boot Interruption Techniques" from `zyxel-nr7101-boot-analysis.md` and the OpenWrt wiki.
2.  **Access the web GUI:** If we can get into the web GUI, we can try to enable SSH or FTP, or use the configuration backup/restore feature to exploit the `_encrypt_` oracle.
3.  **Find a new vulnerability:** This is the hardest option, but if all else fails, we might need to look for a new exploit.

Let's focus on **interrupting the boot process** again, as it's the most fundamental step for flashing OpenWrt. The OpenWrt wiki and the Gist mentioned some very specific timing and key combinations.

I will update the todo list to reflect this renewed focus.