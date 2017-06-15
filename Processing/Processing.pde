//This application uses a program created in Processing IDE in order to receive data from 
//an Engduino through serial port. Depending on the type of data received(temperature, light level,
//accelerometer data), it displays some certain values and figures using a real-time drawing.

//Using serial lirary in order to read from serial input
import processing.serial.*;

Serial myPort;   //The port variable in which we will store the serial port's details
String myString = null, auxiliarString = null;   // Data received from the serial port
String lastCase = null; // Variable to store the previous graph and see when the graph changes

int Windth = 700, Height = 350; // Dimensions of the background
int endChar = ' ';// 'Space' character in ACII will be used to mark the end of a value in the input received from Engduino

// Variables used for printing the graph   
float xTemp, yTemp;
float xLight, yLight;
float xAcc, yAcc, zAcc;

// Variable storing data in each application after reading the values from serial port
float tempCelsius, maxTemperature = 0, minTemperature = 40;
float lightIntensity, maxLightIntensity = 0, minLightIntensity = 1200;
float XAcc, YAcc, ZAcc, acceleration;

// Function to find the serial port to input data
void findSerialPort()
{
    //Get a list of the serial ports
    String[] listPorts = Serial.list();
    
    //Iterate through ports to find the good one
    for (int i = 0; i < listPorts.length; i++)
    { 
      try {    
        if (!listPorts[i].contains("cu.usbmodem"))
        {
          //If a port is of type USB, we try to connect to it
          myPort = new Serial(this, listPorts[i], 9600);
          
          delay(10);      //delay used to assure time for connection
          
          //If the port is available, we have found the correct port
          if (myPort.available() > 0)
          {
            if (myPort.readStringUntil('.').equals("OFF."))
            {
               break;
            }
          }
        }
      }
      catch(RuntimeException e)
      {
        //An error occured!
      }
  }
}

// This code runs just once
void setup () 
{ 
   findSerialPort (); // Find the port
   
   // If there is an active port, throw out the first reading, in case we started reading in the middle of a string from the sender
   if(myPort != null)
        myPort.clear();
   
   size (701, 351); // Windth from 0 - 700, Height 0 - 350
   background (240); // set background colour to grey
}

// Clean completely the canvas
void eraseCanvas () {
    stroke (240); fill (240);
    rect (0, 0, 700, 350); 
}

// Function to reset the whole canvas and draw again the Temperature axes
void TemperatureAxes () {
    eraseCanvas (); // reset the whole canvas
    
    // Write "Temperature" on top of the graph
    textSize (20); stroke(0); fill(0);
    text ("Temperature", 290, 25);
    
    // Draw the axes
    stroke (0); fill (0); // Set black colour
    line (30, 320, 30, 120); // Temperature axe
    line (30, 320, 680, 320); // Time axe
    
    // Draw the scale in multiple of 5 degrees in range [0 - 40]
    int Y=320;
    for (int i=0; i<=40; i+=5) {
        stroke(0); fill (0); textSize (10);
        text (i, 15, Y); // Print the temperature scale number
              
        line (27, Y, 30, Y); // Draw a small line after the temperature number
        Y-=25; // The Y coordinate of the next point
    }    
    xTemp = 33; // X coordinate where the graph will start
}

// Function to reset the whole canvas and draw again the Light Intensity axes
void LightAxes () {
    eraseCanvas (); // reset the whole canvas
    
    // Write "Light Intensity" on top of the graph
    textSize (20); stroke(0); fill(0);
    text ("Light Intensity", 280, 25);
    
    // Draw the axes
    stroke (0); fill (0); // Set black colour
    line (30, 320, 30, 100); // Light Intensity axe
    line (30, 320, 680, 320); // Time axe
    
    // Draw the scale in multiple of 100 lux    
    int Y=320;
    for (int i=0; i<=1100; i+=100) {
        stroke(0); fill (0); textSize (10);
        text (i, 2, Y); // Print the Light Intensity scale number
              
        line (27, Y, 30, Y); // Draw a small line after the Light Intensity number
        Y-=20; // The Y coordinate of the next point
    }  
    xLight = 33; // X coordinate where the graph will start
}

