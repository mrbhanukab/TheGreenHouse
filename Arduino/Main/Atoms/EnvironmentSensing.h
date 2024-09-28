/*
 *     _____ _              ___
 *    /__   \ |__   ___    / _ \_ __ ___  ___ _ __     /\  /\___  _   _ ___  ___
 *      / /\/ '_ \ / _ \  / /_\/ '__/ _ \/ _ \ '_ \   / /_/ / _ \| | | / __|/ _ \
 *     / /  | | | |  __/ / /_\\| | |  __/  __/ | | | / __  / (_) | |_| \__ \  __/
 *     \/   |_| |_|\___| \____/|_|  \___|\___|_| |_| \/ /_/ \___/ \__,_|___/\___|
 *    Arduino Part | EnvironmentSensing.h | Muditha Pasan
 *
 *    This entire system was developed and maintained by Bhanuka Bandara, Ruvindi Jayasooriya,
 *    Muditha Pasan, Yashara Wanigasekara, Safak Ahamed, and Sandini Imesha. This specific part
 *    was developed by Muditha Pasan. For more information about this section of the system, please
 *    refer to the following wiki link: [wiki link about this part of the code].
 */

//! These libraries must be installed before using this code
#include <DHT.h>
#include <DHT_U.h>

//? The pin definitions for the DHT11, Heater, and Cooler
#define DHTPIN A0
#define DHTTYPE DHT11
#define HEATER 7
#define COOLER 8
#define FAN 9

DHT dht(DHTPIN, DHTTYPE);

//! Must include this in the setup() function of the main code
void EnvironmentSensingSetup()
{
    dht.begin();
    pinMode(HEATER, OUTPUT);
    pinMode(COOLER, OUTPUT);
    pinMode(FAN, OUTPUT);
}

struct environmentData
{
    int humidity;
    int temperature;
};

struct environmentData ReturnEnvironmentData(int temperatureLimit, int humidityLimit)
{
    struct environmentData current;

    //! This will truncate any decimal part. If precision is important, consider keeping them as float.
    current.humidity = (int) dht.readHumidity();
    current.temperature = (int) dht.readTemperature();

    //? Check if any readings failed and exit early (to try again).
    if (isnan(current.humidity) || isnan(current.temperature))
    {
        current.humidity = -1.0;    //? Default value indicating failure
        current.temperature = -1.0; //? Default value indicating failure
        return current;
    }

    //? Control HEATER & COOLER based on temperature
    if (current.temperature < temperatureLimit)
    {
        digitalWrite(HEATER, HIGH);
        digitalWrite(COOLER, LOW);
    }
    else if (current.temperature > temperatureLimit)
    {
        digitalWrite(HEATER, LOW);
        digitalWrite(COOLER, HIGH);
    }
    else
    {
        digitalWrite(HEATER, LOW);
        digitalWrite(COOLER, LOW);
    }

    /*
    ? Control FAN based on humidity
    ! The direction of the fan should be inversely proportional to the humidity, but here we simply turn it on in both scenarios.
    ! You must consider this factor when it comes to real-world use cases.
    */
    if (current.humidity < humidityLimit)
        digitalWrite(FAN, HIGH);
    else if (current.humidity > humidityLimit)
        digitalWrite(FAN, HIGH);
    else
        digitalWrite(FAN, LOW);

    /*
    ! This function returns the current data before controlling environmental factors.
    ! This won't be an issue unless you're using highly sensitive sensors, which most practical sensors aren't.
    */

    return current;
}
