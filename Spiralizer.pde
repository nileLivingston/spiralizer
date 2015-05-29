/*
  ABOUT:
  This code generates a visualization of sequence data
  using colored circles plotted along an Archimedean spiral.
  
  Inspired by Martin Krzywinski's "Pi on a spiral":
  http://fineartamerica.com/profiles/martin-krzywinski.html
  
  Special thanks to Carolina Jaramillo, whose school project
  introduced me to this method.

  Code by Nile Livingston (c) 2015
  
  USAGE:
  You'll need three things:
    -A Processing environment (duh)
    -A data file (.txt) consisting of an sequence of characters (no delimiters, spaces, etc).
    -A colormap file (.txt), which is composed of comma-separated lines of the following format:
       c,r,g,b
     where c is a character, and r,g,b are the red, green, 
     and blue values (respectively) of the color to be associated with c.
     
  Then, it's as simple as the following method call in your draw() method:
    drawSpiral(data_file_path, colormap_file_path);
  where both arguments are Strings (again, duh).
  
  This visualization is best for sequence data with thousands or tens of thousands of elements.
  Much more or less produces a lackluster result.
*/

// A temporary data structure used for associating chars and colors.
class ColorMap {
  
  // The ith elements of each array are associated with one another.
  protected String chars;
  protected color[] colors;
  
  // Parses the file and stores char-color associations.
  public ColorMap(String map_path) {
    String[] lines = loadStrings(map_path);
    chars = "";
    colors = new color[lines.length];
    for (int i = 0; i < lines.length; i++) {
      String[] line = split(lines[i], ',');
      chars += line[0].charAt(0);
      colors[i] = color(int(line[1]), int(line[2]), int(line[3]));
    }
  }  
  
  // Get the color associated with char c.
  public color getColor(char c) {
    int i = chars.indexOf(c);
    return colors[i];
  }
}

// Get the color array corresponding to the data sequence.
color[] getColorSequence(String data_path, String map_path) {
  String bases = loadStrings(data_path)[0];
  ColorMap map = new ColorMap(map_path);
  color[] output = new color[bases.length()];
  for (int i = 0; i < bases.length(); i++) {
    output[i] = map.getColor(bases.charAt(i));  
  }
  return output;
}


/*  Draw the visualization using sequence data from
 *  data_path and using the coloring specified by the file
 *  at colormap_path.
 */
void drawSpiral(String data_path, String colormap_path) {
  noStroke();
  // Get the colors corresponding to the data.
  color[] colors = getColorSequence(data_path, colormap_path);
  
  // Polar coordinates.
  float theta = 0; 
  float r;
  // Cartesian coordinates.
  float x;
  float y;
  // Parameters for Archimedean spiral.
  // a was tuned by eye to make different sizes work out.
  // b is defined dynamically, so that entire circle is in frame.
  float a = 5;  
  float b = sqrt((1/float(colors.length))*((width/2.5)*(width/2.5)))/PI;  
  // Gap between concentric spirals.
  float span = TWO_PI*b;
  // Radius of circles on spiral.
  float radius = span/2;
  // theta increment.
  float increment;
  
  // For each data element, plot its corresponding circle.
  for (int i = 0; i < colors.length; i++) {
    // Compute polar coordinates.
    r = a + (b*theta);
    // Convert polar to Cartesian.
    x = r * cos(theta);
    y = r * sin(theta);
    // Get the ith color.
    fill(colors[i]);
    // Draw the circle.
    ellipse((width/2) + x, (height/2) + y, 2*radius, 2*radius);
    // Increment theta such that next circle is equidistant.
    theta += (2*radius)/r;
  }
}
