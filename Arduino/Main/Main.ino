/*
 *     _____ _              ___
 *    /__   \ |__   ___    / _ \_ __ ___  ___ _ __     /\  /\___  _   _ ___  ___
 *      / /\/ '_ \ / _ \  / /_\/ '__/ _ \/ _ \ '_ \   / /_/ / _ \| | | / __|/ _ \
 *     / /  | | | |  __/ / /_\\| | |  __/  __/ | | | / __  / (_) | |_| \__ \  __/
 *     \/   |_| |_|\___| \____/|_|  \___|\___|_| |_| \/ /_/ \___/ \__,_|___/\___|
 *    Arduino Part | Main.ino | Yashara Wanigasekara
 *
 *    This entire system was developed and maintained by Bhanuka Bandara, Ruvindi Jayasooriya,
 *    Muditha Pasan, Yashara Wanigasekara, Safak Ahamed, and Sandini Imesha. This specific part
 *    was developed by Yashara Wanigasekara. For more information about this section of the system, please
 *    refer to the following wiki link: [wiki link about this part of the code].
 */

//? Including Atoms
#include "Atoms/WIFI.h"
#include "Atoms/Firestore.h"

void setup() {
  Serial.begin(115200);
  WIFISetup();
}

void loop() {
  struct connectionState wifiStatus = EnsureWIFIIsConnected();

  if (wifiStatus.isConnected) {
    Serial.print("Connected to SSID: ");
    Serial.println(wifiStatus.ssid);


  }
}