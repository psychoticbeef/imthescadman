epsilon = 0.001;
tolerance = 0.01;

height = 8.1;
side = 60;
hole = 51.8;

notch_thickness = 2;
notch_length = 5;
notch_width = 1.5;

$fa = 1.0;
$fs = 0.14;

difference()
{
	cube([ side, side, height ], center = true);
	translate([ 0, 0, -height ])
	linear_extrude(height = 3 * height) circle(d = hole + tolerance);
    translate([ 0, -hole/2 - notch_thickness/3, -height/2 - epsilon ])
    linear_extrude(height = notch_thickness + epsilon) square([notch_length, notch_width], center = true);
}

module notchedCircle(x, y, z, notch_width, notch_height, notch_depth, circle_diameter, circle_thickness) {
    epsilonN = 0.001;
    translate([x, y, z])
    	linear_extrude(height = 3 * height) circle(d = hole + tolerance);
    linear_extrude(height = notch_thickness + epsilon) square([notch_length, notch_width]);
}