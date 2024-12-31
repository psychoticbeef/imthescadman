epsilon = 0.001;
tolerance = 0.01;

height = 8.05;
side = 60;
hole = 51.75;

notch_thickness = 2;
notch_length = 5;
notch_width = 1.5;

$fa = 1.0;
$fs = 0.14;

circle_distance = 28;
nuki_bottom_len = 50;
nuki_width = 60;

// first, draw the whole base plate, then remove the key hole and handle, and then remove the notches

// both circles are circle_distance mm apart from bottom to top
// the nuki is about nuki_bottom_len longer than the bottom of the key hole
// so we need: nuki bottom len + circle diameter + circle distance + circle diameter / 2 + a half circle on top, with
// nuki_width at the bottom

/*
difference()
{
    union()
    {
        // nuki bottom + key hole + distance to upper circle:
        height_to_upper_circle_center = nuki_bottom_len + hole + circle_distance + hole / 2;
        cube([ nuki_width, height_to_upper_circle_center, height ]);
        // upper circle:
        translate([ nuki_width / 2, height_to_upper_circle_center, 0 ])
        linear_extrude(height = height) circle(d = nuki_width);
    }
}*/

union()
{
	union()
	{
		difference()
		{
			cube([ side, side, height ], center = true);
			translate([ 0, 0, -height ])
			linear_extrude(height = 3 * height) circle(d = hole + tolerance);
			translate([ 0, -hole / 2 - notch_thickness / 3, -height / 2 - epsilon ])
			linear_extrude(height = notch_thickness + epsilon) square([ notch_length, notch_width ], center = true);
		}
	}
	translate([ 0, -nuki_bottom_len - 5, 0 ])
	cube([ side, nuki_bottom_len, height ], center = true);
}

// notchedCircle(90, 90, 0, notch_width, notch_length, notch_thickness, hole, height);

module notchedCircle(x, y, z, notch_width, notch_height, notch_depth, circle_diameter, circle_thickness)
{
	epsilonN = 0.001;
	translate([ x, y, z ])
	linear_extrude(height = 3 * height) circle(d = hole + tolerance);
	translate([ x, y, z ])
	linear_extrude(height = notch_thickness + epsilon) square([ notch_length, notch_width ]);
}

module roundedcube(size = [ 1, 1, 1 ], center = false, radius = 0.5, apply_to = "all")
{
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [ size, size, size ] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	obj_translate = (center == false) ? [ 0, 0, 0 ] : [ -(size[0] / 2), -(size[1] / 2), -(size[2] / 2) ];

	translate(v = obj_translate)
	{
		hull()
		{
			for (translate_x = [ translate_min, translate_xmax ])
			{
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [ translate_min, translate_ymax ])
				{
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [ translate_min, translate_zmax ])
					{
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [ translate_x, translate_y, translate_z ])
						if ((apply_to == "all") || (apply_to == "xmin" && x_at == "min") ||
						    (apply_to == "xmax" && x_at == "max") || (apply_to == "ymin" && y_at == "min") ||
						    (apply_to == "ymax" && y_at == "max") || (apply_to == "zmin" && z_at == "min") ||
						    (apply_to == "zmax" && z_at == "max"))
						{
							sphere(r = radius);
						}
						else
						{
							rotate
							= (apply_to == "xmin" || apply_to == "xmax" || apply_to == "x")
							      ? [ 0, 90, 0 ]
							      : ((apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [ 90, 90, 0 ]
							                                                                       : [ 0, 0, 0 ]);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true);
						}
					}
				}
			}
		}
	}
}
