$fa = 1;
$fs = 0.14;

wall_thickness = 5;
box_length = 210 + 2 * wall_thickness; // 210 for power brick, inside
box_width = 155;                       // includes wall thickness, as prisma smart stands on this
box_height = 115 + 2 * wall_thickness; // for anker, inside

box_length_nw = 210;
box_width_nw = 155 - 2 * wall_thickness;
box_height_nw = 115;

cord_radius = 7.5;
cord_distance_side = 25;
cord_distance_top = 20;

anker_length = 79;
anker_width = 61;

usb_width = 15;
usb_height = 10;
usb_port_1 = 30;
usb_port_next = 20;

air_vent_hole_radius = 5;
air_vent_hole_distance = 30;
air_vent_side_distance = 30;
air_vent_top_distance = 30;

difference()
{
	// main body
	roundedcube([ box_width, box_length, box_height ], center = true);

	// cut the huge center out
	translate([ -box_width / 2 + wall_thickness, -box_length / 2 + wall_thickness, -box_height_nw / 2 ])
	{
		linear_extrude(height = box_height)
		{
			square([ box_width_nw, box_length_nw ]);
		}
	}

	// circular thing for power cord
	rotate([ 90, 0, 0 ])
	translate([
		-box_width / 2 + cord_radius + cord_distance_side, -box_height_nw / 2 + cord_radius / 2 + cord_distance_top,
		box_length / 2 - 5.5
	])
	linear_extrude(height = wall_thickness + 1, v = [ 0, 0, 1 ]) circle(cord_radius);

	// extrude up from power to place plug
	translate([
		-box_width / 2 + cord_distance_side + cord_radius, -box_length / 2,
		-box_height_nw / 2 + cord_distance_top + cord_radius / 2
	])
	linear_extrude(height = box_height_nw) square(cord_radius * 2, center = true);

	// extrude a bit from bottom for anker placement
	translate([ box_width_nw / 2 - anker_width / 2 - 2, 0, -box_height_nw / 2 - 2 ])
	linear_extrude(height = 2.001) square([ anker_width, anker_length ], center = true);

	// extrude usb ports
	for (i = [0:3])
	{
		translate([
			box_width_nw / 2 / 2, box_length / 2 - wall_thickness - 1,
			-box_height / 2 + wall_thickness + usb_port_1 - usb_height / 2 + i *
			usb_port_next
		])
		linear_extrude(height = usb_height, v = [ 0, 0, 1 ]) square([ usb_width, wall_thickness * 2 ]);
	}

	for (i = [0:5])
	{
		for (j = [0:2])
		{
			translate([
				box_width / 2 - 15, -box_width_nw / 2 + i * air_vent_hole_distance + 10, 25 - j * air_vent_hole_distance
			])
			rotate([ 0, 60, -30 ])
			linear_extrude(height = wall_thickness + 30) circle(r = air_vent_hole_radius);
			translate([
				-box_width / 2 - 15, -box_width_nw / 2 + 0 + i * air_vent_hole_distance - 10, 45 - j *
				air_vent_hole_distance
			])
			rotate([ 0, 120, 30 ])
			linear_extrude(height = wall_thickness + 30) circle(r = air_vent_hole_radius);
		}
	}
	// tolle box
	translate([0, box_length/2-wall_thickness+2, 30])
	rotate([90, 0, 180])
	linear_extrude(height = 5)
	text(text = "tolle box");
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
