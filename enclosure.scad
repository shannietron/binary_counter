/* [Rendering options] */
// Show placeholder PCB in OpenSCAD preview
show_pcb = false;
// Lid mounting method
lid_model = "cap"; // [cap, inner-fit]
// Conditional rendering
render = "case"; // [all, case, lid]


/* [Dimensions] */
// Height of the PCB mounting stand-offs between the bottom of the case and the PCB
standoff_height = 5;
// PCB thickness
pcb_thickness = 1.6;
// Bottom layer thickness
floor_height = 1.2;
// Case wall thickness
wall_thickness = 1.2;
// Space between the top of the PCB and the top of the case
headroom = 0;

/* [M2.5 screws] */
// Outer diameter for the insert
insert_M2_5_diameter = 3.27;
// Depth of the insert
insert_M2_5_depth = 3.75;

/* [Hidden] */
$fa=$preview ? 10 : 4;
$fs=0.2;
inner_height = floor_height + standoff_height + pcb_thickness + headroom;

module wall (thickness, height) {
    linear_extrude(height, convexity=10) {
        difference() {
            offset(r=thickness)
                children();
            children();
        }
    }
}

module bottom(thickness, height) {
    linear_extrude(height, convexity=3) {
        offset(r=thickness)
            children();
    }
}

module lid(thickness, height, edge) {
    linear_extrude(height, convexity=10) {
        offset(r=thickness)
            children();
    }
    translate([0,0,-edge])
    difference() {
        linear_extrude(edge, convexity=10) {
                offset(r=-0.2)
                children();
        }
        translate([0,0, -0.5])
         linear_extrude(edge+1, convexity=10) {
                offset(r=-1.2)
                children();
        }
    }
}


module box(wall_thick, bottom_layers, height) {
    if (render == "all" || render == "case") {
        translate([0,0, bottom_layers])
            wall(wall_thick, height) children();
        bottom(wall_thick, bottom_layers) children();
    }
    
    if (render == "all" || render == "lid") {
        translate([0, 0, height+bottom_layers+0.1])
        lid(wall_thick, bottom_layers, lid_model == "inner-fit" ? headroom-2.5: bottom_layers) 
            children();
    }
}

module mount(drill, space, height) {
    translate([0,0,height/2])
        difference() {
            cylinder(h=height, r=(space/2), center=true);
            cylinder(h=(height*2), r=(drill/2), center=true);
            
            translate([0, 0, height/2+0.01])
                children();
        }
        
}

module connector(min_x, min_y, max_x, max_y, height) {
    size_x = max_x - min_x;
    size_y = max_y - min_y;
    translate([(min_x + max_x)/2, (min_y + max_y)/2, height/2])
        cube([size_x, size_y, height], center=true);
}

module pcb() {
    thickness = 1.6;

    color("#009900")
    difference() {
        linear_extrude(thickness) {
            polygon(points = [[218.5,99.5], [218.48769,99.65643], [218.45106,99.80902], [218.39101,99.95399], [218.30902,100.08779], [218.20711,100.20711], [218.08779,100.30902], [217.95399,100.39101], [217.80902,100.45106], [217.65643,100.48769], [217.5,100.5], [124,100.5], [123.84357,100.48769], [123.69098,100.45106], [123.54601,100.39101], [123.41221,100.30902], [123.29289,100.20711], [123.19098,100.08779], [123.10899,99.95399], [123.04894,99.80902], [123.01231,99.65643], [123,99.5], [123,86.5], [123.01231,86.34357], [123.04894,86.19098], [123.10899,86.04601], [123.19098,85.91221], [123.29289,85.79289], [123.41221,85.69098], [123.54601,85.60899], [123.69098,85.54894], [123.84357,85.51231], [124,85.5], [217.5,85.5], [217.65643,85.51231], [217.80902,85.54894], [217.95399,85.60899], [218.08779,85.69098], [218.20711,85.79289], [218.30902,85.91221], [218.39101,86.04601], [218.45106,86.19098], [218.48769,86.34357], [218.5,86.5], [218.5,99.5]]);
        }
    translate([216, 87.5, -1])
        cylinder(thickness+2, 1.0999999999999943, 1.0999999999999943);
    translate([125.5, 98.5, -1])
        cylinder(thickness+2, 1.0999999999999943, 1.0999999999999943);
    translate([216, 98.5, -1])
        cylinder(thickness+2, 1.0999999999999943, 1.0999999999999943);
    translate([125.5, 87.5, -1])
        cylinder(thickness+2, 1.0999999999999943, 1.0999999999999943);
    }
}

module case_outline() {
    polygon(points = [[118,80.5], [118,105.5], [118.06155,106.28215], [118.2447,107.0451], [118.54495,107.76995], [118.9549,108.43895], [119.46445,109.03555], [120.06105,109.5451], [120.73005,109.95505], [121.4549,110.2553], [122.21785,110.43845], [123.0,110.5], [218,110.5], [218.78215,110.43845], [219.5451,110.2553], [220.26995,109.95505], [220.93895,109.5451], [221.53555,109.03555], [222.0451,108.43895], [222.45505,107.76995], [222.7553,107.0451], [222.93845,106.28215], [223.0,105.5], [223,80.5], [222.93845,79.71785], [222.7553,78.9549], [222.45505,78.23005], [222.0451,77.56105], [221.53555,76.96445], [220.93895,76.4549], [220.26995,76.04495], [219.5451,75.7447], [218.78215,75.56155], [218.0,75.5], [123,75.5], [122.21785,75.56155], [121.4549,75.7447], [120.73005,76.04495], [120.06105,76.4549], [119.46445,76.96445], [118.9549,77.56105], [118.54495,78.23005], [118.2447,78.9549], [118.06155,79.71785], [118.0,80.5]]);
}

module Insert_M2_5() {
    translate([0, 0, -insert_M2_5_depth])
        cylinder(insert_M2_5_depth, insert_M2_5_diameter/2, insert_M2_5_diameter/2);
    translate([0, 0, -0.3])
        cylinder(0.3, insert_M2_5_diameter/2, insert_M2_5_diameter/2+0.3);
}

rotate([render == "lid" ? 180 : 0, 0, 0])
scale([1, -1, 1])
translate([-170.5, -93.0, 0]) {
    pcb_top = floor_height + standoff_height + pcb_thickness;

    difference() {
        box(wall_thickness, floor_height, inner_height) {
            case_outline();
        }

    translate([200.5, 93, inner_height])
        cylinder(floor_height+2, 14.142135623730951, 14.142135623730951);
    }

    if (show_pcb && $preview) {
        translate([0, 0, floor_height + standoff_height])
            pcb();
    }

    if (render == "all" || render == "case") {
        // H2 [('M2.5', 2.5)]
        translate([216, 87.5, floor_height])
        mount(2.2, 4.9, standoff_height)
            Insert_M2_5();
        // H4 [('M2.5', 2.5)]
        translate([125.5, 98.5, floor_height])
        mount(2.2, 4.9, standoff_height)
            Insert_M2_5();
        // H1 [('M2.5', 2.5)]
        translate([216, 98.5, floor_height])
        mount(2.2, 4.9, standoff_height)
            Insert_M2_5();
        // H3 [('M2.5', 2.5)]
        translate([125.5, 87.5, floor_height])
        mount(2.2, 4.9, standoff_height)
            Insert_M2_5();
    }
}
