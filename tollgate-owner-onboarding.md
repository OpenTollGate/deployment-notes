# TollGate Router Onboarding Guide

Welcome to your new TollGate router! This guide will walk you through the initial setup and configuration to get your paid WiFi hotspot up and running.

## 1. Connect to an Upstream WiFi Network

Your TollGate router needs to connect to an existing WiFi network to get internet access. You will do this through the LuCI web interface, the standard web-based management tool for OpenWrt.

1.  **Connect to the Router**: Connect your computer to the router's LAN port or to the main WiFi network it broadcasts (the one that is not the private/paid network).
2.  **Open the Web Interface**: The TollGate captive portal runs on the standard web port (80), so the LuCI web interface has been moved to port **8080**. Open a web browser and navigate to `http://<router_ip>:8080`, replacing `<router_ip>` with the router's IP address. The IP address was randomly set during installation. You can find it by checking your computer's network settings (look for the "gateway" or "router" address). In the previous session, it was set to `172.17.154.1`, but it may have changed.
3.  **Log In and Set a Password**: Log in to LuCI. There is no password set by default, so you can just click "Login". It is **highly recommended** that you set a strong root password immediately. You can do this by going to **System > Administration**.
4.  **Navigate to Wireless Settings**: Go to **Network > Wireless**.
5.  **Scan for Networks**: Find the wireless interface that is in "Client" mode (it should be named something like `phy0-sta0` or similar) and click the **Scan** button.
6.  **Join a Network**: Select the upstream WiFi network you want to connect to from the list and click **Join Network**.
7.  **Enter Password**: Enter the password for the upstream WiFi network and click **Submit**.
8.  **Save and Apply**: Click **Save & Apply**. The router will now connect to the internet.

## 2. Configure Your TollGate Service

The core of your TollGate service is configured through two main files: `/etc/tollgate/config.json` and `/etc/tollgate/identities.json`. You will need to connect to the router's command line via SSH to edit these files.

### A. Set Your Lightning Address

To receive your share of the revenue, you must set your own Lightning Address (LNURL).

1.  **Edit `identities.json`**: Open the `/etc/tollgate/identities.json` file.
2.  **Find the Owner**: Locate the `owner` identity.
3.  **Set Your Address**: Replace the default `lightning_address` with your own.

**Example `identities.json`:**
```json
{
  "config_version": "v0.0.1",
  "owned_identities": [
    {
      "name": "merchant",
      "privatekey": "a966bcd16e62ae85e1652a55369554efad04ead2542c9020e1f28068b861a439"
    }
  ],
  "public_identities": [
    {
      "name": "developer",
      "lightning_address": "tollgate@minibits.cash"
    },
    {
      "name": "trusted_maintainer_1",
      "pubkey": "5075e61f0b048148b60105c1dd72bbeae1957336ae5824087e52efa374f8416a"
    },
    {
      "name": "owner",
      "pubkey": "[on_setup]",
      "lightning_address": "YOUR_LN_ADDRESS_HERE@yourprovider.com"
    }
  ]
}
```

### B. Customize Your Service

You can customize the pricing, accepted payment methods (mints), and profit sharing in the `/etc/tollgate/config.json` file.

1.  **Select Trusted Mints**: The `accepted_mints` array lists the Cashu mints that your customers can use to pay. You should only include mints that you trust. You can add or remove mints from this list. Each mint has a `min_balance` setting.

    *   **`min_balance`**: This is the amount of sats that will be kept on the router for each mint, even when payouts are made. This is a crucial feature that ensures your router always has enough funds to pay for its own internet connection if it needs to connect to an upstream TollGate. The default is 64 sats.

2.  **Set Your Price**: The `price_per_step` and `step_size` fields determine the cost of internet access. In the default configuration, the price is `1` satoshi for `22020096` bytes (approximately 21 MiB) of data.