// Function to reset the whole canvas and draw again the Acceleration axes
void AccAxes () {
    eraseCanvas (); // reset the whole canvas
    
    // Write "Acceleration" on top of the graph
    textSize (20); stroke(0); fill(0);
    text ("Acceleration", 280, 25);
    
    // Draw the axes
    stroke (0); fill (0); // Set black colour
    line (40, 320, 40, 100); // Acceleration axe
    line (40, 320, 680, 320); // Time axe
    
    // Draw the scale in multiple of 0.5 
    int Y=320;
    for (float i=-3; i<=3; i+=0.5) {
        stroke(0); fill (0); textSize (10);
        text (i, 2, Y); // Print the Acceleration scale number
              
        line (37, Y, 40, Y); // Draw a small line after the Acceleration number
        Y-=17; // The Y coordinate of the next point
    }  
    xAcc = 43; // X coordinate where the graph will start
}

// Determine which application to run (temperature, light sensor, accelerometer) 
// depending on a marker received from the Engduino
// Also initialize all the global variables 
int read () 
{
    // Read until 'Space' is found
    String myString = myPort.readStringUntil (endChar);
    int caseID = -1;
    
    // Switching between the three types of applications depending on the first string received
    // Engduino transmits a marker for each application ('OFF ", "temp ", "light ", "acc ")
    switch (myString) 
    {
        case "OFF ": {
           caseID = 0; 
           lastCase = myString;
           break;
        }
        
        case "temp ": {
            if ( ! myString.equals (lastCase)) 
            {
                // If the current case is different than the previous, we have switched cases 
                // so we have to reinitialise everything
                TemperatureAxes ();
                
                minTemperature = 40;
                maxTemperature = 0;
            }
            
            // The last case becomes the current one for the next case
            // And we return the caseID = 1 to the main program
            lastCase = "temp ";
            caseID = 1;
            
            // Take the temperature value
            myString = myPort.readStringUntil (endChar);
            if (myString != null) 
                tempCelsius = float (myString);
            
            // Update the maximum and the minimum if it's the case
            if (maxTemperature < tempCelsius)
                maxTemperature = tempCelsius;
                
            if (minTemperature > tempCelsius)
                minTemperature = tempCelsius;
            break;
        } 
        
        case "light ": {
            if ( ! myString.equals (lastCase)) {
                // If the current case is different than the previous, we have switched cases 
                // so we have to reinitialise everything
                
                LightAxes ();
                
                minLightIntensity = 1200;
                maxLightIntensity = 0;   
            }
            
            // The last case becomes the current one for the next case
            // And we return the caseID = 2 to the main program
            lastCase = "light ";
            caseID = 2;
            
            // Take the Light Intensity value
            myString = myPort.readStringUntil (endChar);
            if (myString != null) 
                lightIntensity = float (myString);
                
            // Update the maximum and the minimum if it's the case
            if (maxLightIntensity < lightIntensity)
                maxLightIntensity = lightIntensity;
                 
            if (minLightIntensity > lightIntensity)
                minLightIntensity = lightIntensity;
            break;
        }
        
        case "acc ": {
            if ( ! myString.equals (lastCase)) {
                // If the current case is different than the previous, we have switched cases 
                // so we have to reinitialise everything
                
                AccAxes ();
                
                xAcc = 43; // position where the Acceleration graph will start
            }
            
            // The last case becomes the current one for the next case
            // And we return the caseID = 3 to the main program
            lastCase = "acc ";
            caseID = 3;
            
            // Take the Acceleration values
            myString = myPort.readStringUntil (endChar);
            if (myString != null) 
                XAcc = float (myString);
            
            myString = myPort.readStringUntil (endChar);
            if (myString != null) 
                YAcc = float (myString);
                
            myString = myPort.readStringUntil (endChar);
            if (myString != null) 
                ZAcc = float (myString);
            
            break;
        }
        
        // If the function doesn't find a marker, return -1
        default: {
            caseID = -1;
            break;
        }  
    }
    return caseID;
}

