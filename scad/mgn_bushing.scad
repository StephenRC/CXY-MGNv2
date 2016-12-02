// ran out of M3x6 screws, so time to make some spacers
/////////////////////////////////////////////////////////////////
// created 11/23/2016
// last update 11/23/16
/////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
$fn=100;
/////////////////////////////////////////////////////////////////
thick = 2;
/////////////////////////////////////////////////////////////////
difference() {
	cylinder(h=thick,d=screw3hd);
	translate([0,0,-1]) cylinder(h=4,d=screw3);
}

translate([10,0,0]) difference() {
	cylinder(h=thick,d=screw3hd);
	translate([0,0,-1]) cylinder(h=4,d=screw3);
}

translate([10,10,0]) difference() {
	cylinder(h=thick,d=screw3hd);
	translate([0,0,-1]) cylinder(h=4,d=screw3);
}

translate([0,10,0]) difference() {
	cylinder(h=thick,d=screw3hd);
	translate([0,0,-1]) cylinder(h=4,d=screw3);
}
/////////////////////////////////////////////////////////////////////