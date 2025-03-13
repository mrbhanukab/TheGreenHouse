/*     _____ _              ___
 *    /__   \ |__   ___    / _ \_ __ ___  ___ _ __     /\  /\___  _   _ ___  ___
 *      / /\/ '_ \ / _ \  / /_\/ '__/ _ \/ _ \ '_ \   / /_/ / _ \| | | / __|/ _ \
 *     / /  | | | |  __/ / /_\\| | |  __/  __/ | | | / __  / (_) | |_| \__ \  __/
 *     \/   |_| |_|\___| \____/|_|  \___|\___|_| |_| \/ /_/ \___/ \__,_|___/\___|
 *    ESP32 Part | Firestore.h | Bhanuka Bandara
 *
 *    This system was upgraded for ESP32 compatibility.
 */

// Necessary libraries for ESP32
#include <HTTPClient.h> // Use HTTPClient instead of ESP8266HTTPClient
#include <WiFiClientSecure.h>
#include <ArduinoJson.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <map>

// Define NTP Client
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");

// Structure to hold environment data
struct Environment
{
    std::map<String, int> moisture;
    int humidity;
    int temperature;
};

// Global secure WiFi client
WiFiClientSecure client;

// Initialize the WiFi client once
void setupClient()
{
    if (!client.connected())
    {
        client.setInsecure(); // For testing purposes, ignore SSL certificate validation
    }
}

// Handle the HTTP response from Firestore
bool handleHTTPResponse(HTTPClient &http, String &response)
{
    int httpResponseCode = http.GET();
    if (httpResponseCode > 0)
    {
        if (httpResponseCode == HTTP_CODE_OK || httpResponseCode == HTTP_CODE_MOVED_PERMANENTLY)
        {
            response = http.getString();
            return true;
        }
    }
    else
    {
        Serial.printf("[HTTP] GET... failed, error: %s\n", http.errorToString(httpResponseCode).c_str());
    }
    return false;
}

// Fetch environment limits from Firestore
Environment fetchEnvironmentLimitsOf(const char *greenhouse)
{
    setupClient(); // Initialize the client

    Environment limit;
    HTTPClient http;
    String url = "https://firestore.googleapis.com/v1/projects/the-green-house-p9/databases/(default)/documents/greenhouses/" + String(greenhouse) + "?mask.fieldPaths=environmentLimits";

    if (http.begin(client, url))
    {
        String response;
        if (handleHTTPResponse(http, response))
        {
            DynamicJsonDocument doc(2048);
            DeserializationError error = deserializeJson(doc, response);
            if (!error)
            {
                JsonObject environmentLimits = doc["fields"]["environmentLimits"]["mapValue"]["fields"];
                JsonObject moisture = environmentLimits["moisture"]["mapValue"]["fields"];
                for (JsonPair kv : moisture)
                {
                    limit.moisture[kv.key().c_str()] = kv.value()["integerValue"].as<int>();
                }
                limit.humidity = environmentLimits["humidity"]["integerValue"].as<int>();
                limit.temperature = environmentLimits["temperature"]["integerValue"].as<int>();
            }
            else
            {
                Serial.print(F("deserializeJson() failed: "));
                Serial.println(error.f_str());
            }
        }
        http.end();
    }
    return limit;
}

// Fetch forced light status from Firestore
bool fetchForcedLightStatusOf(const char *greenhouse)
{
    setupClient(); // Ensure client is initialized

    bool forcedLightStatus = false;
    HTTPClient http;
    String url = "https://firestore.googleapis.com/v1/projects/the-green-house-p9/databases/(default)/documents/greenhouses/" + String(greenhouse) + "?mask.fieldPaths=forcedLight";

    if (http.begin(client, url))
    {
        String response;
        if (handleHTTPResponse(http, response))
        {
            DynamicJsonDocument doc(1024);
            DeserializationError error = deserializeJson(doc, response);
            if (!error)
            {
                JsonObject fields = doc["fields"];
                if (fields.containsKey("forcedLight"))
                {
                    forcedLightStatus = fields["forcedLight"]["booleanValue"].as<bool>();
                }
            }
            else
            {
                Serial.print(F("deserializeJson() failed: "));
                Serial.println(error.f_str());
            }
        }
        http.end();
    }
    return forcedLightStatus;
}

