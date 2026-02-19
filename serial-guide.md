# Connecting to a Serial Console on Ubuntu

This guide explains how to find, connect to, and interact with a serial device, such as a WiFi router, on an Ubuntu system.

## Finding the Serial Device

When you connect a USB-to-serial adapter to your computer, it will be assigned a device file in the `/dev` directory. The most common names for these devices are:

*   `/dev/ttyUSB0`, `/dev/ttyUSB1`, etc.
*   `/dev/ttyACM0`, `/dev/ttyACM1`, etc.

To find the correct device, you can use the `dmesg` command. Open a terminal and run the following command right after plugging in your device:

```bash
dmesg | tail
```

This will show you the most recent kernel messages, and you should see a message indicating the device name that was assigned to your USB-to-serial adapter.

Another useful command is `ls -l /dev/ttyUSB*` or `ls -l /dev/ttyACM*` to see the devices that are present.

## Recommended Serial Terminal Software

There are several serial terminal applications available for Ubuntu. Here are a few popular ones:

*   **minicom**: A classic, text-based serial communication program. It's powerful but can be a bit tricky to configure for the first time.
*   **picocom**: A minimal and easy-to-use terminal program.
*   **screen**: A full-screen window manager that can also be used for serial communication.
*   **tio**: A simple and modern serial device I/O tool.

For this guide, we will use `tio` as it is simple and effective. You can install it with the following command:

```bash
sudo apt-get update
sudo apt-get install tio
```

## Identifying the Correct Baud Rate

The baud rate is the speed at which data is transmitted over the serial connection. It is crucial to set the correct baud rate to get readable output. If you see garbled text or no output at all, you likely have the wrong baud rate.

Common baud rates include:

*   9600
*   19200
*   38400
*   57600
*   115200

For most modern routers and embedded devices, **115200** is the standard baud rate.

If you are unsure, check the documentation for your device. If you can't find it, you can try each of the common baud rates until you see readable text.

## Interacting with the Device

Once you have identified the device name (e.g., `/dev/ttyUSB0`) and installed a serial terminal program, you can connect to the device.

The most common baud rate for routers is 115200. You will need to specify the device and the baud rate to connect.

With `tio`, the command to connect is:

```bash
tio /dev/ttyUSB0 -b 115200
```

Replace `/dev/ttyUSB0` with the actual device name you found earlier.

Once connected, you should see the boot output of your router when you power it on. You can also type commands into the terminal to interact with the router's console.

To exit `tio`, press `Ctrl+t` then `q`.
