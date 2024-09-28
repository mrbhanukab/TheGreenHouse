/*
 *     _____ _              ___
 *    /__   \ |__   ___    / _ \_ __ ___  ___ _ __     /\  /\___  _   _ ___  ___
 *      / /\/ '_ \ / _ \  / /_\/ '__/ _ \/ _ \ '_ \   / /_/ / _ \| | | / __|/ _ \
 *     / /  | | | |  __/ / /_\\| | |  __/  __/ | | | / __  / (_) | |_| \__ \  __/
 *     \/   |_| |_|\___| \____/|_|  \___|\___|_| |_| \/ /_/ \___/ \__,_|___/\___|
 *    Arduino Part | WIFI.h | Bhanuka Bandara
 *
 *    This entire system was developed and maintained by Bhanuka Bandara, Ruvindi Jayasooriya,
 *    Muditha Pasan, Yashara Wanigasekara, Safak Ahamed, and Sandini Imesha. This specific part
 *    was developed by Bhanuka Bandara. For more information about this section of the system, please
 *    refer to the following wiki link: [wiki link about this part of the code].
 */

#include "Secrets/wifiSecrets.h"

//! These libraries must be installed before using this code
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>

ESP8266WiFiMulti wifiMulti;
const uint32_t connectTimeoutMs = 30000;

//! Must include this in the setup() function of the main code
void WIFISetup()
{
    WiFi.mode(WIFI_STA);

    //? Loop through the WiFi networks and add each SSID/password pair
    for (int i = 0; i < NUM_NETWORKS; i++)
    {
        wifiMulti.addAP(wifiNetworks[i].ssid, wifiNetworks[i].password);
    }
}

struct connectionState
{
    bool isConnected;
    char *ssid;
};

struct connectionState EnsureWIFIIsConnected()
{
    struct connectionState current;

    if (wifiMulti.run(connectTimeoutMs) == WL_CONNECTED)
    {
        current.isConnected = true;
        current.ssid = WiFi.SSID().c_str();
    }
    else
    {
        current.isConnected = false;
        current.ssid = "Not Connected";
    }
}