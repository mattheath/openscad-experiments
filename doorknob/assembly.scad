use <threadlib/threadlib.scad>
use <handle.scad>
use <mount.scad>
use <aligner.scad>

$fn = 100;

doorWidth = 35;
mountDepth = 5.5;
separation = doorWidth + mountDepth * 2;

// Threaded rod through center
rodDepth = 20;
rodLength = separation + rodDepth * 2;
echo("Rod Length:", rodLength)
color([0.4,0.4,0.4,0.7]) {
    rotate([90,0,0])
        translate([0,0,-rodLength/2])
            bolt("M6", turns=rodLength);
}

// The (existing) mounting ring on the door
color([0.9,0.9,0.9,0.4]) {
    translate([0,-doorWidth/2,0])
        rotate([90,0,0])
            mount();
    translate([0,doorWidth/2,0])
        rotate([-90,0,0])
            mount();
}

// Threaded plug to support the rod
color([0.1,1,0.5,0.4]) {
    translate([0,-doorWidth/2-4,0])
        rotate([-90,0,0])
            threadedAlignmentPlug();
    translate([0,doorWidth/2+4,0])
        rotate([90,0,0])
            threadedAlignmentPlug();
}

// Two handles pls
color([0.1,1,0.5,0.6]) {
    translate([0,-separation/2,0]) rotate([90,0,0]) handle();
    translate([0,separation/2,0]) rotate([-90,0,0]) handle();
}





echo("separation", separation);