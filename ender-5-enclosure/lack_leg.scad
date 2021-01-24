// parameters for the lack leg
inner = 45;   // inner width of leg
outer = 50.7; // outer width of leg
bcr = 2;    // bottom corner radius (y-z and x-z planes) of the lack leg
cr = 2;       // corner radius of main lack leg corners (x-y plane)

epsilon = 0.001; // hack to fix overlapping points

// defines the boundary between the leg joining interface and the main body
baseoffset = 5;

// Draw the leg above the insert for scale comparison
lack_leg();

// A leg for an Ikea Lack table
module lack_leg() {
    // outer width is 50.6-50.7 mm on each side
    h = 398;      // leg height
    inner = 45;   // inner width of leg
    outer = 50.7; // outer width of leg
    bcr = 2;      // bottom corner radius (y-z and x-z planes) of the lack leg
    cr = 2;       // corner radius of main lack leg corners (x-y plane)

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

        // centre hole at top
        translate([0,0,h-20]) cylinder(d=4, h=21, $fn=36);
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