// Display live the Temperature graph
void liveTemperature () 
{ 
    // reset the Min / Max / Actual Temperature area
    stroke (240); fill (240);
    rect (0, 0, 270, 100);
    
    // print the Min / Max / Actual Temperature
    stroke (0); fill(0); textSize (14);
    text ("Temperature is", 15, 30);
    text (tempCelsius, 120, 30);
    
    text ("Minimum Temperature is", 15, 50);
    text (minTemperature, 187, 50);
    
    text ("Maximum Temperature is", 15, 70);
    text (maxTemperature, 195, 70);
    
    if (xTemp > 680) // if the temperature graph goes out of the canvas, we reset the graph part
    {
        TemperatureAxes();
    }
    
    // print a new column for the actual temperature
    stroke (255, 40, 40); fill (255, 40, 40);
    yTemp = 320 - (tempCelsius * 5);
    line ((int)xTemp, (int)yTemp, (int)xTemp, 320);
    ellipse ((int)xTemp, (int)yTemp, 2, 2);  
    
    xTemp += 5; // the next x coordinate of the temperature graph will be 5 pixels away
}

void liveLight () 
{
    // reset the Min / Max / Actual Light Intensity area
    stroke (240); fill (240);
    rect (0, 0, 270, 100);
    
    // print the Min / Max / Actual Light Intensity
    stroke (0); fill(0); textSize (14);
    text ("Light Intensity is", 15, 30);
    text (lightIntensity, 130, 30);
    
    text ("Minimum Intensity is", 15, 50);
    text (minLightIntensity, 160, 50);
    
    text ("Maximum Intensity is", 15, 70);
    text (maxLightIntensity, 160, 70);
    
    if (xLight > 680) // if the Light Intensity graph goes out of the canvas, we reset the graph part
    {
        LightAxes();
    }
    
    // print a new column for the actual Light Intensity
    stroke (255, 40, 40); fill (255, 40, 40);
    yLight = 320 - (lightIntensity/100 * 20);
    line ((int)xLight, (int)yLight, (int)xLight, 320);
    ellipse ((int)xLight, (int)yLight, 2, 2);  
    
    xLight += 5; // the next x coordinate of the Light Intensity graph will be 5 pixels away
}

void liveAcceleration () 
{
    // reset the Acceleration area
    stroke (240); fill (240);
    rect (0, 0, 270, 100);
    
    // compute acceleration
    acceleration = sqrt (XAcc * XAcc + YAcc * YAcc + ZAcc * ZAcc);
    
    // print the Acceleration
    stroke (0); fill(0); textSize (14);
    text ("Current acceleration", 15, 30);
    text (acceleration, 160, 30);
    
    text ("X acceleration", 15, 50);
    text (XAcc, 120, 50);
    
    text ("Y acceleration", 15, 70);
    text (YAcc, 120, 70);
    
    text ("Z acceleration", 15, 90);
    text (ZAcc, 120, 90);
    
    if (xAcc > 680) // if the Acceleration graph goes out of the canvas, we reset the graph part
    {
        AccAxes();
    }
    
    // print a new column for the actual Acceleration
    stroke (255, 40, 40); fill (255, 40, 40);
    yAcc = 218 - (acceleration/0.5 * 17);
    line ((int)xAcc, (int)yAcc, (int)xAcc, 320);
    ellipse ((int)xAcc, (int)yAcc, 2, 2);  
    
    xAcc += 5; // the next x coordinate of the Acceleration graph will be 5 pixels away
} 

// This functions repeats continously
void draw () 
{
   // If we can read something from the port
   if (myPort != null) 
   {
      if (myPort.available() > 0) 
      {
         int caseID = read();
         
         // Switch between different applications
         switch (caseID) 
         {
            case 0: { // 0 = Engduino is OFF
                // Set background colour to grey
                stroke(240); fill(240);
                rect (0, 0, 700, 350); 
                
                // Show that Engduino is turned off
                stroke (0); fill(0); textSize (20);
                text ("Engduino is turned off", 50, 50);
                break;
            }
            
            case 1: { // 1 = temperature graph
                liveTemperature ();
                
                break;
            }
            
            case 2: { // 2 = light graph
                liveLight ();
                
                break;
            }
            
            case 3: { // 3 = acceleration graph
                liveAcceleration ();
                
                break;
            }
         }           
      }
   }
   else println("No port found. Please, turn on your Engduino and restart the Processing IDE");
}