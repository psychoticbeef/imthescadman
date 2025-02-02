// Basic shape of an AppleTV. Excluding the chamfered base

print_tolerance = 0.0;

base_size = 93.24 + print_tolerance; // Length of the sides of the square
corner_offset = 27.14;               // Maximum offset for the corner curve
extrude_height = 31;

// Define the points for one corner in clockwise order
corner_points = [
	[ 0.00, 0.00 ],   [ 2.00, 0.01 ],   [ 4.00, 0.03 ],   [ 6.00, 0.09 ],   [ 7.99, 0.23 ],   [ 9.98, 0.49 ],
	[ 11.93, 0.89 ],  [ 13.85, 1.46 ],  [ 15.71, 2.21 ],  [ 17.47, 3.15 ],  [ 19.13, 4.27 ],  [ 20.66, 5.55 ],
	[ 22.05, 6.99 ],  [ 23.27, 8.57 ],  [ 24.33, 10.27 ], [ 25.21, 12.06 ], [ 25.89, 13.94 ], [ 26.40, 15.87 ],
	[ 26.75, 17.84 ], [ 26.96, 19.83 ], [ 27.07, 21.83 ], [ 27.12, 23.83 ], [ 27.14, 25.83 ]
];

// Function to offset and flip points correctly for each corner
function transform_corner(points, offset_x, offset_y, flip_x = false, flip_y = false) =
    [for (p = points)[(flip_x ? offset_x - p[0] : p[0] + offset_x), (flip_y ? offset_y - p[1] : p[1] + offset_y)]];

// Draw each corner separately for debugging
module corner1()
{
	polygon(points = transform_corner(corner_points, base_size - corner_offset, 0));
}

module corner2()
{
	polygon(points = transform_corner(corner_points, corner_offset, 0, flip_x = true));
}

module corner3()
{
	polygon(points = transform_corner(corner_points, corner_offset, base_size, true, true));
}

module corner4()
{
	polygon(points = transform_corner(corner_points, base_size - corner_offset, base_size, flip_y = true));
}

// Draw each corner and fill the sides separately
module sides_and_corners()
{
	// Fill horizontal and vertical edges between corners
	hull()
	{
	polygon(points = transform_corner(corner_points, base_size - corner_offset, 0));
		//corner1(); // Bottom-right corner
		corner2(); // Bottom-left corner
		corner3(); // Top-left corner
		corner4(); // Top-right corner
	}
}

// Extrude the filled shape down by the specified height
module extruded_shape()
{
	linear_extrude(height = extrude_height)
	{
		sides_and_corners();
	}
}

// Render the extruded shape
extruded_shape();

/*
difference()
{
	translate([ -1.5, -1.5, 0.1 ])
	cube([ 97, 97, 2 ]);
	extruded_shape();
}
*/