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

2.  **Connect your computer to the router:** Connect your computer to the router's LAN port.

3.  **Put the router in bootloader mode:** This is the tricky part. You'll need to interrupt the boot process to get the router to listen for `zycast` packets. The exact method for this can vary, but it often involves holding down a reset button during power-on or sending a specific key sequence over the serial console.

4.  **Run `zycast`:** Once the router is in bootloader mode, you can run the `zycast` command to push the firmware image. Here's an example:
    ```bash
    ./zycast -i eth0 -f openwrt-initramfs.bin
    ```
    *   `-i eth0`: Specifies the network interface to use for sending the multicast packets.
    *   `-f openwrt-initramfs.bin`: Specifies the firmware image to flash.

**Important Considerations**

*   **Bootloader Mode:** The most critical step is getting the router into the correct bootloader mode. If the router is not listening for `zycast` packets, the command will have no effect.
*   **Image Type:** The `zycast` program allows you to specify the image type using the `-f`, `-b`, `-d`, and `-r` flags. It's crucial to use the correct image type for your device and the firmware you're flashing.
*   **Risk of Bricking:** As with any firmware flashing process, there is a risk of bricking your device. Be sure to use the correct firmware image for your router and follow the instructions carefully.
