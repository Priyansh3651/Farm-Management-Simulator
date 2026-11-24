"""
Arduino -> Adafruit IO bridge.

Reads soil moisture percentage from the Arduino over USB serial and
uploads it to your Adafruit IO feed, where your Roblox game reads it from.

Install first:  pip install pyserial requests
Run with:        python ArduinoToRoblox_Bridge.py

Leave this running in a terminal window while you want live data flowing
into your game.
"""

import time
import serial
import requests

# ---- FILL THESE IN ----
SERIAL_PORT = "COM3"          # Windows: "COM3", "COM4", etc. Mac/Linux: "/dev/cu.usbmodemXXXX"
BAUD_RATE = 9600

AIO_USERNAME = "your_adafruit_username"
AIO_KEY = "your_aio_key"
FEED_NAME = "soil-moisture"
# ------------------------

UPLOAD_URL = f"https://io.adafruit.com/api/v2/{AIO_USERNAME}/feeds/{FEED_NAME}/data"
HEADERS = {"X-AIO-Key": AIO_KEY}


def main():
    print(f"Connecting to {SERIAL_PORT}...")
    ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=2)
    time.sleep(2)  # give the Arduino a moment to reset after the port opens
    print("Connected. Reading moisture values and uploading to Adafruit IO...")

    while True:
        line = ser.readline().decode("utf-8", errors="ignore").strip()

        if line.isdigit():
            moisture = int(line)
            print(f"Moisture: {moisture}%  -> uploading...")
            try:
                response = requests.post(
                    UPLOAD_URL, json={"value": moisture}, headers=HEADERS, timeout=5
                )
                if response.status_code >= 300:
                    print(f"  Upload failed ({response.status_code}): {response.text}")
            except requests.RequestException as e:
                print(f"  Upload error: {e}")


if __name__ == "__main__":
    main()
