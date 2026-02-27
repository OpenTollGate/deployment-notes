# Zyxel NR7101 Boot Analysis

## Connection Details

*   **Device:** `/dev/ttyUSB0`
*   **Baud Rate:** `57600` (for OS), `115200` (for Bootloader)

## Initial Observations

The router appears to be in a boot loop. The serial console output shows the device repeatedly restarting. The following message is a strong indicator of a watchdog timer reset:

```
***********************
Watchdog Reset Occurred
***********************
```

This suggests that the operating system is failing to load correctly, and the watchdog timer is rebooting the device.

## Boot Log Analysis

The boot log shows several interesting points:

*   **U-Boot:** The device successfully loads the U-Boot bootloader.
*   **Kernel:** The kernel starts to load, but it seems to encounter errors.
*   **CRC Error:** The following error message is present in the log:
    ```
    warning! crc error in section Factory: expect 0x6e909c7c, got 0xffffffff!
    ```
    This indicates that the "Factory" partition, which likely contains device-specific calibration data, is corrupt. This is a likely cause of the boot failure.
*   **Watchdog:** The watchdog timer is what is causing the device to reboot.

## Next Steps

To recover the device, we will likely need to interrupt the boot process to get to the U-Boot command line. From there, we can attempt to flash a new firmware image.

### Interrupting the Boot Process

To interrupt the boot process and access the U-Boot prompt, you typically need to send a specific key sequence during the initial boot phase. Based on the boot log, the message "Please press Enter to activate this console" suggests that pressing the **Enter** key repeatedly right after powering on the router is the most likely way to interrupt the boot process. If that doesn't work, common alternatives include **Ctrl+C** or **Ctrl+B**.

Since these attempts were unsuccessful, we need to investigate further. It's possible the timing is very precise, or there's an alternative method for this specific device. Here are some additional methods to try for the Zyxel NR7101:

*   **The "Escape" Method (OpenWrt Recommendation):** According to OpenWrt documentation, the correct key to halt the boot process for this model is often **Escape (Esc)**. Press `Esc` repeatedly as soon as the first line of text appears until you see a prompt like `ZLB>` or `MT7621 #`.

*   **The "ATGU" Sequence (Bypassing ZHAL Lock):** Some Zyxel models require a two-step sequence to unlock the true U-Boot prompt:
    1.  **Power cycle the router.**
    2.  **Press `Enter` repeatedly** when you see the "Multiboot Listening..." prompt in the serial console. This should get you into the ZHAL console.
    3.  Once in the ZHAL console (you might see a prompt like `ZLB>`), type `atgu` and press `Enter`.

*   **Hardware Trigger (Web Recovery Mode):** If serial input is blocked, you can try to force the device into Web Recovery Mode:
    1.  Hold down the `Reset` button (or `WPS` button, if available) during power-on for approximately 3-5 seconds.
    2.  The device will then often start a minimalist web server at `192.168.1.1`, through which you can directly address firmware partitions.

*   **Check Terminal Settings:** Ensure that your terminal (tio) is not suppressing signals. In some cases, it helps to explicitly set the Hardware Flow Control (CRTSCTS) to `OFF` in a tool like minicom or PuTTY, as this can prevent input if the pins on the UART adapter are not fully occupied.

### Troubleshooting No Output at 115200 Baud

If you're not getting any output at 115200 baud, let's try these steps:

1.  **Verify Serial Connection:** Ensure the serial cable is securely connected to both the router and your computer.
2.  **Try `screen`:** Use `screen` as an alternative serial terminal. It can sometimes handle connections better than `tio`.

    ```bash
    sudo screen /dev/ttyUSB0 115200
    ```

    To exit `screen`, press `Ctrl+a` then `k`, and confirm with `y`.

After trying `screen`, please let me know if you get any output at 115200 baud.

### Trying `minicom`

If `screen` also doesn't provide output, let's try `minicom`. It's a highly configurable serial terminal that might offer more control.

