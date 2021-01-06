// Customize here
depth = 15;
width = 70;

screw_plate_enabled = false;

// how thick are edges and base
thickness = 2;
edge_height = 3;

screw_diameter = 7;

// how much should the base be lifted, before additional angle
// (should not be less than thickness)
lift = 1;

// how much additional height should taller end add?
wedge_depth = 3;


// calculated params
outer_depth = depth + thickness*2;
outer_width = width + thickness*2;
base_height = lift;



// offset 43mm @ 1600mm
// additional delta of 3mm @ 800mm


base_width = 1600; // adjacent
offset = 43; // opposite

// opposite/adjacent
slant = atan(offset/base_width);

echo("slant angle", slant);



leg = 3;
ds = (leg-1) * 800;

p1 = ds-width;
p2 = ds;

// tan A = opp/adj
// tan A * adj = opp

p2_offset = tan(slant) * p2;
echo(p2_offset);

p1_offset = tan(slant) * p1;
echo(p1_offset);



















module cylinders(points, diameter, thickness){
    for (p=points){
        translate(p) cylinder(d=diameter, h=thickness, center=true, $fn=100);
    }
}

module flat_plate(points, diameter, thickness, hole_diameter){
    difference(){
        hull() cylinders(points, diameter, thickness);
        cylinders(points, hole_diameter, thickness+1);
    }
}
 /*
module plate(points, diameter, thickness, hole_diameter){
    difference(){
        hull() cylinders(points, diameter, thickness);
        cylinders(points, hole_diameter, thickness+1);
    }
}*/

module plate(width, depth, thickness, corner_radius){
    r = corner_radius;
    points = [[0+r,0+r], [0+r,width-r], [depth-r, width-r], [depth-r,0+r]];
    hull() cylinders(points, corner_radius*2, thickness);
}
 
module bar(length, width, thickness, hole_diameter){
    plate([[0,0,0], [length,0,0]], width, thickness, hole_diameter);
}


/*color("Wheat") difference() {
    translate([0,0,base_height]) linear_extrude(height=300,convexity=10) square([depth, width], true);
        
        // 1st hole
        translate([0,17.25,base_height+25])
              rotate([0,90,0]) cylinder(outer_depth, screw_diameter/2, screw_diameter/2, true,$fn=100);
        translate([0,-17.25,base_height+25])
              rotate([0,90,0]) cylinder(outer_depth, screw_diameter/2, screw_diameter/2, true,$fn=100);
    
    
        // 2nd hole
        translate([0,17.25,base_height+25+150])
              rotate([0,90,0]) cylinder(outer_depth, screw_diameter/2, screw_diameter/2, true,$fn=100);
        translate([0,-17.25,base_height+25+150])
              rotate([0,90,0]) cylinder(outer_depth, screw_diameter/2, screw_diameter/2, true,$fn=100);
    }
  */  


// the center point from the edge of the wood (vertically) of the first hole
hole_vertical_centre_start = 25;

padding = 7;
th = hole_vertical_centre_start-edge_height+screw_diameter/2+padding;
    
td = hole_vertical_centre_start+screw_diameter/2+padding;
    
hole_offset = 17.25;
holegap = hole_offset*2;
hw = holegap+screw_diameter+padding*2;

color([1,0,0,0.5])  {
    union() {
        difference() {
            
            union() {
                // base
                translate([0,0,base_height]) linear_extrude(height=edge_height,convexity=10){
                    difference() {
                        square([outer_depth, outer_width], true);
                        square([depth, width], true);
                        translate([0,outer_width/2*-1,0]) square([depth, width], true);
                    }
                }

                // flat base
                linear_extrude(height=base_height){
                    square([outer_depth, outer_width], true);
                }

                // wedge
                triangle_points = [[0,0],[0,outer_width],[wedge_depth,outer_width]];
                triangle_paths = [[0,1,2]];
                translate([outer_depth/2*-1,outer_width/2*-1,0]) rotate([0,90,0]) linear_extrude(height=outer_depth) {
                    polygon(triangle_points,triangle_paths,10);
                }
        
                
                // back screw plate
                if (screw_plate_enabled) {
                    echo("screw plate added:", screw_plate_enabled);
                    translate([depth/2+thickness/2,hw/2*-1,base_height]) rotate([0,270,0]) plate(hw, td, thickness, 3);
                }
                
            }
            
            // cut out screw holes
            translate([outer_depth/2,hole_offset,base_height+25])
              rotate([0,90,0]) cylinder(outer_depth, screw_diameter/2+0.5, screw_diameter/2+1, true,$fn=100);
            translate([outer_depth/2,hole_offset*-1,base_height+25])
              rotate([0,90,0]) cylinder(outer_depth, screw_diameter/2+0.5, screw_diameter/2+1, true,$fn=100);
            
        }
        
        
        
        
    }
}




/*color([1,0,0,0.5]) translate([0,0,base_height+edge_height]) linear_extrude(height=th){
            translate([depth/2+thickness/2,0,0]) square([thickness, hw], true);
        }*/