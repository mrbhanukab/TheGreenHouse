int ledPin = 8; // Pin connected to the LED or output device
char input;     // Variable to store user input

void setup() {
  // Initialize the serial communication at a baud rate of 9600
  Serial.begin(9600);
  
  // Set pin 8 as an output
  pinMode(ledPin, OUTPUT);

  // Make sure the pin starts off as LOW (off)
  digitalWrite(ledPin, LOW);
}

void loop() {
  // Check if data is available in the serial buffer
  if (Serial.available() > 0) {
    // Read the input from the serial monitor
    input = Serial.read();
    
    // Check if the input is '1'
    if (input == '1') {
      digitalWrite(ledPin, HIGH);  // Set pin 8 to HIGH
      Serial.println("Pin 8 is HIGH");
    }
    // Check if the input is '0'
    else if (input == '0') {
      digitalWrite(ledPin, LOW);   // Set pin 8 to LOW
      Serial.println("Pin 8 is LOW");
    }
  }
}
