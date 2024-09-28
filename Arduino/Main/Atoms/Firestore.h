/*
 *     _____ _              ___
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

#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClientSecureBearSSL.h>
#include "Secrets/firebaseSecrets.h"

void fromFirestoreFetch(const char *documentPath)
{
    std::unique_ptr<BearSSL::WiFiClientSecure> client(new BearSSL::WiFiClientSecure);

    // Ignore SSL certificate validation for testing
    client->setInsecure();

    // create an HTTPClient instance
    HTTPClient https;
    String url = "https://firestore.googleapis.com/v1/projects/the-green-house-p9/databases/(default)/documents/" + String(documentPath);
    Serial.println(url);
    https.begin(*client, url); // Initialize HTTP request with WiFiClient in insecure mode

    int httpResponseCode = https.GET(); // Send the request

    Serial.printf("HTTP Response Code: %d\n", httpResponseCode); // Log response code

    if (httpResponseCode > 0)
    {
        String response = https.getString(); // Get the response
        Serial.println("Document JSON: ");
        Serial.println(response); // Print the JSON document
    }
    else
    {
        Serial.printf("Error on sending GET: %s\n", https.errorToString(httpResponseCode).c_str());
    }
    https.end(); // Close the connection
}

void inFirestoreSet(const char *fieldPath, const char *uptodateValues)
{
    std::unique_ptr<BearSSL::WiFiClientSecure> client(new BearSSL::WiFiClientSecure);

    // Ignore SSL certificate validation for testing
    client->setInsecure();

    // create an HTTPClient instance
    HTTPClient https;
    String url = "https://firestore.googleapis.com/v1/projects/the-green-house-p9/databases/(default)/documents/greehouses/Malabe%20GH%2001?updateMask.fieldPaths=" + fieldPath;
    String jsonPayload = "{ 'fields': { " + uptodateValues + " } }";
    https.begin(*client, url); // Initialize HTTP request with WiFiClient in insecure mode

    https.addHeader("Content-Type", "application/json");
    int httpResponseCode = https.PATCH(jsonPayload); // Send the request

    Serial.printf("HTTP Response Code: %d\n", httpResponseCode); // Log response code

    if (httpResponseCode > 0)
    {
        String response = https.getString(); // Get the response
        Serial.println("Document JSON: ");
        Serial.println(response); // Print the JSON document
    }
    else
    {
        Serial.printf("Error on sending PATCH: %s\n", https.errorToString(httpResponseCode).c_str());
    }
    https.end(); // Close the connection
}

void inFirestoreWrite(const char *documentPath)
{
    std::unique_ptr<BearSSL::WiFiClientSecure> client(new BearSSL::WiFiClientSecure);

    // Ignore SSL certificate validation for testing
    client->setInsecure();

    // create an HTTPClient instance
    HTTPClient https;
    String url = "https://firestore.googleapis.com/v1/projects/the-green-house-p9/databases/(default)/documents/" + String(documentPath);
    Serial.println(url);
    https.begin(*client, url); // Initialize HTTP request with WiFiClient in insecure mode

    int httpResponseCode = https.GET(); // Send the request

    Serial.printf("HTTP Response Code: %d\n", httpResponseCode); // Log response code

    if (httpResponseCode > 0)
    {
        String response = https.getString(); // Get the response
        Serial.println("Document JSON: ");
        Serial.println(response); // Print the JSON document
    }
    else
    {
        Serial.printf("Error on sending GET: %s\n", https.errorToString(httpResponseCode).c_str());
    }
    https.end(); // Close the connection
}
