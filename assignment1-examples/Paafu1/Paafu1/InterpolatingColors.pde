// color mapping

// tabular data
// length/size/angle encodings
// derived data


// This sketch compares color interpolation in RGB space vs. color interpolation in the perceptually
// uniform Lab color space.  Starting with the example of using lerpColor provided in the processing docs
// at https://processing.org/reference/lerpColor_.html the example was first changed to draw the rectangular
// colored swatches in a loop so that we can see more variation in the color across 10 steps.  Then, a
// second row of swatches was added.  The top row interpolates between the "from" and "to" colors using
// normal linear interpolation in rgb space.  The bottom row converts each color to Lab space, then 
// linearly interpolates between the L, a, and b parameters, then converts the resulting color in Lab
// space back to rgb space so that it can be drawn on the screen.  Notice, this avoids the "mud" that often
// arises when blending between rgb colors, AND the result is generally much better for data visualization
// as we perceive the color change from one step to the next as an equal change in color.

// int nSwatches = 10;

// void setup() {
//   size(520,200);
// }

// void draw() {
//   background(51);
//   stroke(255);
//   color from = color(204, 102, 0);
//   color to = color(0, 102, 153);

//   for (int i=0; i<=nSwatches; i++) {
//     float amt = (float)i / (float)nSwatches;
//     color interpCol = lerpColor(from, to, amt);
//     fill(interpCol);
//     rect(40 + 40*i, 40, 40, 40);
//   }
  
//   for (int i=0; i<=nSwatches; i++) {
//     float amt = (float)i / (float)nSwatches;
//     color interpCol = lerpColorLab(from, to, amt);
//     fill(interpCol);
//     rect(40 + 40*i, 120, 40, 40);
//   }  
// }
