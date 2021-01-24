
echo("preview?");
echo($preview); 

// main variables
uplift = 150;       // height of main body of leg extension
screw_diameter = 3; // diameter of screw body through leg wall into insert

inner_cutout = 39; // 39 gives us 3mm on each side
inner_cutout_height = 12;

// parameters for the lack leg (unlikely to need changing)
inner = 45;   // inner width of leg
outer = 50.7; // outer width of leg
bcr = 2;    // bottom corner radius (y-z and x-z planes) of the lack leg
cr = 2;       // corner radius of main lack leg corners (x-y plane)

epsilon = 0.001; // hack to fix overlapping points
show_lack = false;

// defines the boundary between the leg joining interface and the main body
baseoffset = 5;



// The printable leg insert
color([1,0,0,0.5]) {
    leg_insert(outer, uplift);
}


// Draw the leg above the insert for scale comparison
if (show_lack) {
    %translate([0,0,uplift])
        lackleg();
}


module leg_insert(outer, uplift) {
    difference() {
        union() {
            // the interface that inserts into leg
            translate([0,0,uplift-baseoffset])
                leg_interface(height=20);

            // two screw hole supports at 90deg to each other
            screwdelta = inner/2 - 2 - epsilon;
            translate([screwdelta,0,uplift])
                screwsupport(thickness=4);
            rotate([0,0,90])
                translate([screwdelta,0,uplift])
                    screwsupport(thickness=4);

            // extend leg downwards specified height
            plate(outer, outer, uplift-baseoffset, cr);
        }
        
        // cut out center to reduce print time
        if (inner_cutout > 0) {
            translate([0,0,-epsilon])
                cube([inner_cutout ,inner_cutout ,inner_cutout_height*2+epsilon], center=true);
        }
    }
}

module leg_interface(height=15) {
    insertheight = height + baseoffset;
    difference() {
        // start with a simple cuboid the same width as the lack leg
        plate(outer, outer, insertheight, cr-0.01);

        // chop outer edges at top of corner curve to fix clipping
        translate([0,0,insertheight+bcr+baseoffset]) {
            difference() {
                cube([outer+10,outer+10,insertheight*2], center=true);
                cube([outer-2,outer-2,insertheight*2+2], center=true);
            }
        }
        
        // minus the leg body (shell)
        translate([0,0,baseoffset])
            lackleg();
    }
}

module screwsupport(thickness=4, holeposition=30) {
    w = 30; // outer width (edge to edge)
    h = holeposition; // z offset from baseline to screw hole location height (from centre of circles at bottom)
    d = screw_diameter + 6; // diameter of circles that surround the screw hole to form the support
    r = d/2;
    
    points = [[0,(w-r)/-2,0], [0,(w-r)/2,0], [r+h,0,0]];
    
    rotate([0,-90,0])
    difference() {
        roundedplate(points, d, thickness);

        // cut out screw hole at top
        translate([r+h,0,0]) cylinder(d=screw_diameter, h=thickness+20, center=true, $fn=36);
    }
    
}


// A leg for an Ikea Lack table
module lackleg() {
    // outer width is 50.6-50.7 mm on each side
    h = 398; // leg height
    
    // inner cross section is 45mm, some padding for horizontal expansion to ensure fit
    innerw = inner - 0.15; // 
    zcutout = 200; // vertically remove this amount of the core from the bottom
    
    difference() {
        // main leg body
        rounded_base_cuboid(outer,outer,h,bcr);
        
        // minus outer mask to ensure curved corners
        lackleg_outer_mask(outer-epsilon,outer-epsilon,h);
        
        // minus inner filler (cuboid at base)
        translate([0,0,(zcutout/2)-epsilon]) cube([inner,inner,zcutout+epsilon], center=true);
    }
}

// forms a cuboid with a rounded cuboid removed, to use as a vertical mask
module lackleg_outer_mask(w,d,h) {
    difference() {
        translate([0,0,(h)/2])
            cube([w+20,d+20, h+2], center=true); // 1mm extra top and bottom for clipping
        translate([0,0,-2])
            plate(w,d,h+4,2);
    }
}

module rounded_base_cuboid(w, d, h, cr) {
    union() {
        // main body of cuboid
        translate([0,0,cr-epsilon])
            plate(w,d,h-cr+epsilon,cr);

        // rounded bottom
        translate([-w/2,-d/2,cr])
            hull() {
                translate([0+cr,0+cr,0]) sphere(r=cr,$fn=36);
                translate([w-cr,0+cr,0]) sphere(r=cr,$fn=36);
                translate([0+cr,d-cr,0]) sphere(r=cr,$fn=36);
                translate([w-cr,d-cr,0]) sphere(r=cr,$fn=36);
            }        
    }
}

module plate(width, depth, thickness, corner_radius) {
    points = [
        [corner_radius,corner_radius,0],
        [corner_radius,depth-corner_radius,0],
        [width-corner_radius,corner_radius,0],
        [width-corner_radius,depth-corner_radius,0]
    ];
    d = corner_radius*2;
    translate([-width/2,-depth/2,thickness/2]) roundedplate(points, d, thickness); 
}


module cylinders(points, diameter, thickness){
    for (p=points){
        translate(p) cylinder(d=diameter, h=thickness, center=true, $fn=100);
    }
}

module roundedplate(points, diameter, thickness){
    hull() 
        cylinders(points, diameter, thickness);
}