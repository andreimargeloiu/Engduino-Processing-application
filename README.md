# 1. Engduino-Processing app

**DESCRIPTION:** The Engduino application takes data through the sensors and shows it in real time using Processing IDE. The program consists of 3 applications which change when the button is pressed.
• Temperature sensor app: Display temperatures between (0 - 40) degrees Celsius in Processing IDE. On Engduino, for each 0.2 degree difference in temperature compared to the initial one, one more light is turned on. The lights are RED for increased temperature and BLUE for decreased temperature.

• Light sensor app: Displays light intensity between (0 – 1200) lux in Processing IDE. On Engduino the lights are turned on in L shape.

• Acceleration sensor app: Displays acceleration between (-1 – 1) in Processing IDE. On Engduino the lights are turned on in C shape.
The data is transferred through the serial port of a Laptop/PC. Processing IDE is connected to the same serial port to receive information. Engduino transmits a marker for each application ('OFF ", "temp ", "light ", "acc "), so that Processing IDE knows when to change between applications. Switching between the three types of applications in Processing IDE depending on the first string received. Processing application interprets the markers and change the graph accordingly.

### **HOW TO SET-UP:**
1. Open Arduino-Engduino IDE (can be downloaded from www.engduino.org)
2. In Engduino IDE open ‘Engduino.ino’ located in Engduino Processing application/ Engduino/ .
3. Upload the code to Engduino
4. Open Processing IDE (can be download from www.processing.org)
5. In the Processing IDE, open ‘Processing.pde’ located in Engduino Processing application /Processing/ .
6. Connect the Engduino to a serial port
7. Start Engduino
8. Run the code in Processing IDE
9. Play with the application using the button like in the description.

# 2. OpenSCAD app

**DESCRIPTION:** This OpenSCAD represents a Christmas tree that can be used as an Engduino stand. There are 4 different layers that combined will result in a Christmas tree. Each layer has a docking hole at the bottom and a cylinder at the top to combine with the other layers. The head layer has a Engduino docking hole, so you can fit your Engduino with the USB. The bottom layer also has the bottom docking hole, in case you would want to print more layers in the future and add them

PRINTING INSTRUCTIONS: All 4 layers should be printed separately in order to combine them finally. There is a demo with the tree assembled in the middle, to see how it looks assembled. When printing the tree, just comment the function makeDemo() to hide the demo tree.

MODEL SPECIFICATIONS:**
• total heigth = 100mm (25mm each layer)
• level (x) diameter = top diameter | bottom diameter
• level (1) diameter = 15 | 50
• level (2) diameter = 15 | 65
• level (3) diameter = 15 | 80
• level (4) diameter = 15 | 95


