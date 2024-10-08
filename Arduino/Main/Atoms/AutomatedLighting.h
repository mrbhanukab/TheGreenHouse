/*
 *     _____ _              ___
 *    /__   \ |__   ___    / _ \_ __ ___  ___ _ __     /\  /\___  _   _ ___  ___
 *      / /\/ '_ \ / _ \  / /_\/ '__/ _ \/ _ \ '_ \   / /_/ / _ \| | | / __|/ _ \
 *     / /  | | | |  __/ / /_\\| | |  __/  __/ | | | / __  / (_) | |_| \__ \  __/
 *     \/   |_| |_|\___| \____/|_|  \___|\___|_| |_| \/ /_/ \___/ \__,_|___/\___|
 *    Arduino Part | AutomatedLighting.h | Safak Ahamed
 *
 *    This entire system was developed and maintained by Bhanuka Bandara, Ruvindi Jayasooriya,
 *    Muditha Pasan, Yashara Wanigasekara, Safak Ahamed, and Sandini Imesha. This specific part
 *    was developed by Safak Ahamed. For more information about this section of the system, please
 *    refer to the following wiki link: [wiki link about this part of the code].
 */

/*
? The pin definitions for the LDR, PIR sensor, and LED.
! LED should be connected to a PWM pin for variable brightness control.
! You can adjust the threshold value for darkness detection as needed.
 */
#define LED 33 // LED pin
#define PIR 35 // PIR sensor pin
#define LDR 32 // LDR sensor pin

int threshold = 45;     // Brightness threshold
int pwmFreq = 5000;     // PWM frequency (5kHz)
int pwmResolution = 13; // PWM resolution (13 bits = 0-8191 duty cycle range)

//! Must include this in setup() function of the main code
void AutomatedLightingSetup()
{
    ledcAttach(LED, pwmFreq, pwmResolution);

    // Set up other pins
    pinMode(PIR, INPUT);
    pinMode(LDR, INPUT);
}

void AutomatedLighting(bool isForcedLightOn)
{

    //? Turn the LED on without considering any conditions, if forced light is on
    if (isForcedLightOn)
    {
        ledcWrite(LED, 8191);
    }
    else
    {
        //? Turn the LED on if it is dark and set brightness to high if motion is detected
        //! Optimize for room lighting (0-4095 is the range of LDR)
        int brightness = map(analogRead(LDR), 0, 4095, 0, 100); // Adjust LDR range based on calibration

        if (brightness <= threshold)
        {
            byte motionState = digitalRead(PIR);

            if (motionState == HIGH)
                ledcWrite(LED, 8191);
            else
                ledcWrite(LED, 2047);
        }
        else
        {
            ledcWrite(LED, 0);
        }
    }
}
