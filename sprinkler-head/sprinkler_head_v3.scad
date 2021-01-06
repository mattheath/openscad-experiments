
face_diameter = 55;
funnel_height = 30;
spout_overlap = 20;

face_angle = 30; // zero for a flat face

ring_height = 1;
face_height = 1;

wall = 1.6; // 4 walls on 0.4mm nozzle
fn = 360; // circle resolution
n=5;

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
            holed = 2;
            r = face_diameter/2;
            circle(r=r, $fn=fn);
            
            // centre hole
            circle(d=holed, $fn=fn/10);
            
            // hiding two outer rings of holes
            /*// ring 1
            for(i = [1 : 6])
                   rotate(i * 60)
                        translate([0, r/3, 0])
                            circle(d=holed, $fn=fn/10);

            // ring 2
            for(i = [1 : 11])
                   rotate(i * (360/11))
                        translate([0, 2 * r/3, 0])
                            circle(d=holed, $fn=fn/10);*/
            
            // ring 1
            for(i = [1 : 9])
                   rotate(i * (360/9))
                        translate([0, r/5, 0])
                            circle(d=holed, $fn=fn/10);
            
            // and instead we have fibbonaci spirals
            for(a = [0:n]) {
                rotate(360/n*a) golden_circs(1, 8, 24);
            }
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


function fibonacci(nth) = 
    nth == 0 || nth == 1 ? nth : (
        fibonacci(nth - 1) + fibonacci(nth - 2)
    );


module inverse_sector_points(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = 360 / fn;
/*
    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) //[for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );
        
    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
  */  
    
    //step2 = step*2 * -1;
    echo("step",step);
    
    p2 = concat([],
        [for(a = [angles[0] : step : angles[1]])
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );
    
    for (p = p2)
        color("red") translate(p) circle(d=2.5, $fn=20);
        
    //color("red") polygon(p2);
}


module golden_circs(from, to, fn = 48) {
    if(from <= to) {
        f1 = fibonacci(from);
        f2 = fibonacci(from + 1);

        //arc_segments = from/(total*5) * fn;
        
        /*if (from < 8) {
            arc2(f1, [0, 90], 1);
        } else if (from < 6) {
            arc2(f1, [0, 90], 2);
        } else {
            arc2(f1, [0, 90], fn);
        }*/
        
        if (from > 6) {
            arc2(f1, [0, 90], fn);
        }
        

        offset = f2 - f1;

        translate([0, -offset, 0]) rotate(90)
            golden_circs(from + 1, to, fn);
    }
}

module arc2(radius, angles, fn = 24) {
    /*difference() {
        inverse_sector_points(radius + width, angles, fn);
        inverse_sector_points(radius, angles, fn);
    }*/
    
    inverse_sector_points(radius, angles, fn);
} 


module arc(radius, angles, width = 1, fn = 24) {
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
} 

module golden_spiral(from, to, thickness) {
    echo("from:", from, "to:", to);
    if(from <= to) {
        f1 = fibonacci(from);
        f2 = fibonacci(from + 1);

        arc(f1, [0, 90], thickness, 48);

        offset = f2 - f1;

        translate([0, -offset, 0]) rotate(90)
            golden_spiral(from + 1, to, thickness);
    }
}

module sector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );
        
    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
    
    //color("red") polygon(points);
}