3.  **Adjust the Profit Share**: The `profit_share` array determines how the proffit is split. By default, the owner receives 79% (`0.79`) and the maintainers receive 21% (`0.21`). You can adjust these values. If you want to keep 100% of the revenue, you can set the maintainers factor to `0` and the owner's to `1.0`.

**Example `config.json` snippet:**
```json
  "accepted_mints": [
    {
      "url": "https://mint.coinos.io",
      "min_balance": 64
    }
  ],
  "profit_share": [
    {
      "factor": 1.0,
      "identity": "owner"
    },
    {
      "factor": 0.0,
      "identity": "developer"
    }
  ],
  "step_size": 22020096,
  "price_per_step": 1,
```

## 3. Restart the Service

After making any changes to the configuration files, you must restart the `tollgate-wrt` service for the changes to take effect.

Run the following command in the router's SSH session:

```bash
service tollgate-wrt restart
```

Your TollGate router is now fully configured and ready to start selling internet access!

## 4. Troubleshooting

### No Internet Connection

If your TollGate router does not have an internet connection after setting up the upstream WiFi client, please check the following:

*   **Single Upstream Connection**: Your router needs **at least one** active upstream internet connection. This can be either a wireless client connection (STA mode) as described above, or a wired connection to the router's WAN port.

*   **Avoid Multiple STA Interfaces on the Same Radio**: OpenWrt can have issues when more than one wireless client (STA) interface is configured on the same physical radio (e.g., `radio0`). Even if one of the STA interfaces is not currently in use, its presence in the configuration can prevent the router from correctly using the active one.

    **Solution**: If you have tried to connect to multiple upstream WiFi networks, you may have old, unused STA interfaces in your configuration. You should delete these old interfaces in the LuCI web interface (**Network > Wireless**). Ensure that you only have **one** active STA interface per radio.

### Advanced Troubleshooting with Commands

You can get more detailed information about the state of your router and the TollGate service by running commands in an SSH session.

#### Finding the Router's IP Address and Connecting via SSH

To run these commands, you first need to connect to the router's command line interface using SSH (Secure Shell).

1.  **Find the Router's IP Address**: If you don't know the router's IP address, you can find it by running the `ifconfig` command in the router's serial console (if you have one connected) and looking for the `br-lan` interface. The IP address will be listed next to `inet addr`.

    Alternatively, if your computer is connected to the router's LAN, you can find the router's IP address in your computer's network settings. It will be listed as the "gateway" or "router".

2.  **Connect with SSH**: Once you have the IP address, you can connect to the router from your computer's terminal using the following command. Replace `<router_ip>` with the actual IP address.

    ```bash
    ssh root@<router_ip>
    ```

    If you have set a password in LuCI, you will be prompted to enter it.

#### Checking Internet Connectivity

To quickly check if the router itself has a working internet connection, use the `ping` command. This sends a small data packet to a public server to see if it responds.

```bash
root@OpenWrt:~# ping 9.9.9.9
PING 9.9.9.9 (9.9.9.9): 56 data bytes
64 bytes from 9.9.9.9: seq=0 ttl=52 time=33.512 ms
64 bytes from 9.9.9.9: seq=1 ttl=52 time=33.136 ms
```
If you see replies like the ones above, your router's internet connection is working correctly.

#### Checking the TollGate Service Log

The TollGate service writes detailed logs about its activities. This is the best place to look if something is not working as expected. You can view these logs with the `logread` command.

To see only the logs related to TollGate, use this command:
```bash
logread | grep "tollgate"
```

