
x = 100;
y = 150;
h = 2;

edge_thickness = 3;
edge_height = 10;

inset = 15;
inset_padding = 3;

color("red") {
    // triangle base
    linear_extrude(height=h)
        difference() {
            // main base
            resize([x,y]) polygon(points=[[0,0],[1,0],[0,1]]);
          
            // subtract instep to reduce print time
            offset(r=inset_padding, $fn=360) // then increase by padding to get rounded internal corners
                offset(r=-inset-inset_padding) // overreduce by the inset amount and padding
                    resize([x,y]) polygon(points=[[0,0],[1,0],[0,1]]);

            
        }

    // straight edge
    linear_extrude(height=h+edge_height)
        translate([0,-edge_thickness,0])
            square([x,edge_thickness]);
}    
    
//color("red")
//    offset(r=inset_padding, $fn=360) // then increase by padding to get rounded internal corners
//        offset(r=-inset-inset_padding) // overreduce by the inset amount and padding
//            resize([x,y]) polygon(points=[[0,0],[1,0],[0,1]]);

//color("blue")
//    offset(delta=-inset, chamfer=true)
//        resize([x,y]) polygon(points=[[0,0],[1,0],[0,1]]);
        