# TollGate Router Onboarding Guide

Welcome to your new TollGate router! This guide will walk you through the initial setup and configuration to get your paid WiFi hotspot up and running.

## 1. Connect to an Upstream WiFi Network

Your TollGate router needs to connect to an existing WiFi network to get internet access. You will do this through the LuCI web interface, the standard web-based management tool for OpenWrt.

1.  **Connect to the Router**: Connect your computer to the router's LAN port or to the main WiFi network it broadcasts (the one that is not the private/paid network).
2.  **Open the Web Interface**: Open a web browser and navigate to the router's IP address. The IP address was randomly set during installation. You can find it by checking your computer's network settings (look for the "gateway" or "router" address). In the previous session, it was set to `172.17.154.1`, but it may have changed.
3.  **Log In**: Log in to LuCI. There is no password set by default, so you can just click "Login".
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

1.  **Select Trusted Mints**: The `accepted_mints` array lists the Cashu mints that your customers can use to pay. You should only include mints that you trust. You can add or remove mints from this list.

2.  **Set Your Price**: The `price_per_step` and `step_size` fields determine the cost of internet access. In the default configuration, the price is `1` satoshi for `22020096` bytes (approximately 21 MiB) of data.

3.  **Adjust the Profit Share**: The `profit_share` array determines how the revenue is split. By default, the owner receives 79% (`0.79`) and the developer receives 21% (`0.21`). You can adjust these values. If you want to keep 100% of the revenue, you can set the developer's factor to `0` and the owner's to `1.0`.

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