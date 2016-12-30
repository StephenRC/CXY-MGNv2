///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// motor_upper_brackets_v3.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/27/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 12/27/16 - made height adjustable
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

motor_upper_brackets_v3(0);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module motor_upper_brackets_v3(Select=0) { // 0 - both, 1 - lower belt, 2 - upper belt, 3 - both motor mounts only
	if(Select==0 || Select==1) {
		difference() {
			union() {
				single_upper_bracket_v2();
				translate([-17,0,0]) cubeX([21.5,20,sq_d+10],2);
				translate([-16.5,8,15]) rotate([90,180,-90]) printchar("R",2,5);
			}
			translate([12.5,-29,0]) rotate([0,0,-180]) motor_mount_v3_screws(0,0);
		}
		translate([12.5,-35,2.5]) rotate([0,0,-180]) motor_mount_v3(0);
	}
	if(Select==0 || Select==2) {
		difference() {
			union() {
				translate([140,0,0]) rotate([0,0,90]) single_upper_bracket_v2();
				translate([136,0,0]) cubeX([21.5,20,sq_d+10],2);
				translate([157,12,15]) rotate([90,180,90]) printchar("L",2,5);
			}
			translate([128,-29,0]) rotate([0,0,-180]) motor_mount_v3_screws(1,0);
		}
		translate([128,-35,2.5]) rotate([0,0,-180]) motor_mount_v3(1);
	}
	if(Select==3) {	// just both motor mounts
		translate([128,-35,2.5]) rotate([0,0,-180]) motor_mount_v3(1);
		translate([12.5,-35,2.5]) rotate([0,0,-180]) motor_mount_v3(0);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=4) { // print something
	linear_extrude(height = Height) text(String, font = "Liberation Sans",size=Size);
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

///////////////////////////////////////////////////////////////////////////////////////////

module motor_mount_v3_screws(Left,Height=adjust_motor_height) {
	if(!Left) {
		translate([20,8,(sq_d+10)/2+Height]) rotate([90,0,0]) cylinder(h=100,d=screw5);
		translate([20,-15,(sq_d+10)/2+Height]) rotate([90,0,0]) cylinder(h=10,d=screw5hd);
		translate([-20,8,(sq_d+10)/2+Height]) rotate([90,0,0]) cylinder(h=70,d=screw5);
		translate([-20,-15,(sq_d+10)/2+Height]) rotate([90,0,0]) cylinder(h=10,d=screw5hd);
		translate([0,11,40+Height]) rotate([90,0,0]) cylinder(h=70,d=screw5);
		translate([0,-15,40+Height]) rotate([90,0,0]) cylinder(h=10,d=screw5hd);
	} else {
		translate([20,8,(sq_d+10)/2+Height]) rotate([90,0,0]) cylinder(h=70,d=screw5);
		translate([20,-15,(sq_d+10)/2+Height]) rotate([90,0,0]) cylinder(h=10,d=screw5hd);
		translate([-20,5,(sq_d+10)/2+Height]) rotate([90,0,0]) cylinder(h=70,d=screw5);
		translate([-20,-15,(sq_d+10)/2+Height]) rotate([90,0,0]) cylinder(h=10,d=screw5hd);
		translate([0,11,40+Height]) rotate([90,0,0]) cylinder(h=70,d=screw5);
		translate([0,-15,40+Height]) rotate([90,0,0]) cylinder(h=10,d=screw5hd);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////

module motor_mount_v3(Left=0) {
	if(!Left) { // right
		difference() {
			cubeX([59,59,5],radius=2,center=true);
			translate([0,0,-4]) rotate([0,0,45])  NEMA17_x_holes(7, 2);
		}
		diag_side();
		difference() {
			translate([0,-27,24+mgn_rh/2-adjust_motor_height/2]) color("blue") cubeX([59,5,50+mgn_rh-adjust_motor_height],radius=2,center=true);
			translate([0,0,mgn_rh]) motor_mount_v3_screws(Left,adjust_motor_height);
		}
		translate([0,-25,20]) rotate([-90,0,0]) printchar("R",2,5);
	} else { // left
		difference() {
			cubeX([59,59,5],radius=2,center=true);
			translate([0,0,-4]) rotate([0,0,45])  NEMA17_x_holes(7, 2);
		}
		difference() {
			diag_side();
			translate([0,0,mgn_rh+10]) motor_mount_v3_screws(Left,adjust_motor_height);
		}
		difference() {
			translate([0,-27,28+mgn_rh/2-adjust_motor_height/2]) color("blue") cubeX([59,5,60+mgn_rh-adjust_motor_height],radius=2,center=true);
			translate([0,0,mgn_rh+10]) motor_mount_v3_screws(Left,adjust_motor_height);
		}
		translate([0,-25,30]) rotate([-90,0,0]) printchar("L",2,5);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

module diag_side() {
	difference() {
		translate([24.4,-33,35]) rotate([-45,0,0]) color("red") cubeX([5,60,10],2);
		translate([23,-33.5,-10]) cube([10,60,10],2);
		translate([23,-36.5,6]) cube([10,10,60],2);
	}
	difference() {
		translate([-29.4,-33,36]) rotate([-45,0,0]) color("cyan") cubeX([5,60,10],2);
		translate([-32,-30.5,-10]) cube([10,50,10],2);
		translate([-32,-36,45]) rotate([0,90,0]) cube([50,10,10],2);
	}
}

