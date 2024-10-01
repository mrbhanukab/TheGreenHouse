/*     _____ _              ___
 *    /__   \ |__   ___    / _ \_ __ ___  ___ _ __     /\  /\___  _   _ ___  ___
 *      / /\/ '_ \ / _ \  / /_\/ '__/ _ \/ _ \ '_ \   / /_/ / _ \| | | / __|/ _ \
 *     / /  | | | |  __/ / /_\\| | |  __/  __/ | | | / __  / (_) | |_| \__ \  __/
 *     \/   |_| |_|\___| \____/|_|  \___|\___|_| |_| \/ /_/ \___/ \__,_|___/\___|
 *    Arduino Part | Firestore.h | Bhanuka Bandara
 *
 *    This entire system was developed and maintained by Bhanuka Bandara, Ruvindi Jayasooriya,
 *    Muditha Pasan, Yashara Wanigasekara, Safak Ahamed, and Sandini Imesha. This specific part
 *    was developed by Bhanuka Bandara. For more information about this section of the system, please
 *    refer to the following wiki link: [wiki link about this part of the code].
 */

#include <ESP8266HTTPClient.h>
#include <WiFiClientSecure.h>
#include <ArduinoJson.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <map>

// Define NTP Client
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");

struct Environment
{
    std::map<String, int> moisture;
    int humidity;
    int temperature;
};

WiFiClientSecure setupClient()
{
    WiFiClientSecure client;
    client.setInsecure(); // Ignore SSL certificate validation for testing
    return client;
}

bool handleHTTPResponse(HTTPClient &http, String &response)
{
    int httpResponseCode = http.GET();
    if (httpResponseCode > 0)
    {
        Serial.printf("[HTTP] GET... code: %d\n", httpResponseCode);
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

Environment fetchEnvironmentLimitsOf(const char *greenhouse)
{
    Environment limit;
    WiFiClientSecure client = setupClient();
    HTTPClient http;
    String url = "https://firestore.googleapis.com/v1/projects/the-green-house-p9/databases/(default)/documents/greehouses/" + String(greenhouse) + "?mask.fieldPaths=currentEnvironment";

    if (http.begin(client, url))
    {
        String response;
        if (handleHTTPResponse(http, response))
        {
            DynamicJsonDocument doc(2048);
            DeserializationError error = deserializeJson(doc, response);
            if (!error)
            {
                JsonObject currentEnvironment = doc["fields"]["currentEnvironment"]["mapValue"]["fields"];
                JsonObject moisture = currentEnvironment["moisture"]["mapValue"]["fields"];
                for (JsonPair kv : moisture)
                {
                    limit.moisture[kv.key().c_str()] = kv.value()["integerValue"].as<int>();
                }
                limit.humidity = currentEnvironment["humidity"]["integerValue"].as<int>();
                limit.temperature = currentEnvironment["temperature"]["integerValue"].as<int>();
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

bool fetchForcedLightStatusOf(const char *greenhouse)
{
    bool forcedLightStatus = false;
    WiFiClientSecure client = setupClient();
    HTTPClient http;
    String url = "https://firestore.googleapis.com/v1/projects/the-green-house-p9/databases/(default)/documents/greehouses/" + String(greenhouse) + "?mask.fieldPaths=forcedLight";

    if (http.begin(client, url))
    {
        String response;
        if (handleHTTPResponse(http, response))
        {
            DynamicJsonDocument doc(2048);
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

Environment setCurrentEnvironmentOf(const char *greenhouse, int temperature, int humidity, std::map<String, int> moisture)
{
    Environment updatedEnvironment;
    WiFiClientSecure client = setupClient();
    HTTPClient http;
    String url = "https://firestore.googleapis.com/v1/projects/the-green-house-p9/databases/(default)/documents/greehouses/" + String(greenhouse) + "?mask.fieldPaths=currentEnvironment&updateMask.fieldPaths=currentEnvironment";

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

unsigned long Get_Epoch_Time()
{
    timeClient.update();
    return timeClient.getEpochTime();
}

bool createNewAlert(const char *greenhouse, const char *type, const char *msg)
{
    WiFiClientSecure client = setupClient();
    HTTPClient http;

    // Get the current timestamp in Epoch format
    unsigned long now = Get_Epoch_Time();
    String timestamp = String(now);

    String url = "https://firestore.googleapis.com/v1/projects/the-green-house-p9/databases/(default)/documents/greehouses/" + String(greenhouse) + "/AlertsAndLogs/" + timestamp;

    if (http.begin(client, url))
    {
        http.addHeader("Accept", "application/json");
        http.addHeader("Content-Type", "application/json");

        DynamicJsonDocument doc(1024);
        JsonObject fields = doc.createNestedObject("fields");
        fields["msg"]["stringValue"] = msg;
        fields["type"]["stringValue"] = type;

        String payload;
        serializeJson(doc, payload);

        int httpResponseCode = http.PATCH(payload);
        if (httpResponseCode > 0)
        {
            String response = http.getString();
            Serial.println("Alert created successfully:");
            Serial.println(response);
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