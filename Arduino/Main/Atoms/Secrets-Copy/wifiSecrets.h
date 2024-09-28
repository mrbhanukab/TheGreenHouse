// secrets.h
#define NUM_NETWORKS 2

struct WiFiCredentials {
    const char* ssid;
    const char* password;
};

// Define an array of WiFiCredentials
WiFiCredentials wifiNetworks[NUM_NETWORKS] = {
    {"ssid1", "password1"},
    {"ssid2", "password2"},
};
