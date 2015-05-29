/*  This file is not needed; it's just an
 *  example of how to use the drawSpiral() method.
 *  Note that the drawing is done relative to the width
 *  and height of the window; try adjusting them!
 */

void setup() {
  size(500,500); 
}

void draw() {
  background(255);
  drawSpiral("genetic_data.txt", "genetic_colormap_color.txt");
  // Uncomment the line below to save the spiral as an image.
  // save("my_spiral.png");exit();
}
