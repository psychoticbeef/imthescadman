$fa = 1;
$fs = 0.14;

borehole_diameter = 4.5;

difference() {
    union() {
        import("vigor167_wallmount_centered.stl");
    }
    translate([-58, 7.5, 0])
    cylinder(h = 20, r=borehole_diameter/2, center = true);
    translate([58, 7.5, 0])
    cylinder(h = 20, r=borehole_diameter/2, center = true);
}

