minkowski() {
    %cube([10,10,10]);
    translate([5,5,5]) cube([10,10,10]);
}


translate([50,0,0]) minkowski() {
    cube([10,10,10]);
    translate([5,5,5]) cube([10,10,10]);
}


translate([100,0,0]) minkowski() {
    %cube([10,10,10]);
    translate([5,5,5]) sphere(r=5);
}

translate([150,0,0]) minkowski() {
    cube([10,10,10]);
    translate([5,5,5]) sphere(r=5);
}

translate([100,50,0]) minkowski() {
    %cube([10,10,10]);
    sphere(r=5);
}

translate([150,50,0]) minkowski() {
    cube([10,10,10]);
    sphere(r=5);
}


translate([0,100,0]) {

color("red")   translate([0,10,0])  rotate([45,0,0])     cube(5);
color("green") rotate([45,0,0])     translate([0,10,0])  cube(5);
    
}

translate([50,100,0]) {
    minkowski() {
        color("red")   translate([0,10,0])  rotate([30,0,0])     cube(5);
        color("green") rotate([70,0,0])     translate([0,10,0])  cube(5);
    }
}