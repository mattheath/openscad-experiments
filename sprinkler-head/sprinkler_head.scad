// Configurable
head_diameter = 55;
funnel_height = 34;
ring_height = 1;
face_height = 1;
spout_overlap = 20;

wall = 1.6; // 4 walls on printer
fn = 360; // circle resolution

// face
linear_extrude(height=face_height,convexity=10)
    difference() {
        holed = 2;
        r = head_diameter/2;
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

// ring between funnel and face
translate([0,0,face_height]) ring(head_diameter, ring_height, wall);

// spout to head shell
funnel_offset = ring_height + face_height;
translate([0,0,funnel_offset]) {
    difference() {
        hull() {
            linear_extrude(height=1,convexity=10) circle(d=head_diameter, $fn=fn);
            translate([0,0,funnel_height]) linear_extrude(height=1,convexity=10) resize([15.5+wall*2,11+wall*2]) circle(d=10, $fn=fn);
        }

        hull() {
            linear_extrude(height=1,convexity=10) circle(d=(head_diameter-(wall*2)), $fn=fn);
            translate([0,0,funnel_height]) linear_extrude(height=1,convexity=10) resize([15.5,11]) circle(d=10, $fn=fn);
        }

        // additional punch throughs to ensure faces render
        translate([0,0,-4]) cylinder(h=5, d=(head_diameter-(wall*2)));
        translate([0,0,funnel_height+1]) linear_extrude(height=5,convexity=10) resize([15.5,11]) circle(d=10, $fn=fn);
    }
}

// spout attachment
// 15.5 x 11 oval
spout_offset = face_height + ring_height + funnel_height+1; // +1 fudge factor as funnel is using hull which is inclusive
translate([0,0,spout_offset]) linear_extrude(height=spout_overlap,convexity=10) {
    difference() {
        resize([15.5+wall*2,11+wall*2]) circle(d=10, $fn=100);
        
        // inner
        resize([15.5,11]) circle(d=10, $fn=100);
    }
}


module flat_ring(outer_diameter, height, wall_thickness) {
    difference() {
        circle(d=outer_diameter, $fn=fn);
        circle(d=outer_diameter-(wall*2), $fn=fn);
    }
}

module ring(outer_diameter, height, wall_thickness) {
    linear_extrude(height=height,convexity=10) flat_ring(outer_diameter, height, wall_thickness);
}

/*
difference () {
    cylinder(h=10, d=diameter + 10);
    cylinder(h=10, d=6);
    translate([0, diameter/2, 0]) {
        cylinder(h=10, d=6);
    }
    rotate (a=120) {
        translate([0, diameter/2, 0]) {
            cylinder(h=10, d=6);
        }  
    }
    rotate (a=-120) {
        translate([0, diameter/2, 0]) {
            cylinder(h=10, d=6);
        }  
    }
}
*/