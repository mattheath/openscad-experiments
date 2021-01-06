width = 100;
height = 155;
base_thickness = 2;

edge_thickness = 6;
edge_height = 10;

inlay = 17;

show_plugs = false;
show_triangle = false;

// variables above this point appear in the customizer
module null() {}

h = base_thickness;
padding = 3;

hd = 2; // first half was 1.5mm, which is a bit small for a pencil

if (show_triangle) {
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
                
                // alignment window
                // aw = width-inlay*2;
                aw = width/4;
                translate([inlay,0,0]) square([aw, 2]);
                

                // 1cm marking holes
                for (y=[10:10:140]) {
                    translate([4,y,0]) circle(d=hd,$fn=20);
                }

                // 5mm marking holes
                for (y=[10:10:130]) {
                    translate([7,y-5,0]) circle(d=hd,$fn=20);
                }
                
                // 2.5mm marking holes
    //            for (y=[10:10:130]) {
    //                translate([10,y-2.5,0]) circle(d=2,$fn=20);
    //                translate([10,y-7.5,0]) circle(d=2,$fn=20);
    //            }
                
                // 1mm marking holes
    //            translate([4,0,0]) 
    //            for (y=[10:10:130]) {
    //                translate([3,y-1,0]) circle(d=hd,$fn=20);
    //                translate([6,y-2,0]) circle(d=hd,$fn=20);
    //                translate([9,y-3,0]) circle(d=hd,$fn=20);
    //                translate([3,y-4,0]) circle(d=hd,$fn=20);
    //                translate([6,y-5,0]) circle(d=hd,$fn=20);
    //                translate([9,y-6,0]) circle(d=hd,$fn=20);
    //                translate([3,y-7,0]) circle(d=hd,$fn=20);
    //                translate([6,y-8,0]) circle(d=hd,$fn=20);
    //                translate([9,y-9,0]) circle(d=hd,$fn=20);
    //            }
            }
            
            translate([inlay+3,100,-5]) cylinder(d=4,h=h+10,$fn=100);
            
            translate([inlay+3,100, h-1]) cylinder(d=6,h=h+10,$fn=100);
        }

        // cm markers
        for (y=[10:10:150]) {
            translate([0.5,y,h]) 
                linear_extrude(height=0.2) square([1,0.2], true);
        }

    }


    //color("yellow") translate([inlay+3,100,0]) cylinder(d=6,h=10,$fn=100);

    // straight edge WITH rectangle alignment tabs
    //color("red") {
    //    linear_extrude(height=h+edge_height)
    //        translate([0,-edge_thickness,0])
    //            difference() {
    //                square([width,edge_thickness]);
    //                translate([width/4*3,edge_thickness/2,0]) square([15,1], true);
    //                translate([width/4,edge_thickness/2,0]) square([15,1], true);
    //            }
    //}    

    // straight edge WITH cylindrical alignment
    color("red") {
        translate([0,-edge_thickness,0]) {
            difference() {
                linear_extrude(height=h+edge_height)
                    square([width,edge_thickness]);
                
                d = edge_thickness-3;
                translate([10,edge_thickness/2,-1]) cylinder(d=d,h=edge_height/2+1,$fn=100);
                translate([width/2,edge_thickness/2,-1]) cylinder(d=d,h=edge_height/2+1,$fn=100);
                translate([width-10,edge_thickness/2,-1]) cylinder(d=d,h=edge_height/2+1,$fn=100);
            }
            
    //        translate([width/4,edge_thickness/2,-1]) cylinder(d=edge_thickness-2,h=edge_height/2+1,$fn=100);
    //        translate([width/4*2,edge_thickness/2,-1]) cylinder(d=edge_thickness-2,h=edge_height/2+1,$fn=100);
    //        translate([width/4*3,edge_thickness/2,-1]) cylinder(d=edge_thickness-2,h=edge_height/2+1,$fn=100);

        }    
    }
}


// joining plugs

if(show_plugs) {
    // plug one (simple)
    color("red")  translate([30,30,0]) {
        
        translate([10,0,0]) {
            union() {
                cylinder(d=6,h=1,$fn=100);
                cylinder(d=4,h=h*2,$fn=100);
            }
        }

        // plug two (two part interlocking)
        difference() {
            union() {
                cylinder(d=6,h=1,$fn=100);
                cylinder(d=4,h=h*2-1,$fn=100);
            }
            translate([0,0,-1]) cylinder(d=1,h=h*2+2,$fn=100);
        }

        translate([0,10,0]) {
            union() {
                cylinder(d=6,h=1,$fn=100);
                cylinder(d=1,h=h,$fn=100);
            }
        }
    }

}
if (true) {

d = 2.7; // (edge_thickness-3)*0.95;
echo(d);


translate([65,95,0]) cube([30,10,0.4]);
translate([0,0,0.4]) color("red") {
    translate([70,100,0]) cylinder(d=d,h=edge_height,$fn=100);
    translate([80,100,0]) cylinder(d=d,h=edge_height,$fn=100);
    translate([90,100,0]) cylinder(d=d,h=edge_height,$fn=100);
}


}

//color("red")
//    offset(r=inset_padding, $fn=360) // then increase by padding to get rounded internal corners
//        offset(r=-inset-inset_padding) // overreduce by the inset amount and padding
//            resize([x,y]) polygon(points=[[0,0],[1,0],[0,1]]);

//color("blue")
//    offset(delta=-inset, chamfer=true)
//        resize([x,y]) polygon(points=[[0,0],[1,0],[0,1]]);


