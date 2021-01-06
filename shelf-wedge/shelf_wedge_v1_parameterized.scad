// Customize here
depth = 20;
width = 70;

// how thick are edges and base
thickness = 3;
edge_height = 10;

screw_diameter = 5;

// how much should the base be lifted, before additional angle
// (should not be less than thickness)
lift = 20;

// how much additional height should taller end add?
wedge_depth = 3;


// calculated params
outer_depth = depth + thickness*2;
outer_width = width + thickness*2;
base_height = lift;


/*color("Wheat") linear_extrude(height=100){
    square([depth, width], true);
}*/

color("red") {
    union() {
        difference() {
            translate([0,0,base_height]) linear_extrude(height=edge_height,convexity=10){
                difference() {
                    square([outer_depth, outer_width], true);
                    square([depth, width], true);
                    translate([0,outer_width/2*-1,0]) square([depth, width], true);
                }
            }
            //translate([outer_depth/2,0,base_height+(edge_height/2)]) rotate([0,90,0]) 
              //  cylinder(outer_depth, screw_diameter/2, screw_diameter/2, true,$fn=100);
        }
        linear_extrude(height=base_height){
            square([outer_depth, outer_width], true);
        }
        
        triangle_points = [[0,0],[0,outer_width],[wedge_depth,outer_width]];
        triangle_paths = [[0,1,2]];

        translate([outer_depth/2*-1,outer_width/2*-1,0]) rotate([0,90,0]) linear_extrude(height=outer_depth) {
            polygon(triangle_points,triangle_paths,10);
        }
    }
}



