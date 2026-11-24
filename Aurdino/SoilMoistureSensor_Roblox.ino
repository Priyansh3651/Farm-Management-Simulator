// Soil Moisture Sensor - Arduino Uno (Roblox bridge version)
// Wiring: Sensor VCC -> 5V, Sensor GND -> GND, Sensor AOUT -> A0
//
// Only prints the moisture percentage, one number per line, so the
// Python bridge script can read it with zero parsing hassle.

const int sensorPin = A0;

// Your calibrated values from the earlier calibration step
const int dryValue = 620;   // raw reading in dry air
const int wetValue = 280;   // raw reading fully in water

void setup() {
  Serial.begin(9600);
}

void loop() {
  int rawValue = analogRead(sensorPin);

  int moisturePercent = map(rawValue, dryValue, wetValue, 0, 100);
  moisturePercent = constrain(moisturePercent, 0, 100);

  Serial.println(moisturePercent); // just the number, nothing else

  delay(5000); // send a reading every 5 seconds
}
