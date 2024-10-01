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
! You can adjust the threshold value for darkness detection as needed. */
byte led = 9;
byte pir = 2;
byte ldr = A0;
int threshold = 500;

//! Must include this in setup() function of main code
void AutomatedLightingSetup()
{
    pinMode(pir, INPUT);
    pinMode(ldr, INPUT);
    pinMode(led, OUTPUT);
}

void AutomatedLighting(bool isForcedLightOn)
{
    //? Turn the LED on without considering any conditions, if forced light is on
    if (isForcedLightOn)
    {
        digitalWrite(led, HIGH);
        return;
    }

    //? Turn the LED on if it is dark and set brightness to high if motion is detected
    int ldrValue = 1023 - analogRead(ldr);
    byte motionState = digitalRead(pir);

    if (ldrValue < threshold)
    {
        if (motionState == HIGH)
            analogWrite(led, 255);
        else
            analogWrite(led, 50); //! Change the brightness level as needed
    }
    else
        analogWrite(led, 0);
}