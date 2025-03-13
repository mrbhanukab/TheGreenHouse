//! WiFi Network Credentials
#define NUM_NETWORKS 1

struct WiFiCredentials
{
    const char *ssid;
    const char *password;
};

WiFiCredentials wifiNetworks[NUM_NETWORKS] = {
    {"mrbhanuka.hotspot", "hotspot@0987654321"},
};