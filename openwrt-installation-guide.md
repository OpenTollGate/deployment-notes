# OpenWrt Installation Guide for Zyxel NR7101

This guide provides a comprehensive overview of how to install OpenWrt on the Zyxel NR7101 outdoor router, based on the information from the OpenWrt wiki.

## Supported Versions

*   **Supported Current Release:** 24.10.5

## Hardware Highlights

*   **CPU:** MediaTek MT7621AT @ 880 MHz
*   **Flash:** 128 MB NAND
*   **RAM:** 256 MB
*   **WLAN:** MediaTek MT7603 (b/g/n)
*   **Ethernet:** 1x 1Gbit port
*   **Modem:** LTE

## Installation

**Warning:** Current prebuilt 23.05.0 images contain a bug and will soft-brick your device. Use SNAPSHOTs, self-compile, or older 23.05-RCs.

### Obtaining the Supervisor Password

Many Zyxel devices have a "supervisor" shell and web account with more power than the normal "admin" user. The default password for this account is calculated from the serial number.

A tool to generate this password can be downloaded from: `https://get.dyn.mork.no/zyxel_pwgen.tar.gz`

Unpack it and run:

```bash
$ zyxel_pwgen/getsupervisor.sh S200Z34000000
3265f4ce
```

The output is the "Old algorithm supervisor password" applicable for the NR7101.

### Installation from Z-Loader (Vendor U-Boot application)

1.  **Halt boot** by pressing `Escape` on the console.
2.  **Set up a TFTP server** to serve the OpenWrt `initramfs-recovery.bin` image at `10.10.10.3`.
3.  Type `ATNR 1,initramfs-recovery.bin` at the `ZLB>` prompt.
4.  Wait for OpenWrt to boot and ssh to `root@192.168.1.1`.
5.  Sysupgrade to the OpenWrt sysupgrade image.

**NOTE:** `ATNR` will write the recovery image to both primary and recovery partitions in one go.

### Booting from RAM

1.  **Halt boot** by pressing `Escape` on the console.
2.  Type `ATGU` at the `ZLB>` prompt to enter the U-Boot menu.
3.  Press `4` to select `4: Entr boot command line interface.`
4.  **Set up a TFTP server** to serve the OpenWrt `initramfs-recovery.bin` image at `10.10.10.3`.
5.  Load it using `tftpboot 0x88000000 initramfs-recovery.bin`.
6.  Boot with `bootm 0x8800017C` to skip the 380 (0x17C) bytes ZyXEL header.

**NOTE:** U-Boot configuration may be incomplete. You may have to configure a working MAC address before running TFTP using `setenv eth0addr <mac>`.

## Specific Configuration

### Network Interfaces

*   **br-lan:** LAN & WiFi (192.168.1.1/24)
*   **lan:** LAN port (bridge member)
*   **wwan0:** 5GNR/LTE modem (QMI)
*   **wlan0:** WiFi (Disabled)

## Hardware

### Serial

A 3.3V TTL UART is located on the populated 5-pin header J5 in the upper left corner of the main PCB.

**Pinout:**

*   `[o]` GND (black)
*   `[ ]` key - no pin
*   `[o]` RX (orange)
*   `[o]` TX (red)
*   `[o]` 3.3V Vcc (brown)

**Serial Connection Parameters:** `57600, 8N1`

## Modem Firmware Upgrade

**WARNING:** Never reboot the NR7101 or remove power while the modem is being upgraded.

The RG502Q-EA in the Zyxel NR7101 can be upgraded from within OpenWrt.

1.  Stop all processes conflicting with `ttyUSBx` device access.
2.  Connect to one of the AT command ports and verify the current firmware version and internet connectivity.
3.  Start the upgrade process by providing the download URL for the firmware diff.

```
at+qfotadl="http://get.dyn.mork.no/nr7101/RG502QEAAAR01A04-R11A03.zip"
```

4.  Wait for the modem to disconnect and reconnect in upgrade mode.
5.  (Optional) Connect to the AT command interface in upgrade mode to watch the progress.
6.  Wait for the modem to disconnect and boot up with the new firmware version.
7.  Connect to the AT command channel to verify the new version.
