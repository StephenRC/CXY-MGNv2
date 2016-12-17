///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// lower_brackets_v2.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/13/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

lower_brackets_v2();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module lower_brackets_v2() {
	single_lower_bracket_v2();
	translate([130,0,0]) rotate([0,0,90]) single_lower_bracket_v2();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_lower_bracket_v2() {
	difference() {	
		union() {
			color("grey") cubeX([sq_w+10,60,sq_d+10],2);
			color("lightgrey") cubeX([60,sq_w+10,sq_d+10],2);
			upper_bracket_support(0);
		}
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots();
	}
	difference() {
		translate([0,23.3,0]) rotate([90,0,0]) union() {
			color("grey") cubeX([sq_d+10,60,sq_d+10],2);
			color("lightgrey") cubeX([60,sq_d+10,sq_d+10],2);
			upper_bracket_support(0);
		}
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots();
	}
	difference() {
		translate([0,0,0]) rotate([90,0,90]) union() {
			color("grey") cubeX([sq_d+10,60,sq_d+10],2);
			color("lightgrey") cubeX([60,sq_d+10,sq_d+10],2);
			upper_bracket_support(0);
		}
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module upper_bracket_support(Solid=0) {	// angled supports
	if(Solid) {
		difference() {
			translate([16,-69,(sq_d+10)/2-thickness/2]) rotate([0,0,45]) color("cyan") cubeX([92,92,thickness],2);
			translate([-18,-113,(sq_d+10)/2-thickness/2-1]) cube([120,120,thickness+2]);
			translate([-110,-40,(sq_d+10)/2-thickness/2-1]) cube([120,140,thickness+2]);
		}
	} else {
		difference() {
			translate([75,-4,(sq_d+10)/2-thickness/2]) rotate([0,0,45]) color("cyan") cubeX([10,85,thickness],2);
			translate([-18,-99,(sq_d+10)/2-thickness/2-1]) cube([120,120,thickness+2]);
			translate([-98,-40,(sq_d+10)/2-thickness/2-1]) cube([120,140,thickness+2]);
			translate([59,18,(sq_d+10)/2-thickness/2-1]) cube([10,10,thickness+2]);
			translate([18,59,(sq_d+10)/2-thickness/2-1]) cube([10,10,thickness+2]);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_sq_slots() { // square al slots
	color("Red") translate([4.5,105-sq_w,sq_d]) cube([150,sq_w,sq_d],true);		// horz
	color("Blue") translate([105-sq_w,3.5,sq_d]) cube([sq_w,150,sq_d],true);	// horz
	color("Green") translate([105-sq_w,105-sq_w,50]) cube([sq_w,sq_d,150],true);	//vert
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////