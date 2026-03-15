use <m4_countersunk.scad>;

difference() {
    translate([-7, -7, -0.1])
    cube([14, 14, 12.05]);
    countersunk_bolt("M6", [0, 0, 0], [0, 0, 0], 12);
}