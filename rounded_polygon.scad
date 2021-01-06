include <Round-Anything/polyround.scad>
include <Round-Anything/MinkowskiRound.scad>

$fn=100;

translate([200,0,0]) 
rotate_extrude(angle=360, convexity=2)
    translate([20,0,0]) polygon(polyRound([
        [0,0,10],
        [0,140,10],
        [20,90,10],
        [50,110,10],
        [15,40,50],
        [30,0,5],
    ], 20));

// triangle with diagonal rounded square infill pattern
l = 50;
h = 100;
translate([150,150])
rotate([0,90,0]) linear_extrude(height=10) shell2d(-5) {
    polygon(polyRound([
        [0,0,3],
        [l, 0, 3],
        [0, h, 4],
    ], 20));
    translate([l/3, h/3-2]) gridpattern(memberW = 5, sqW = 15);
}

// borrowed from Kurt Hutten
// https://github.com/Irev-Dev/Round-Anything/blob/297a7ce5dc2eef33a84a5ad02487cbc985b403fc/roundAnythingExamples.scad#L224-L231
module gridpattern(memberW = 4, sqW = 12, iter = 5, r = 3){
	round2d(0, r)
        rotate([0, 0, 45]) translate([-(iter * (sqW + memberW) + memberW) / 2, -(iter * (sqW + memberW) + memberW) / 2]) difference(){
            square([(iter) * (sqW + memberW) + memberW, (iter) * (sqW + memberW) + memberW]);
            for (i = [0:iter - 1], j = [0:iter - 1]){
                translate([i * (sqW + memberW) + memberW, j * (sqW + memberW) + memberW]) square([sqW, sqW]);
            }
	    }
}


// rectangle with diagonal line cutouts
translate([0,300,0])
    linear_extrude(height=5) round2d(0, 1)
        shell2d(-5) {
            round2d(5) square([100,150]);
            translate([0,50,0]) diagonalpattern(maxW = 300);
        }


// another rectangle with diagonal line cutouts
translate([150,300,0])
    linear_extrude(height=5) round2d(0, 1)
        shell2d(-5) {
            round2d(5) square([100,150]);
            translate([0,50,0]) diagonalpattern(maxW = 300, memberW=2, gapW = 5);
        }

module diagonalpattern(memberW = 5, gapW = 5, maxW = 200, a = 45) {
    iter = maxW / (memberW + gapW);

    rotate([0,0,a])
    translate([-maxW/2,-maxW/2])
    difference() {
        square([maxW+memberW, maxW+memberW]);

        for (i = [0:iter - 1], j = [0:iter - 1]){
            translate([i * (memberW + gapW) + memberW,memberW])
                square([gapW, maxW-memberW]);
        }
    }
}

// joining multiple cylinders with internal minkowski rounding
// render fails with unclosed mesh error after 49mins...
// minkowskiRound(0,10,1,[100,100,100])
// union() {
//     cylinder(d=30, h=70);
//     rotate([45,45,0]) cylinder(d=30, h=70);
// }
