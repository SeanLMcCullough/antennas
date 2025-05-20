// inputs
d_cond = 25;
r_bend = 20;
t_cond_sprt = 3;
t_cond_arm = 3;
d_pipe = 48.5;
t_spine = 5;

// larger helix
h1 = 732.3;
di1 = 302.2;
d1 = 322.2;
dc1 = 228.2;

// smaller helix
h2 = 696.5;
di2 = 286.4;
d2 = 306.4;
dc2 = 266.4;

// calculated
r_cond = d_cond / 2;
delta_h = h1 - h2;

// Q
$fn = 25;
slices = 150;
tolerance = 0.2;

module wire_support(height, diameter) {
    // vertical support
    translate([0, -t_cond_arm /2])
        cube([dc2 / 2, t_cond_arm, height]);
    
    // arm
    linear_extrude(height = height, twist = 180, slices = slices)
        translate([0, -t_cond_arm /2])
            square([(diameter / 2) - r_cond, t_cond_arm]);
    
    // conductor guides
    difference() {
        linear_extrude(height = height, twist = 180, slices = slices) {
            translate([(diameter / 2), (t_cond_sprt / 2)])
                    circle(r_cond + t_cond_sprt);
        }
        
        linear_extrude(height = height + 2, twist = 180, slices = slices) {
            translate([(diameter / 2), 0, -1])
                    circle(r_cond);
        }
    }
    
}

module separator(length) {
    cylinder(length, r_cond + t_cond_sprt, r_cond + t_cond_sprt);
}

module helix(height, diameter) {
    difference() {
        union() {
            translate([- diameter / 2, 0])
                rotate([0, 90, 0])
                    separator(diameter);
            
            wire_support(height, diameter);
            rotate(180)
                wire_support(height, diameter);
            
        }

        translate([0, 0, -1]) {
            difference() {
                translate([0, 0, -1])
                    cylinder(h = height + 4, r = diameter);
                
                cylinder(h = height + 2, r = diameter / 2);
            }
        }
    }    
}

module spine () {
    difference () {
        cylinder(h1, d = d_pipe + 2*t_spine);
        
        translate([0, 0, -1])
            cylinder(h1 + 2, d = d_pipe + 2*tolerance); 
    }
}

module structure () {
    difference () {
        union() {
            helix(h1, d1);
            rotate(90)
                translate([0, 0, delta_h / 2])
                    helix(h2, d2);
        }
        translate([0, 0, -1])
            cylinder(h1 + 2, d = d_pipe);
    }
}

structure();
spine();
