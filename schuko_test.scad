height = 2;
side = 60;
hole = 40;
epsilon = 0.001;
tolerance = 0.1;

$fa = 1.0;
$fs = 0.14;

difference()
{
	cube([ side, side, height ], center = true);
	translate([ 0, 0, -height ])
	linear_extrude(height = 3 * height) circle(d = hole + tolerance);
}
