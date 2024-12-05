$fa = 1;
$fs = 0.4;

wall_thickness = 5;
box_length = 210 + 2 * wall_thickness; // 210 for power brick, inside
box_width = 155; // includes wall thickness, as prisma smart stands on this
box_height = 115 + 2 * wall_thickness; // for anker, inside

box_length_nw = 210;
box_width_nw = 155 - 2 * wall_thickness;
box_height_nw = 115;

cord_radius = 7.5;
cord_distance_side = 25;
cord_distance_top = 20;

anker_length = 79;
anker_width = 61;

difference() {
    // main body
    cube([box_width, box_length, box_height], center = true);
    
    // cut the huge center out
    translate([-box_width / 2 + wall_thickness, -box_length / 2 + wall_thickness, -box_height_nw / 2]) {
        linear_extrude(height = box_height) {
            square([box_width_nw, box_length_nw]);
        }
    }

    // circle for power
    rotate([0, 90, 0]) {
        translate([box_height_nw/2-cord_radius - cord_distance_top, -box_length_nw/2+cord_radius + cord_distance_side, box_width_nw/2-1]) {
        linear_extrude(height = wall_thickness+100, v = [0, 0, 1])
            circle(cord_radius);
        }
    }
    
    // extrude up from power to place plug
    translate([box_width/2, -box_length_nw/2 + cord_distance_side + cord_radius, -box_height_nw/2 +cord_distance_top + cord_radius])
        linear_extrude(height = box_height_nw)
            square(cord_radius*2, center = true);

    // extrude a bit from bottom for anker placement
    translate([0, box_length_nw/2 - anker_width/2 -2, -box_height_nw/2 -2])
        linear_extrude(height = 2.001)
            square([anker_length, anker_width], center = true);
            
    // extrude usb out ports
    // they are at about 30 / 50 / 70 / 90, 15 width
    
}
