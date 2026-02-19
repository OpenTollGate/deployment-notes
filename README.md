# Serial/UART Experimentation and TollGate Setup

This repository contains a collection of guides and analysis reports related to setting up and troubleshooting a D-Link COVR-X1860-A1 router with OpenWrt and the TollGate paid WiFi hotspot software.

## Documents

*   **[`serial-guide.md`](serial-guide.md:1)**: A step-by-step guide on how to connect to a router's serial console on an Ubuntu system. It covers finding the serial device, recommended terminal software, and how to interact with the device.

*   **[`dlink_covr-x1860-a1_openwrt_boot_analysis.md`](dlink_covr-x1860-a1_openwrt_boot_analysis.md:1)**: An analysis of the router's boot log after a successful OpenWrt installation. This report confirms the health of the device and explains the key stages of the boot process.

*   **[`openwrt-tips.md`](openwrt-tips.md:1)**: A collection of useful tips for working with OpenWrt, including how to handle common `wget` SSL certificate errors.

*   **[`tollgate-wrt-installation-summary.md`](tollgate-wrt-installation-summary.md:1)**: A detailed, chronological summary of the entire `tollgate-wrt` package installation process. It covers everything from the initial download to troubleshooting dependency issues and the final, successful installation and automatic configuration.

*   **[`tollgate-owner-onboarding.md`](tollgate-owner-onboarding.md:1)**: A comprehensive guide for new owners of a TollGate-enabled router. It explains how to perform the initial setup, including connecting to an upstream internet source, configuring payment settings (like your Lightning Address), and customizing the service. It also includes an advanced troubleshooting section with useful command-line tools.

*   **[`tollgate-status-analysis.md`](tollgate-status-analysis.md:1)**: An explanation of the TollGate service's status log. This document breaks down the meaning of the various log entries, including the Nostr advertisement and payment processing details.
