void readPlant() {
  int plant = analogRead(SOIL_MOISTURE_PIN);
  int moisture = map(plant, 0, 4095, 100, 0);
//   Serial.print("Plant moisture: ");
//   Serial.println(moisture);
}