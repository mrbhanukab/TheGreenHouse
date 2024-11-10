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
#include <WiFi.h>
#include <WiFiMulti.h>

WiFiMulti wifiMulti;
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
    const char *ssid;
    char ip[16]; // Use a fixed-size array instead of dynamic allocation
};

void disconnectWIFI()
{
    WiFi.disconnect();
}

struct connectionState EnsureWIFIIsConnected()
{
    static char ssidBuffer[33]; // Buffer to hold the SSID (32 chars max for SSID + null terminator)
    struct connectionState current;

    if (wifiMulti.run(connectTimeoutMs) == WL_CONNECTED)
    {
        current.isConnected = true;
        strncpy(ssidBuffer, WiFi.SSID().c_str(), sizeof(ssidBuffer) - 1);
        ssidBuffer[sizeof(ssidBuffer) - 1] = '\0'; // Ensure null termination
        current.ssid = ssidBuffer;
        strncpy(current.ip, WiFi.localIP().toString().c_str(), sizeof(current.ip) - 1);
        current.ip[sizeof(current.ip) - 1] = '\0'; // Ensure null termination
    }
    else
    {
        current.isConnected = false;
        current.ssid = "Not Connected";
        strncpy(current.ip, "null", sizeof(current.ip) - 1);
        current.ip[sizeof(current.ip) - 1] = '\0'; // Ensure null termination
    }

    return current;
}