To see the most recent log entries, which is often the most useful, add `| tail` to the end:
```bash
root@OpenWrt:~# logread | grep "tollgate" | tail
Thu Feb 19 15:18:11 2026 daemon.err tollgate-wrt[4161]: 2026/02/19 15:18:11 Skipping payout https://mint.coinos.io, Balance 0 does not meet threshold of 128
Thu Feb 19 15:19:11 2026 daemon.err tollgate-wrt[4161]: WARN[2026-02-19T15:19:11Z] Ping failed                                   consecutive_failures=2 module=wireless_gateway_manager
```
*   **Interpreting the Logs**: The logs will show you information about payouts, client connections, and potential errors. For example, the "Skipping payout" message is normal if your balance hasn't reached the payout threshold.
*   **"Ping failed" Warning**: You may see a "Ping failed" warning in the logs. This is a deprecated check and can be safely ignored.

*   **Example Log Outputs**: Here are some common log entries and what they mean:

    *   **Receiving Payments**: When a customer pays for internet access, you will see a series of log entries like this:

        ```bash
        Thu Feb 19 16:08:24 2026 daemon.err tollgate-wrt[4243]: INFO[2026-02-19T16:08:24Z] Received handleRootPost request               method=POST module=main remote_addr="172.17.154.106:36208"
        Thu Feb 19 16:08:26 2026 daemon.err tollgate-wrt[4243]: 2026/02/19 16:08:26 TollWallet.Receive: Successfully received 65 sats
        Thu Feb 19 16:08:26 2026 daemon.err tollgate-wrt[4243]: INFO[2026-02-19T16:08:26Z] Authorization successful for MAC              mac_address="36:67:93:d6:c2:00" module=valve output="Client 36:67:93:d6:c2:00 authenticated.\n"
        ```
        This shows a payment of **65 sats** being received and the client with the MAC address `36:67:93:d6:c2:00` being granted internet access.

    *   **Client Data Usage**: When a client is connected and using the internet, you will see log entries like this, showing their data consumption in real-time.

        ```bash
        Thu Feb 19 16:09:30 2026 daemon.err tollgate-wrt[4243]: 2026/02/19 16:09:30 Data usage for 36:67:93:d6:c2:00: 51.9 MB / 1.3 GB (3.8%)
        ```

    *   **Payout Checks**: The service periodically checks the balance for each configured mint to see if it has reached the minimum payout amount. The default payout threshold is **128 sats**. The service will keep a reserve of **64 sats** on the router for its own operational needs (like buying internet from an upstream TollGate).

        ```bash
        Thu Feb 19 16:08:58 2026 daemon.err tollgate-wrt[4243]: 2026/02/19 16:08:58 Skipping payout https://mint.minibits.cash/Bitcoin, Balance 65 does not meet threshold of 128
        ```
        In this example, the payout for `mint.minibits.cash/Bitcoin` is skipped because the balance of 65 sats has not yet reached the 128 sat threshold.

### Using the TollGate Command-Line Interface (CLI)

The TollGate service also includes a command-line tool for managing the service directly. You can access it by running `tollgate` in the SSH session.

```bash
root@OpenWrt:~# tollgate
TollGate CLI provides command-line access to your running TollGate service.

Usage:
  tollgate [command]

Available Commands:
  wallet      Wallet operations
  ...
```

This tool is especially useful for managing your wallet.

#### Checking Your Wallet Balance

```bash
root@OpenWrt:~# tollgate wallet balance
Total wallet balance: 85 sats
balance_sats: 85
```

#### Draining Your Wallet

If you want to manually withdraw all the funds from your router's wallet, you can use the `drain` command. This will display an e-cash note on your terminal screen. Make sure you copy the e-cash straight away, because the router no longer has a copy of it:

```bash
root@OpenWrt:~# tollgate wallet drain
```

#### Restarting the Service After Configuration Changes

**Important**: Any time you modify the `/etc/tollgate/config.json` or `/etc/tollgate/identities.json` files, you **must** restart the TollGate service for the changes to be applied.

You can do this with the following commands:
```bash
service tollgate-wrt stop
service tollgate-wrt start
```
Or, more simply:
```bash
service tollgate-wrt restart
```
After restarting, you can check the logs again to see the service re-initializing with your new settings.