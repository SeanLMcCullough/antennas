callsign = "VK4SLM";

internal_diameter = 30.9;
internal_radius = internal_diameter / 2;
wall_thickness = 4;
plate_thickness = 4;
sleeve_length = 40;
hole_count = 3;
hole_diameter = 10;
plate_radius = internal_radius + wall_thickness + (hole_diameter * 2);
bevel = wall_thickness / 2;
hole_bevel = hole_diameter / 10;
tolerance = 0.05;
text_deboss = 0.4;

text_size = plate_radius / 6;

$fn = 100;

module right_triangle(a, b) {
    polygon(points=[[0,0], [a,0], [0,b]]);
}


difference() {
    union() {
        // Sleeve
        cylinder(sleeve_length, r = internal_radius + wall_thickness);
        
        // Plate
        cylinder(plate_thickness, r = plate_radius);
    }
    
    // Sleeve hole
    translate([0, 0, -tolerance])
        cylinder(sleeve_length + (2 * tolerance), r = internal_radius + tolerance);
    
    // Lower sleeve bevel
    translate([0, 0, -tolerance])
        rotate_extrude()
            translate([internal_radius, 0])
                right_triangle(bevel, bevel);

    // Upper sleeve bevel
    translate([0, 0, sleeve_length + tolerance])
        rotate_extrude()
            translate([internal_radius, 0])
                rotate(a = 270)
                    right_triangle(bevel, bevel);
    
    // Holes
    for(a = [0 : (360 / hole_count) : 360]) {
        // Hole
        translate([0, 0, -tolerance])
            rotate(a = a)
                translate([plate_radius - hole_diameter, 0]) {
                    cylinder(plate_thickness + (2*tolerance), d = hole_diameter);
        
                    // Lower hole bevel
                    rotate_extrude()
                        translate([(hole_diameter / 2) - tolerance, 0])
                            right_triangle(hole_bevel, hole_bevel);
                    
                    // Upper hole bevel  
                    translate([0, 0, plate_thickness + (tolerance*2)])
                    rotate_extrude()
                        translate([(hole_diameter / 2) - tolerance, 0])
                            rotate(a = 270)
                                right_triangle(hole_bevel, hole_bevel);       
                }
    }
    
    // Callsign label    
    rotate(90)
        translate([0, plate_radius - (1.5 * hole_diameter), plate_thickness - text_deboss])
            rotate(180)
                linear_extrude(text_deboss + tolerance)
                    text(callsign, size = text_size, font = "Courier New:style=Bold", halign = "center", valign = "center");
    }