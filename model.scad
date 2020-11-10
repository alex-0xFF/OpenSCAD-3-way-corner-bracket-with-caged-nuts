radius = 30;
nut_outer_r = 15.3/2;
screw_r = 4.5;
under_nut_h = 5;
nut_cage_h = 5;
wall_th = under_nut_h+nut_cage_h;
hole_dist = screw_r+20-wall_th;
cut_ratio = 0.8;
quality = 180;

module pieSlice(a, r, h){
  //a:angle, r:radius, h:height
  rotate_extrude(angle=a, $fn=quality) square([r, h]);
}

module oneThird(angle=15) {
    difference() {
        pieSlice(90, radius, wall_th);
        //nut recess
        translate([hole_dist, hole_dist, under_nut_h]) {
            rotate(angle) cylinder(r=nut_outer_r, h=nut_cage_h, $fn=6);
        }
        //screw hole
        translate([hole_dist, hole_dist, 0]) cylinder(r=screw_r, h=wall_th, $fn=quality);
        translate([0, radius*cut_ratio, 0]) cube([radius, radius, wall_th]);
        translate([radius*cut_ratio, 0, 0]) cube([radius, radius, wall_th]);
    }
}

union() {
    oneThird();

    mirror([1, 0, 0]) {
        translate([wall_th, 0, wall_th])rotate([0, -90, 0]) oneThird();
    }

    mirror([0, 1, 0]) {
        translate([0, wall_th, wall_th])rotate([90, 0, 0]) oneThird();
    }

    translate([-wall_th, -wall_th, 0]) {
        cube([wall_th+radius*cut_ratio, wall_th, wall_th]);
        cube([wall_th, wall_th+radius*cut_ratio, wall_th]);
        cube([wall_th, wall_th, wall_th+radius*cut_ratio]);
    }
}