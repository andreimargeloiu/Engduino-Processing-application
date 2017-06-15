// MODEL DESCRIPTION ------------------------

// There are 4 different layers that combined will result in a christmas tree
// Each layer has a docking hole at the bottom and a cylinder at the top to combine with the other layers
// The head layer has a Engduino docking hole, so you can fit your Engduino with the USB
// The bottom layer also has the bottom docking hole, in case you would want to print more layers in the future and add them

// PRINTING INSTRUCTIONS ---------------------

// All 4 layers should be printed separately in order to combine them finally
// There is a demo with the tree assembled in the middle, to see how it looks assembled
// ATTENTION! When printing the tree, just comment the function makeDemo () to hide the demo tree

// SPECIFICATIONS ---------------------------

// total heigth = 100mm (25mm each layer)
// level (x) diameter = top diameter | bottom diameter
// level (1) diameter = 15 | 50
// level (2) diameter = 15 | 65
// level (3) diameter = 15 | 80
// level (4) diameter = 15 | 95

hLayer = 25;    // layer heigth
dDocking = 15;  // diameter of layers' docking ports
hDocking = 10;  // heigth of layers' docking ports

// make a layer with the bottom docking hole
module makePieceWithBottomHole (heigth, diameterDown, diameterUp) {
    difference () {
        // make the layer
        cylinder(h = heigth, d1 = diameterDown, d2 = diameterUp);
        // make the docking hole
        translate ([0, 0, hDocking/2]) cylinder (h = hDocking, d = dDocking, center = true); 
    }   
}

module makeHead (heigth, diameterDown, diameterUp) {
    difference () {
        // make the piece with the bottom docking hole
        makePieceWithBottomHole (heigth, diameterDown, diameterUp);
        // add Engduino docking hole at the top
        translate ([0, 0, hDocking + 15/2]) cube ([5, 13, 15], true); 
    }
}

module makeLayer (heigth, diameterDown, diameterUp) {
    union () {
         // make layer
         makePieceWithBottomHole (heigth, diameterDown, diameterUp);
         // add the top cylinder to pair with the above layers
         // substract -1 front the dimension to have precision when printing
         translate ([0, 0, hLayer]) cylinder (h = hDocking-1, d = dDocking-1, center = false);
    }
}

module makePieces () {
    // layer 1 = head
    translate ([-100, -100, 0])
        makeHead (hLayer, 50, 15);
     
    // layer 2
    translate ([-100, 100, 0])
        makeLayer (hLayer, 65, 15);
    
    // layer 3
    translate ([100, -100, 0])
        makeLayer (hLayer, 80, 15);
    
    // layer 4
    translate ([100, 100, 0])
        makeLayer (hLayer, 95, 15);
}

module makeDemo () {
    // layer 1 = head
    translate ([0, 0, 3 * hLayer])
        makeHead (hLayer, 50, 15);
     
    // layer 2
    translate ([0, 0, 2 * hLayer])
        makeLayer (hLayer, 65, 15);
    
    // layer 3
    translate ([0, 0, 1 * hLayer])
        makeLayer (hLayer, 80, 15);
    
    // layer 4
    translate ([0, 0, 0 * hLayer])
        makeLayer (hLayer, 95, 15);
}

// make the pieces ready for printing
makePieces ();

// delete this function when you print it 3D
makeDemo();

 
