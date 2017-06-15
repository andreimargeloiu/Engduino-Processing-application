// The Engduino program takes data through the sensors and shows it in real time using Processing IDE
// The program consists of 3 applications which change when the button is pressed
// 1st app uses the Temperature sensor
// 2nd app uses the Light sensor
// 3rd app uses the Acceleration sensor

// Libraries to use Engduino sensors
#include <EngduinoButton.h>
#include <EngduinoLEDs.h>
#include <EngduinoThermistor.h>
#include <EngduinoLight.h>
#include <EngduinoAccelerometer.h>
#include <Wire.h> 
#define NRLEDs 16 // Define the number of LEDs
#define DELAY 250 // Define the delay between each iteration

int nrPressed; // No of time the button is pressed

// Variables for each different application
float tempInitial=-1; // Initial temperature when Engduimo enters Temperature application

// Code that runs when the Engduino is opened
void setup () {
  EngduinoLEDs.begin();
  EngduinoButton.begin();
  EngduinoThermistor.begin(); 
  EngduinoLight.begin(); 
  EngduinoAccelerometer.begin(); 
  
  // Initialize serial communications at a 9600 band rate
  // to properly communicate with Processing IDE
  Serial.begin(9600);  
}

// Funtion that runs continously
void loop () 
{
   // Change the program depending on the number of time the button is pressed
   switch (nrPressed) 
   {
      case 0: { // Engduino is off
          Serial.print("OFF ");
          break;
      }
      case 1: { 
         // Display temperatures between (0 - 40) degrees Celsius in Processing IDE
         // On Engduino, for each 0.2 degrees difference in temperature compared to the initial oneand
         // one more light is turned on
         // The lights are RED for increased temperature and BLUE for decreased temperature
         
         float temp = EngduinoThermistor.temperature();
         
         // When the application is opened, we take the initial temperature
         if (tempInitial == -1) tempInitial = temp;  
         
         // Keep the difference between the actual and initial temperature
         float dif = temp - tempInitial;
         
         // Send the marker and actual temperature to Processing IDE
         Serial.print ("temp ");
         Serial.print (temp);
         Serial.print (" ");
         
         // For each 0.2 Celsius degrees in difference compared to initial temperature one more LED
         // is turned on on Engduino       
         int LEDsToLight = abs(dif) / 0.2; 
         
         // We can turn on at most 16 lights
         if (LEDsToLight > NRLEDs) LEDsToLight = NRLEDs; 
         
         // Turn n the lights with the corresponding colour                                     
         for (int i = 0; i <= LEDsToLight; ++i)
             EngduinoLEDs.setLED (i, dif < 0 ? BLUE : RED, 5);
                
          break;
      } 
      
      case 2: { 
          // Display the light intensity(in lux) in Processing IDE
          
          int lightIntensity = EngduinoLight.lightLevel ();
          
          // Display a yellow L(light) on Engduino LEDs
          for (int i = 9; i <= 15; ++i) 
              EngduinoLEDs.setLED (i, YELLOW, 4);
          
          // Send the marker and actual Light Intensity to Processing IDE
          Serial.print ("light ");
          Serial.print (lightIntensity);
          Serial.print (" ");
          
          break;
      }
      
      case 3: {
          // Display the acceleration on all 3 axes in Processing IDE
          
          float accelerations[3]; 
          EngduinoAccelerometer.xyz(accelerations);
          
          // Display a green C(acceleration) on Engdunio LEDs
          for (int i = 7; i <= 15; ++i) 
              EngduinoLEDs.setLED (i, GREEN, 4);
          
          float x = accelerations[0];
          float y = accelerations[1];
          float z = accelerations[2];
              
          // Send the marker and actual accelerations to Processing IDE
          Serial.print("acc ");
          Serial.print(x);
          Serial.print(" ");
          Serial.print(y);
          Serial.print(" ");
          Serial.print(z);
          Serial.print(" ");
          
          break;
      }
   }
   delay (DELAY);
   
   // Turn off all LEDs
   EngduinoLEDs.setAll (OFF);
   
   if (EngduinoButton.wasPressed()) {
       ++nrPressed;
       // As we have 3 apps, we can change through them by making the modulo 4 of the number of time we pressed the button
       nrPressed %= 4;
       
       tempInitial = -1; // when the app changes, reinitialize the initial temperature
   }
}

