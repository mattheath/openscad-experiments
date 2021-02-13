include <Round-Anything/polyround.scad>
use <threadlib/threadlib.scad>

// $fn=30;

handle();

module handle() {
    difference() {
        rotate_extrude(angle=360, convexity=10) {
            difference() {
                polygon(polyRound([
                    [0,0,0],
                    [-30,37.5,0],
                    [0,54,50],
                    [50,37.5,18],
                    [14,20,25],
                    [14,0,0],
                ], $fn));

                // shape extends beyond X axis to give proper curvature
                // truncate this before rotate extrude
                maskX();
            }
        }

        // tap an M6 thread to accept a threaded rod
        tap("M6", turns=20);
    }
}

module maskX() {
    translate([-6000,-3000]) square([6000,6000]);
}
