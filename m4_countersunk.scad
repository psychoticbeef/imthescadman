// Countersunk Bolt with Selectable Sizes (ISO 10642, No Thread)

// Dictionary of screw sizes and their parameters
screw_specs = [
    ["M3", 3, 6.0, 1.65],  // [Name, Shaft Diameter, Head Diameter, Head Height]
    ["M4", 4, 8.4, 2.2],
    ["M5", 5, 10.4, 2.5],
    ["M6", 6, 12.4, 3.0]
];

// Function to get parameters for a given screw type
function get_screw_spec(type) =
    let(specs = [for (s = screw_specs) if (s[0] == type) s],
        spec = len(specs) > 0 ? specs[0] : undef)
    spec == undef ? assert(false, str("Error: Unknown screw type '", type, "'. Available types: M3, M4, M5, M6")) : spec;

module countersunk_bolt(type = "M4", position = [0, 0, 0], orientation = [0, 0, 0], total_length = 10) {
    // Get parameters based on type
    spec = get_screw_spec(type);
    shaft_diameter = spec[1];
    head_diameter = spec[2];
    head_height = spec[3];
    shaft_length = max(0, total_length - head_height); // Ensure non-negative shaft length

    translate(position) rotate(orientation)
    render() difference() {
        union() {
            // Shaft (adjusted so total bolt length matches input length)
            cylinder(h=shaft_length, d=shaft_diameter, $fn=100);
            
            // Corrected Countersunk Head Orientation
            translate([0,0,shaft_length])
                cylinder(h=head_height, d1=shaft_diameter, d2=head_diameter, $fn=100);
        }
    }
}
