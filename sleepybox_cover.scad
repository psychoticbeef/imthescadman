$fa = 1;
$fs = 0.14;

wall_thickness = 5;
box_length = 210 + 2 * wall_thickness; // 210 for power brick, inside
box_width = 155;                       // includes wall thickness, as prisma smart stands on this
box_height = 115 + 2 * wall_thickness; // for anker, inside

cover_hangover = 2;
cover_tolerance = 0.2;

air_vent_hole_radius = 5;
air_vent_hole_distance = 30;
air_vent_side_distance = 30;

box_length_nw = 210;
box_width_nw = 155 - 2 * wall_thickness;
box_height_nw = 115;

magnet_height = 2.1;
surface_above_magnet = 1;
magnet_diameter = 3.1;

difference()
{
	union()
	{
		// main body
		roundedcube([ box_width, box_length + cover_hangover, wall_thickness ]);
		// grooves
		difference()
		{
			translate([ wall_thickness, wall_thickness, wall_thickness - 1 ])
			color([ 0.5, 0.5, 0, 0.5 ]) roundedcube([ box_width_nw, box_length_nw, wall_thickness + 1 ]);
			translate(
			    [ wall_thickness * 2 + cover_tolerance / 2, wall_thickness * 2 + cover_tolerance / 2, wall_thickness ])
			cube([
				box_width_nw - wall_thickness * 2 - cover_tolerance,
				box_length_nw - wall_thickness * 2 - cover_tolerance,
				wall_thickness
			]);
		}
	}
	// air vents
	vent_start_x = 3 * wall_thickness;
	vent_stop_x = box_width - 3 * wall_thickness;
	vent_start_y = box_width + wall_thickness;
	vent_stop_y = box_length - 3 * wall_thickness;

	vent_width = vent_stop_x - vent_start_x;
	vent_length = vent_stop_y - vent_start_y;
	vent_count_w = floor(vent_width / (air_vent_hole_radius * 2 + air_vent_hole_distance));
	vent_count_l = floor(vent_length / (air_vent_hole_radius * 2 + air_vent_hole_distance));

	// correct the start
	vent_real_start_x = ((vent_width - vent_count_w * air_vent_hole_distance) / 2) + (2 * wall_thickness);
	vent_real_start_y =
	    (vent_stop_x - ((vent_length - vent_count_l * air_vent_hole_distance) / 2)) + (4 * wall_thickness);

	for (x = [0:vent_count_w])
	{
		for (y = [0:vent_count_l])
		{
			translate([
				vent_real_start_x + x * (air_vent_hole_distance), vent_real_start_y + y * (air_vent_hole_distance), -10
			])
			rotate([ 30, 30, 0 ])
			linear_extrude(height = wall_thickness + 50) circle(r = air_vent_hole_radius);
		}
	}

	// hole for magnet
    /*
	translate(
	    [ box_width / 2, box_length - 0.5 * wall_thickness, wall_thickness - magnet_height - surface_above_magnet ])
	linear_extrude(height = 2) circle(d = magnet_diameter);
    */
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