// Set current environment values in Firestore
Environment setCurrentEnvironmentOf(const char *greenhouse, int temperature, int humidity, std::map<String, int> moisture)
{
    setupClient(); // Ensure client is initialized

    Environment updatedEnvironment;
    HTTPClient http;
    String url = "https://firestore.googleapis.com/v1/projects/the-green-house-p9/databases/(default)/documents/greenhouses/" + String(greenhouse) + "?mask.fieldPaths=currentEnvironment&updateMask.fieldPaths=currentEnvironment";

    if (http.begin(client, url))
    {
        http.addHeader("Accept", "application/json");
        http.addHeader("Content-Type", "application/json");

        DynamicJsonDocument doc(2048);
        JsonObject fields = doc.createNestedObject("fields");
        JsonObject currentEnvironment = fields.createNestedObject("currentEnvironment");
        JsonObject mapValue = currentEnvironment.createNestedObject("mapValue");
        JsonObject envFields = mapValue.createNestedObject("fields");
        envFields["humidity"]["integerValue"] = String(humidity);
        envFields["temperature"]["integerValue"] = String(temperature);

        JsonObject moistureMap = envFields.createNestedObject("moisture").createNestedObject("mapValue").createNestedObject("fields");
        for (const auto &kv : moisture)
        {
            moistureMap[kv.first]["integerValue"] = String(kv.second);
        }

        String payload;
        serializeJson(doc, payload);

        int httpResponseCode = http.PATCH(payload);
        if (httpResponseCode > 0)
        {
            String response = http.getString();
            DynamicJsonDocument responseDoc(2048);
            DeserializationError error = deserializeJson(responseDoc, response);
            if (!error)
            {
                JsonObject currentEnvironment = responseDoc["fields"]["currentEnvironment"]["mapValue"]["fields"];
                JsonObject moisture = currentEnvironment["moisture"]["mapValue"]["fields"];
                for (JsonPair kv : moisture)
                {
                    updatedEnvironment.moisture[kv.key().c_str()] = kv.value()["integerValue"].as<int>();
                }
                updatedEnvironment.humidity = currentEnvironment["humidity"]["integerValue"].as<int>();
                updatedEnvironment.temperature = currentEnvironment["temperature"]["integerValue"].as<int>();
            }
            else
            {
                Serial.print(F("deserializeJson() failed: "));
                Serial.println(error.f_str());
            }
        }
        else
        {
            Serial.print("Error on sending PATCH: ");
            Serial.println(httpResponseCode);
        }
        http.end();
    }
    else
    {
        Serial.println("Unable to connect");
    }
    return updatedEnvironment;
}

// Fetch epoch time using NTPClient
unsigned long Get_Epoch_Time()
{
    timeClient.update();
    return timeClient.getEpochTime();
}

// Create a new alert in Firestore
bool createNewAlert(const char *greenhouse, const char *type, const char *msg)
{
    setupClient(); // Ensure the client is initialized

    HTTPClient http;

    // Get the current timestamp in Epoch format
    unsigned long now = Get_Epoch_Time();
    String timestamp = String(now);
    String url = "https://firestore.googleapis.com/v1/projects/the-green-house-p9/databases/(default)/documents/greenhouses/" + String(greenhouse) + "/AlertsAndLogs/" + timestamp;

    if (http.begin(client, url))
    {
        http.addHeader("Accept", "application/json");
        http.addHeader("Content-Type", "application/json");

        DynamicJsonDocument doc(2048);
        JsonObject fields = doc.createNestedObject("fields");
        fields["msg"]["stringValue"] = msg;
        fields["type"]["stringValue"] = type;

        String payload;
        serializeJson(doc, payload);

        int httpResponseCode = http.PATCH(payload);
        if (httpResponseCode > 0)
        {
            String response = http.getString();
            return true;
        }
        else
        {
            Serial.print("Error on sending PATCH: ");
            Serial.println(httpResponseCode);
            return false;
        }
        http.end();
    }
    else
    {
        Serial.println("Unable to connect");
        return false;
    }
}

// Function to authenticate user asynchronously
void asyncAuthenticatingUser(const String &cardId, const String &greenhouseId, void (*callback)(const byte &, const String &))
{
    // Make sure WiFiClientSecure is initialized
    setupClient();

    HTTPClient http;
    String url = "https://firestore.googleapis.com/v1/projects/the-green-house-p9/databases/(default)/documents:runQuery";

    // Construct the JSON body for the Firestore query
    String queryPayload = "{\"structuredQuery\": {"
                          "\"from\": [{\"collectionId\": \"users\"}],"
                          "\"where\": {"
                          "\"fieldFilter\": {"
                          "\"field\": {\"fieldPath\": \"cardid\"},"
                          "\"op\": \"EQUAL\","
                          "\"value\": {\"stringValue\": \"" +
                          cardId + "\"}"
                                   "}"
                                   "},"
                                   "\"limit\": 1"
                                   "}}";

    // Start the HTTP POST request
    if (http.begin(client, url))
    {
        http.addHeader("Content-Type", "application/json");
        http.addHeader("Accept", "application/json");

        int httpCode = http.POST(queryPayload); // Send the POST request with the query payload

        if (httpCode > 0)
        {
            String response = http.getString();

            // Deserialize the JSON response
            DynamicJsonDocument doc(512);
            DeserializationError error = deserializeJson(doc, response);

            if (!error)
            {
                if (!doc.isNull() && !doc[0]["document"].isNull())
                {
                    JsonObject fields = doc[0]["document"]["fields"];
                    String userName = fields["name"]["stringValue"];
                    JsonArray userGreenhouses = fields["greenhouses"]["arrayValue"]["values"];

                    bool hasAccess = false;

                    // Loop through the user's greenhouses and check if they have access
                    for (JsonVariant greenhouse : userGreenhouses)
                    {
                        if (greenhouse["stringValue"] == greenhouseId)
                        {
                            hasAccess = true;
                            break;
                        }
                    }

                    if (hasAccess)
                    {
                        callback(1, userName); // Return authenticated status and user name
                    }
                    else
                    {
                        callback(2, userName); // Return not authenticated status and user name
                    }
                }
                else
                {
                    callback(3, ""); // Return user not found status
                }
            }
            else
            {
                Serial.print(F("deserializeJson() failed: "));
                Serial.println(error.f_str());
                callback(4, ""); // Return error
            }
        }
        else
        {
            Serial.printf("[HTTP] POST... failed, error: %s\n", http.errorToString(httpCode).c_str());
            callback(5, ""); // Return error
        }

        // Always end the HTTP request
        http.end();
    }
    else
    {
        Serial.println("Unable to connect");
        callback(6, ""); // Return error
    }
}