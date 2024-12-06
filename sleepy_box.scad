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

usb_width = 15;
usb_height = 10;
usb_port_1 = 30;
usb_port_next = 20;

air_vent_hole_radius = 5;
air_vent_hole_distance = 30;
air_vent_side_distance = 30;
air_vent_top_distance = 30;

difference() {
    // main body
    cube([box_width, box_length, box_height], center = true);
    
    // cut the huge center out
    translate([-box_width / 2 + wall_thickness, -box_length / 2 + wall_thickness, -box_height_nw / 2]) {
        linear_extrude(height = box_height) {
            square([box_width_nw, box_length_nw]);
        }
    }
    
    // circular thing for power cord
    rotate([90, 0, 0])
    translate([-box_width/2+cord_radius+cord_distance_side, -box_height_nw/2+cord_radius/2+cord_distance_top, box_length/2-5.5])
        linear_extrude(height = wall_thickness+1, v = [0, 0, 1])
            circle(cord_radius);

    // extrude up from power to place plug
    translate([-box_width/2+cord_distance_side+cord_radius, -box_length/2, -box_height_nw/2+cord_distance_top+cord_radius/2])
        linear_extrude(height = box_height_nw)
            square(cord_radius*2, center = true);
    
    // extrude a bit from bottom for anker placement
    translate([box_width_nw/2 - anker_width/2 - 2, 0, -box_height_nw/2 -2])
        linear_extrude(height = 2.001)
            square([anker_width, anker_length], center = true);

    // extrude usb ports
    for (i = [0:3]) {
        translate([box_width_nw/2/2, box_length/2-wall_thickness-1, -box_height/2+wall_thickness+usb_port_1-usb_height/2 + i*usb_port_next])
            linear_extrude(height = usb_height, v = [0, 0, 1])
            square([usb_width, wall_thickness*2]);    
    }

    for (i = [0:5]) {
        for (j = [0:2]) {
            translate([box_width/2-15, -box_width_nw/2+i*air_vent_hole_distance+10, 25 -j*air_vent_hole_distance])
            rotate([0, 60, -30])
            linear_extrude(height = wall_thickness+30)
            circle(r=air_vent_hole_radius);
            translate([-box_width/2-15, -box_width_nw/2+0+i*air_vent_hole_distance-10, 45 -j*air_vent_hole_distance])
            rotate([0, 120, 30])
            linear_extrude(height = wall_thickness+30)
            circle(r=air_vent_hole_radius);
        }
    }
    //tolle box
    translate([0, box_length/2-wall_thickness-1, 30])
    rotate([90, 0, 180])
    linear_extrude(height = wall_thickness+2)
    text(text = "tolle box");
    
}



