TaskHandle_t RFID = NULL;

void taskManager(){
    xTaskCreate(
        RFID,          // Task function
        "RFID",       // Task name
        10000,          // Stack size (in words)
        NULL,           // Task input parameter
        1,              // Priority of the task
        &Task1Handle    // Task handle
    );
}