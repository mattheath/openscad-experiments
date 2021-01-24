$fn=100;

width = 155;

difference() {
    linear_extrude(height=10, convexity=10) {
        difference() {
            square([width+20,40]);
            translate([10,10,0]) square([width,40]);
        }
    }

    translate([-5,35,5]) rotate([0,90,0]) cylinder(h=width+30, d=3);
}