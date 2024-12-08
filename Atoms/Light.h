int threshold = 1000;     // Brightness threshold

void lightON(){
    if(forcedLight) ledcWrite(LED, 8191);
    else {
        int brightness = analogRead(LDR);
        if(brightness > threshold){
             byte motionState = digitalRead(PIR);
              if (motionState == HIGH) ledcWrite(LED, 8191);
              else ledcWrite(LED, 2047);
        }
        else ledcWrite(LED, 0);
     }
}
