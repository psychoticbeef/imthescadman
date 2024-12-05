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

breathing_height = 10;
breathing_width = box_length_nw - 2*20;
breathing_whole_offset = 30;
breathing_whole_distance = 30;
airvent_close_width = 10;
airvent_sections = 4;
airvent_open_width = (breathing_width - ((airvent_sections - 1)*airvent_close_width)) / airvent_sections ;

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
    
    // breathing holes
for (i = [0 : 2]) {
    rotate([0, 0, 90])
        translate([0, -box_width_nw/2-2.5, -box_height_nw/2+breathing_whole_offset+i*breathing_whole_distance])
            linear_extrude(height = breathing_height, v = [0, 0, 1])
            square([breathing_width, wall_thickness*2], center = true);
            }
}

// tolle box
rotate([90, 0, 180])
translate([0, 0, box_length/2+0])
text(text = "tolle box");

for (i = [-1 : 1]) {
translate([box_width/2 - wall_thickness, breathing_width/4*i, -box_height/2])
cube([wall_thickness, wall_thickness, box_height]);
}