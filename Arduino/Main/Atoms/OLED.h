/*
 *     _____ _              ___
 *    /__   \ |__   ___    / _ \_ __ ___  ___ _ __     /\  /\___  _   _ ___  ___
 *      / /\/ '_ \ / _ \  / /_\/ '__/ _ \/ _ \ '_ \   / /_/ / _ \| | | / __|/ _ \
 *     / /  | | | |  __/ / /_\\| | |  __/  __/ | | | / __  / (_) | |_| \__ \  __/
 *     \/   |_| |_|\___| \____/|_|  \___|\___|_| |_| \/ /_/ \___/ \__,_|___/\___|
 *    Arduino Part | OLED.h | Muditha Pasan
 *
 *    This entire system was developed and maintained by Bhanuka Bandara, Ruvindi Jayasooriya,
 *    Muditha Pasan, Yashara Wanigasekara, Safak Ahamed, and Sandini Imesha. This specific part
 *    was developed by Muditha Pasan. For more information about this section of the system, please
 *    refer to the following wiki link: [wiki link about this part of the code].
 */

//! These libraries must be installed before using this code
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

//? OLED display parameters
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

//! Include this in the setup() function of the main code
void OLEDsetup()
{
    Wire.begin();
    while (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C))
    {
        Serial.println(F("SSD1306 allocation failed"));
        delay(2000);
    }

    display.clearDisplay();
    display.setTextSize(1);
    display.setTextColor(SSD1306_WHITE);
    display.clearDisplay();
}

//! You can simply use other methods from Adafruit_SSD1306 with display.method
void ShowInOLED(byte X, byte Y, int size, const char *text)
{
    display.clearDisplay();
    display.setTextSize(size);
    display.setCursor(X, Y);
    display.print(text);
    display.drawLine(0, 50, SCREEN_WIDTH, 50, SSD1306_WHITE);
    display.setTextSize(1);
    display.setCursor(2, 55);
    display.print("hi!!!!!!!!!");
    display.display();
}