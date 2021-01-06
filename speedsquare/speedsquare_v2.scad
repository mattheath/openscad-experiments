width = 100;
height = 155;
base_thickness = 2;

edge_thickness = 3;
edge_height = 10;

inlay = 17;

// variables above this point appear in the customizer
module null() {}

h = base_thickness;
padding = 3;

hd = 1.5;

color("red") {
    difference() {
    
        // triangle base
        linear_extrude(height=h) difference() {
            // main base
            resize([width,height]) polygon(points=[[0,0],[1,0],[0,1]]);
          
            // subtract instep to reduce print time
            offset(r=padding, $fn=360) // then increase by padding to get rounded internal corners
                offset(r=-inlay-padding) // overreduce by the inset amount and padding
                    resize([width,height]) polygon(points=[[0,0],[1,0],[0,1]]);

            // 1cm marking holes
            for (y=[10:10:140]) {
                translate([4,y,0]) circle(d=hd,$fn=20);
            }

            // 5mm marking holes
//            for (y=[10:10:130]) {
//                translate([7,y-5,0]) circle(d=2,$fn=20);
//            }
            
            // 2.5mm marking holes
//            for (y=[10:10:130]) {
//                translate([10,y-2.5,0]) circle(d=2,$fn=20);
//                translate([10,y-7.5,0]) circle(d=2,$fn=20);
//            }
            
            // 1mm marking holes
            translate([4,0,0]) 
            for (y=[10:10:130]) {
//                translate([0,y,0]) circle(d=hd,$fn=20);
                translate([3,y-1,0]) circle(d=hd,$fn=20);
                translate([6,y-2,0]) circle(d=hd,$fn=20);
                translate([9,y-3,0]) circle(d=hd,$fn=20);
                translate([3,y-4,0]) circle(d=hd,$fn=20);
                translate([6,y-5,0]) circle(d=hd,$fn=20);
                translate([9,y-6,0]) circle(d=hd,$fn=20);
                translate([3,y-7,0]) circle(d=hd,$fn=20);
                translate([6,y-8,0]) circle(d=hd,$fn=20);
                translate([9,y-9,0]) circle(d=hd,$fn=20);
            }
        }
    }        
        

    // straight edge
    linear_extrude(height=h+edge_height)
        translate([0,-edge_thickness,0])
            square([width,edge_thickness]);
}    

// cm markers
for (y=[10:10:150]) {
    translate([0.5,y,h]) 
        linear_extrude(height=0.2) square([1,0.2], true);
}

//color("red")
//    offset(r=inset_padding, $fn=360) // then increase by padding to get rounded internal corners
//        offset(r=-inset-inset_padding) // overreduce by the inset amount and padding
//            resize([x,y]) polygon(points=[[0,0],[1,0],[0,1]]);

//color("blue")
//    offset(delta=-inset, chamfer=true)
//        resize([x,y]) polygon(points=[[0,0],[1,0],[0,1]]);


