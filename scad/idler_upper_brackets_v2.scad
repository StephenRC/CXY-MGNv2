///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// motor_upper_brackets_v3.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/13/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

idler_upper_brackets_v2();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module idler_upper_brackets_v2(Spacer_H = 0) {
	single_upper_bracket_v2();
	difference() {
		translate([0,4,23.3]) rotate([180,0,0]) color("green") bearing_bracket(0,b_posY-2);
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots2();
	}
	if(Spacer_H) translate([50,-13,0]) tapered_bearspacer(Spacer_H);
	translate([140,0,0]) {
		translate([-10,-1.2,0]) rotate([0,0,90]) single_upper_bracket_v2(0);
	}
	difference() {
		translate([106,3,23.3]) rotate([180,0,0]) color("blue")  bearing_bracket(0,b_posY-2);
		translate([110,98.8,-0.5]) rotate([0,0,-90]) al_sq_slots2();
	}
	if(Spacer_H) translate([80,-13,0]) tapered_bearspacer(Spacer_H);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_upper_bracket_v2() { // for the horizontal square to vertical square
	difference() {	
		union() {
			color("grey") cubeX([sq_w+10,60,sq_d+10],2);
			color("lightgrey") cubeX([60,sq_w+10,sq_d+10],2);
			upper_bracket_support(0);
		}
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots2();
	}
	difference() {
		translate([0,23.3,0]) rotate([90,0,0]) union() {
			color("grey") cubeX([sq_d+10,60,sq_d+10],2);
			color("lightgrey") cubeX([60,sq_d+10,sq_d+10],2);
			upper_bracket_support(0);
		}
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots2();
	}
	difference() {
		translate([0,0,0]) rotate([90,0,90]) union() {
			color("grey") cubeX([sq_d+10,60,sq_d+10],2);
			color("lightgrey") cubeX([60,sq_d+10,sq_d+10],2);
			upper_bracket_support(0);
		}
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots2();
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

module al_sq_slots2() { // square al slots
	color("Red") translate([4.5,105-sq_w,sq_d-1.2]) cube([150,sq_w,sq_d],true);		// horz
	color("Blue") translate([105-sq_w,3.5,sq_d-1.2]) cube([sq_w,150,sq_d],true);	// horz
	color("Green") translate([104.5-sq_w,105-sq_w,80.5]) cube([sq_d,sq_w,150],true); //vert
}

/////////////////////////////////////////////////////////////////////////////////////////

module bearing_bracket(TapIt=0,Ypos = b_posY) {
	difference() {
		cubeX([24,30,sq_d+10],2);
		if(TapIt)
			translate([Ypos,b_posX,-2]) cylinder(h=50,r=screw5t/2);
		else {
			translate([Ypos,b_posX,-2]) cylinder(h=50,r=screw5/2);
			translate([Ypos,b_posX,-b_height-23]) cylinder(h=50,d=nut5_d,$fn=6); // nut hole
		}
	}
}

