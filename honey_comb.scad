module honeycomb_pattern(start, end, side_length, wall_thickness, exclusions = []) {
    hex_height = sqrt(3) * side_length;      // Vertical height of hex
    hex_width = 2 * side_length;             // Full width of hex
    half_height = hex_height / 2;
    half_width = side_length;
    offset_correction = 3 * wall_thickness;  // Adjust overlap by comb thickness

    // Loop to generate hexagons in a staggered honeycomb arrangement
    for (y = [start[1] : (hex_height - offset_correction) : end[1]]) {
        for (x = [start[0] : (1.5 * side_length - offset_correction) : end[0]]) {
            // Apply staggered offsets
            x_offset = (floor(y / hex_height) % 2 == 0) ? (half_width - offset_correction) : 0;
            hex_center = [x + x_offset, y + half_height - offset_correction];

            // Check if hex overlaps exclusion zones
            visible = true;
            for (rect = exclusions) {
                if (inside_rectangle(hex_center, rect)) {
                    visible = false;
                }
            }

            if (visible) {
                draw_honeycomb_hex(hex_center, side_length, wall_thickness);
            }
        }
    }
}

// Function to check if a point is inside a rectangle
function inside_rectangle(point, rect) =
    point[0] >= rect[0] && point[0] <= rect[2] &&
    point[1] >= rect[1] && point[1] <= rect[3];

// Draw a rotated hexagon with thinner walls for honeycomb
module draw_honeycomb_hex(center, side_length, wall_thickness) {
    translate(center)
        rotate(30)  // Rotate hexagon to match honeycomb layout
        difference() {
            polygon(points = hexagon_points(side_length));
            polygon(points = hexagon_points(side_length - wall_thickness));
        }
}

// Generate hexagon vertices
function hexagon_points(side_length) = [
    [cos(0) * side_length, sin(0) * side_length],
    [cos(60) * side_length, sin(60) * side_length],
    [cos(120) * side_length, sin(120) * side_length],
    [cos(180) * side_length, sin(180) * side_length],
    [cos(240) * side_length, sin(240) * side_length],
    [cos(300) * side_length, sin(300) * side_length]
];

// Example usage
honeycomb_pattern(
    [0, 0], [100, 100], 
    side_length = 10, 
    wall_thickness = 1, 
    exclusions = [[20, 20, 40, 40], [50, 50, 60, 60]]
);