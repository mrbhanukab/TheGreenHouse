// secrets.h
#define NUM_NETWORKS <number of wifi>

struct WiFiCredentials
{
    const char *ssid;
    const char *password;
};

// Define an array of WiFiCredentials
WiFiCredentials wifiNetworks[NUM_NETWORKS] = {
    {"SSID 01", "password"},
    {"SSID 02", "password"},
};