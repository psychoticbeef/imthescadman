// Parameters
part_width = 50;          // Width of the entire part
thickness_a_c = 5;        // Thickness of parts A and C
diameter_b = 40;          // Diameter of the mask holder (B)
hose_diameter = 18;       // Diameter of the hose for A
support_spacing = 80;     // Distance between the two supports (C)
bed_angle = 90;           // Angle for bed attachment, default is 90 degrees (right angle)

// Main Assembly
module cpap_holder() {
    hose_holder();
    mask_holder();
    supports();
}

// A: Hose Holder
module hose_holder() {
    translate([-part_width / 2, -thickness_a_c / 2, 0])
        difference() {
            cube([part_width, thickness_a_c, thickness_a_c * 2]);
            translate([(part_width - hose_diameter) / 2, -thickness_a_c / 2, 0])
                cylinder(h=thickness_a_c * 2, d=hose_diameter, center=true);
        }
}

// B: Mask Holder
module mask_holder() {
    translate([0, support_spacing / 2 + thickness_a_c, thickness_a_c * 2])
        rotate([0, bed_angle, 0])
            cylinder(h=thickness_a_c, d=diameter_b, center=true);
}

// C: Support Structure
module supports() {
    for (y = [-support_spacing / 2, support_spacing / 2]) {
        translate([0, y, 0])
            rotate([0, bed_angle, 0])
                cube([thickness_a_c, thickness_a_c, part_width], center=true);
    }
}

// Render the CPAP Holder
cpap_holder();