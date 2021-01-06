$fn= 100;

width = 10;   // width of rectangle
height = 2;   // height of rectangle
r = 30;       // radius of the curve
a = 60;       // angle of the curve

x = r * cos(a);
y = r * sin(a);

translate([0, 0, width/2]) rotate_extrude(angle = a) translate([r, 0, 0]) square(size = [height, width], center = true);
linear_extrude(height=width) {
    translate([r,y/2,0]) square(size = [height, y], center = true);
    translate([x+(r-x)/2,y,0]) square(size = [r-x, height], center = true);
}


translate([50,0,0]) 
hull() {
    translate([0, 0, width/2]) rotate_extrude(angle = a) translate([r, 0, 0]) square(size = [height, width], center = true);
    linear_extrude(height=width) {
        translate([r,y/2,0]) square(size = [height, y], center = true);
        translate([x+(r-x)/2,y,0]) square(size = [r-x, height], center = true);
    }
}

translate([100,0,0])
// minkowski() {
    union() {
        translate([0, 0, width/2]) rotate_extrude(angle = a) translate([r, 0, 0]) square(size = [height, width], center = true);
        linear_extrude(height=width) {
            translate([r,y/2,0]) square(size = [height, y], center = true);
            translate([x+(r-x)/2,y,0]) square(size = [r-x, height], center = true);
        }
    }
    
//     sphere(d=3, $fn=30);
// }