1.  **Install `minicom`:**
    ```bash
    sudo apt-get update
    sudo apt-get install minicom
    ```
2.  **Configure and Run `minicom`:**
    ```bash
    sudo minicom -s
    ```
    In the setup menu:
    *   Navigate to "Serial port setup".
    *   Set "Serial Device" to `/dev/ttyUSB0` (or the correct device).
    *   Set "Bps/Par/Bits" to `115200 8N1`.
    *   Ensure "Hardware Flow Control" is `No`.
    *   Ensure "Software Flow Control" is `No`.
    *   Save the setup as `dfl` (default) or a specific name (by navigating to "Save setup as dfl" and pressing Enter).
    *   Exit the setup (by navigating to "Exit" and pressing Enter) and `minicom` will start.

    To exit `minicom`, press `Ctrl+a` then `x`.

If you're still not getting output after configuring `minicom` through the setup menu, let's try running `minicom` directly with the parameters:

```bash
sudo minicom -D /dev/ttyUSB0 -b 115200
```

After trying this command, please let me know if you get any output.

### Advanced Boot Interruption Techniques

It seems that standard key combinations and baud rates are not consistently working. Let's try some more advanced techniques specific to Zyxel devices with Mediatek/Ralink chipsets:

#### The "Dauerfeuer" (Continuous Pressing) Trick for the Prompt

Once the RAM check lines are over and `U-Boot 1.1.3` appears, you only have fractions of a second to interrupt. The standard countdown seems to be ignored. There's a special trick for these Mediatek/Ralink-based Zyxel boards:

1.  **Power cycle the device.**
2.  As soon as text appears in the terminal, **hammer on the `4` and `Enter` keys alternately and continuously.**
    *   For many NR7101 models, pressing `4` interrupts the autoboot and opens the "Operations Menu".
    *   If `4` doesn't work, try `f` or `Esc` with the same continuous pressing method.

**What we want to achieve:** If successful, a menu like this should appear:

```
Please choose the operation:
   1: Load system code to SDRAM via TFTP.
   2: Load system code then write to Flash via TFTP.
   3: Boot system code via Flash (default).
   4: Entr boot command line interface.
   7: Load Boot Loader code then write to Flash via Serial.
   9: Load System code then write to Flash via Serial.
```

If you reach this menu, choose `4` to enter the Command Line Interface (CLI).

#### Entering U-Boot CLI and Bypassing Password

If you land in the CLI (you might see a prompt like `MT7621 #` or `MT7986 >`), you can try to bypass the password:

1.  Type `printenv` (to see the current settings).
2.  Look for the `bootargs` line (usually looks like: `console=ttyS0,57600...`).
3.  Type: `setenv bootargs $(bootargs) init=/bin/sh`
4.  Type: `boot`

This should boot the device directly into a root shell without asking for a password.

#### Web-Recovery Mode (Alternative to U-Boot CLI)

The reset button alone does not directly lead to the U-Boot terminal. However, for many Mediatek-based devices (like your MT7621), there's a Web-Recovery Mode that can be triggered with hardware buttons:

1.  **Hold down the `Reset` button** (or `WPS` button, if available) **while powering on the device.**
2.  Continue holding for approximately 3-5 seconds after power-on.
3.  **Access:** Set your PC's IP address statically to `192.168.1.2`. Then, try to access `192.168.1.1` in your browser. A minimalist interface for flashing partitions often appears.

#### Supervisor Login

If the `root` user doesn't exist, the system is likely fixed on the `admin` user. The password is either `1234` or a supervisor password generated from the serial number. You can find tools to calculate this password (based on the S/N) in the OpenWrt Wiki for the NR7101 under "Obtaining the supervisor password."

Further links:

*   [Zyxel NR7101 OpenWrt Wiki](https://openwrt.org/toh/zyxel/nr7101)
*   [Hack GPON - Zyxel U-Boot Unlock Guide](https://gpon.wtf/zyxel-nr7101-uboot-unlock-guide)
