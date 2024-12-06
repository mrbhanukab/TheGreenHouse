/*
 *     _____ _              ___
 *    /__   \ |__   ___    / _ \_ __ ___  ___ _ __     /\  /\___  _   _ ___  ___
 *      / /\/ '_ \ / _ \  / /_\/ '__/ _ \/ _ \ '_ \   / /_/ / _ \| | | / __|/ _ \
 *     / /  | | | |  __/ / /_\\| | |  __/  __/ | | | / __  / (_) | |_| \__ \  __/
 *     \/   |_| |_|\___| \____/|_|  \___|\___|_| |_| \/ /_/ \___/ \__,_|___/\___|
 *    Arduino Part | Buzzer.h | Bhanuka Bandara
 *
 *    This entire system was developed and maintained by Bhanuka Bandara, Ruvindi Jayasooriya,
 *    Muditha Pasan, Yashara Wanigasekara, Safak Ahamed, and Sandini Imesha. This specific part
 *    was developed by Bhanuka Bandara. For more information about this section of the system, please
 *    refer to the following wiki link: [wiki link about this part of the code].
 */

#define BUZZER_PIN 14

int melodyAuth[] = {
    NOTE_B4, NOTE_B5, NOTE_FS5, NOTE_DS5,
    NOTE_B5, NOTE_FS5, NOTE_DS5, NOTE_C5,
    NOTE_C6, NOTE_G6, NOTE_E6, NOTE_C6, NOTE_G6, NOTE_E6,

    NOTE_B4, NOTE_B5, NOTE_FS5, NOTE_DS5, NOTE_B5,
    NOTE_FS5, NOTE_DS5, NOTE_DS5, NOTE_E5, NOTE_F5,
    NOTE_F5, NOTE_FS5, NOTE_G5, NOTE_G5, NOTE_GS5, NOTE_A5, NOTE_B5};

int durationsAuth[] = {
    16, 16, 16, 16,
    32, 16, 8, 16,
    16, 16, 16, 32, 16, 8,

    16, 16, 16, 16, 32,
    16, 8, 32, 32, 32,
    32, 32, 32, 32, 32, 16, 8};

int melodyNotAuth[] = {
    NOTE_E5, NOTE_B4, NOTE_C5, NOTE_D5, NOTE_C5, NOTE_B4,
    NOTE_A4, NOTE_A4, NOTE_C5, NOTE_E5, NOTE_D5, NOTE_C5,
    NOTE_B4, NOTE_C5, NOTE_D5, NOTE_E5,
    NOTE_C5, NOTE_A4, NOTE_A4, NOTE_A4, NOTE_B4, NOTE_C5,

    NOTE_D5, NOTE_F5, NOTE_A5, NOTE_G5, NOTE_F5,
    NOTE_E5, NOTE_C5, NOTE_E5, NOTE_D5, NOTE_C5,
    NOTE_B4, NOTE_B4, NOTE_C5, NOTE_D5, NOTE_E5,
    NOTE_C5, NOTE_A4, NOTE_A4, REST,
};

int durationsNotAuth[] = {
    4, 8, 8, 4, 8, 8,
    4, 8, 8, 4, 8, 8,
    4, 8, 4, 4,
    4, 4, 8, 4, 8, 8,

    4, 8, 4, 8, 8,
    4, 8, 4, 8, 8,
    4, 8, 8, 4, 4,
    4, 4, 4, 4,
    };

//? The pin definitions for the Buzzer.
#define BUZZER_PIN 14

void BuzzerSetup()
{
    pinMode(BUZZER_PIN, OUTPUT);
}

void BuzzerOn(bool isBuzzerOn)
{
    if (isBuzzerOn)
    {
        digitalWrite(BUZZER_PIN, HIGH);
    }
    else
    {
        digitalWrite(BUZZER_PIN, LOW);
    }
}
void authTone()
{
    int size = sizeof(durationsAuth) / sizeof(int);

    for (int note = 0; note < size; note++)
    {
        // to calculate the note duration, take one second divided by the note type.
        // e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
        int duration = 1000 / durationsAuth[note];
        tone(BUZZER_PIN, melodyAuth[note], duration);

        // to distinguish the notes, set a minimum time between them.
        // the note's duration + 30% seems to work well:
        int pauseBetweenNotes = duration * 1.20;
        delay(pauseBetweenNotes);

        // stop the tone playing:
        noTone(BUZZER_PIN);
    }
}

void notAuthTone()
{
    int size = sizeof(durationsNotAuth) / sizeof(int);

    for (int note = 0; note < size; note++)
    {
        // to calculate the note duration, take one second divided by the note type.
        // e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
        int duration = 1000 / durationsNotAuth[note];
        tone(BUZZER_PIN, melodyNotAuth[note], duration);

        // to distinguish the notes, set a minimum time between them.
        // the note's duration + 50% seems to work well:
        int pauseBetweenNotes = duration * 1.50;
        delay(pauseBetweenNotes);

        // stop the tone playing:
        noTone(BUZZER_PIN);
    }
}
