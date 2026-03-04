# Using `zycast` to Flash Zyxel Routers

The `zycast` program is a command-line tool for flashing Zyxel routers that support a multicast-based firmware update protocol. It allows you to push firmware images to the device's bootloader, even if you don't have shell access.

**How it Works**

The `zycast` program sends UDP packets to a specific multicast address (225.0.0.0) on port 5631. The bootloader on the Zyxel device listens for these packets and uses them to reconstruct and flash the firmware image.

The protocol uses a custom header to ensure the integrity and correct order of the packets. It also allows for specifying the image type (e.g., `ras` for the primary firmware, `backup` for the secondary firmware) and other flags.

**How to Use `zycast`**

1.  **Compile the `zycast` program:** You'll need to compile the `zycast.c` file to create an executable. You can do this using a C compiler like `gcc`:
    ```bash
    gcc zycast.c -o zycast
    ```

2.  **Connect your computer to the router:** Connect your computer to the router's LAN port. It is highly recommended to set a static IP address on your computer in the `192.168.1.x` range (e.g., `192.168.1.2` with a subnet mask of `255.255.255.0`).

3.  **Start `zycast` on your computer:** Before powering on the router, start the `zycast` command on your computer. This will start sending the firmware image to the multicast address.

4.  **Power on the router:** While `zycast` is running, power on the router. The bootloader will detect the `zycast` packets and begin the flashing process.

Here's an example of the `zycast` command:
    ```bash
    sudo ./zycast -i enx00e04c683d2d -t 20 -f openwrt-initramfs.bin

    **Note:** `zycast` needs to be run with `sudo` because it binds to a privileged port (5631) and sends packets to a multicast address, which requires root privileges.
    ```
    *   `-i eth0`: Specifies the network interface to use for sending the multicast packets.
    *   `-f openwrt-initramfs.bin`: Specifies the firmware image to flash. You should use the **Factory** image for the initial installation.

**Important Considerations**

*   **Bootloader Mode:** The most critical step is getting the router into the correct bootloader mode. If the router is not listening for `zycast` packets, the command will have no effect.
*   **Image Type:** The `zycast` program allows you to specify the image type using the `-f`, `-b`, `-d`, and `-r` flags. It's crucial to use the correct image type for your device and the firmware you're flashing.
*   **Risk of Bricking:** As with any firmware flashing process, there is a risk of bricking your device. Be sure to use the correct firmware image for your router and follow the instructions carefully.


