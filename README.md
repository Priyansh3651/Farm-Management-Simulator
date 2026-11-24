# 🌱 IoT Soil Moisture Bridge for Roblox Farm Management

A hardware-to-game integration project that reads real-time soil moisture levels using an **ESP32 (Arduino framework)** and sends the data into a **Roblox farm management game** to dynamically control in-game crop growth, watering alerts, and hydration stats.

---

## 📋 Table of Contents
- [Overview](#-overview)
- [Hardware Requirements](#-hardware-requirements)
- [Wiring Diagram](#-wiring-diagram)
- [Architecture](#-architecture)
- [Setup & Installation](#-setup--installation)
  - [1. ESP32 Firmware](#1-esp32-firmware)
  - [2. Local Relay Server](#2-local-relay-server)
  - [3. Roblox Studio Integration](#3-roblox-studio-integration)
- [Calibration](#-calibration)
- [License](#-license)

---

## 🌟 Overview
This project bridges physical gardening with virtual gameplay. By placing a capacitive soil moisture sensor in a real plant pot, your real-world watering habits directly impact your virtual crops in Roblox. If your physical plant dries out, your Roblox crops wilt or stop growing until you water the real plant!

---

## 🛠️ Hardware Requirements
* **ESP32 Development Board** (e.g., ESP32-WROOM-32)
* **Capacitive Soil Moisture Sensor v1.2** *(Recommended over resistive sensors to prevent corrosion)*
* **Jumper Wires** (Female-to-Female)
* **Micro-USB / USB-C Cable** (for power and flashing)
* **Real Plant & Soil**

---

## 🔌 Wiring Diagram

| Capacitive Soil Sensor | ESP32 Pin |
| :--- | :--- |
| **VCC** | `3.3V` |
| **GND** | `GND` |
| **AOUT** (Analog Out) | `GPIO 34` (ADC1_CH6) |

> **Note:** Use an `ADC1` pin (like GPIO 32, 33, 34, or 35) on the ESP32, as `ADC2` pins cannot be used simultaneously with Wi-Fi.

---

## 🏗️ Architecture
Because Roblox games cannot directly communicate with local hardware over USB or local-only IP addresses without a public endpoint, data flows through a lightweight bridge:

```text
[Soil Sensor] ──(Analog)──> [ESP32] ──(HTTP POST / Wi-Fi)──> [Node.js / Python API] <──(HttpService GET)── [Roblox Game Server]
```

---
Soil sensors vary by batch. To get accurate percentages:
1. Open the **Serial Monitor** (`115200` baud) with the sensor dry in open air. Record the raw value as `DRY_VALUE`.
2. Submerge the sensor up to the white line in a glass of water. Record the raw value as `WET_VALUE`.
3. Update both constants in your ESP32 sketch.

---

## 📄 License
This project is open-source and available under the [MIT License](LICENSE).
