// Angled sprinker head for watering can

// Set config options here
face_diameter = 55;
funnel_height = 30;
spout_overlap = 20;
holed = 2.5;     // water hole diameter
face_angle = 45; // zero for a flat face

// probably don't need to change the below
ring_height = 1;
face_height = 1;
wall = 1.6; // 4 walls on printer
fn = 360; // circle resolution


// hide sections for debugging
show_face = true;
show_spout_attachment = true;


module flat_ring(outer_diameter, height, wall_thickness) {
    difference() {
        circle(d=outer_diameter, $fn=fn);
        circle(d=outer_diameter-(wall*2), $fn=fn);
    }
}

module ring(outer_diameter, height, wall_thickness) {
    linear_extrude(height=height,convexity=10) flat_ring(outer_diameter, height, wall_thickness);
}


// face
if (show_face) {
    rotate([face_angle,0,0])
    linear_extrude(height=face_height,convexity=10)
        difference() {
            
            r = face_diameter/2;
            circle(r=r, $fn=fn);
            
            // centre hole
            circle(d=holed, $fn=fn/10);
            
            // ring 1
            for(i = [1 : 6])
                   rotate(i * 60)
                        translate([0, r/3, 0])
                            circle(d=holed, $fn=fn/10);

            // ring 2
            for(i = [1 : 11])
                   rotate(i * (360/11))
                        translate([0, 2 * r/3, 0])
                            circle(d=holed, $fn=fn/10);
        }
}


// ring between funnel and face
rotate([face_angle,0,0]) translate([0,0,face_height]) ring(face_diameter, ring_height, wall);

// spout to head shell
funnel_offset = ring_height + face_height;
funnel_top = funnel_offset + funnel_height;
difference() {
    // outer hull builds funnel shape
    hull() {
        rotate([face_angle,0,0]) translate([0,0,funnel_offset]) linear_extrude(height=1,convexity=10) circle(d=face_diameter, $fn=fn);
        // subtract 1 from top to account for extrusion height
        translate([0,0,funnel_top-1]) linear_extrude(height=1,convexity=10) resize([15.5+wall*2,11+wall*2]) circle(d=10, $fn=fn);
    }
    // inner hull is subtracted to make hollow
    hull() {
        rotate([face_angle,0,0]) translate([0,0,funnel_offset]) linear_extrude(height=1,convexity=10) circle(d=(face_diameter-(wall*2)), $fn=fn);
        // subtract 1 from top to account for extrusion height
        translate([0,0,funnel_top-1]) linear_extrude(height=1,convexity=10) resize([15.5,11]) circle(d=10, $fn=fn);
    }

    // additional punch throughs to ensure bottom faces render
    rotate([face_angle,0,0]) translate([0,0,funnel_offset-1]) cylinder(h=2, d=(face_diameter-(wall*2)));
    // and top end renders (and is hollow)
    translate([0,0,funnel_top-1]) linear_extrude(height=2,convexity=10) resize([15.5,11]) circle(d=10, $fn=fn);
}

// color([1,0,0,0.2]) translate([0,0,funnel_top-1]) linear_extrude(height=2,convexity=10) resize([15.5,11]) circle(d=10, $fn=fn);

// spout attachment
// 15.5 x 11 oval
spout_offset = face_height + ring_height + funnel_height; // +1 fudge factor as funnel is using hull which is inclusive
if (show_spout_attachment) {
    translate([0,0,spout_offset]) linear_extrude(height=spout_overlap,convexity=10) {
        difference() {
            resize([15.5+wall*2,11+wall*2]) circle(d=10, $fn=100);
            
            // inner
            resize([15.5,11]) circle(d=10, $fn=100);
        }
    }
}


