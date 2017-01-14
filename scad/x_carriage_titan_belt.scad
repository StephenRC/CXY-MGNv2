///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// x_carriage_titan_belt.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 1/1/2017
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/3/16	- now uses belt_clamp.scad
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
use <belt_clamp.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

x_carriage_titan_belt();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_titan_belt() {
	translate([-7.9,-34,4]) titan();
	difference() {
		translate([5,-24,5]) x_carriage_belt2(-45,10,0);
		translate([-40.5,-4,3]) main_base_mounting();
	}
	difference() {
		translate([-40,-14,0]) color("red") cubeX([45.5,40,wall+1],2);
		translate([-40.5,-4,3]) main_base_mounting();
	}
	translate([40,-70,0]) beltclamp();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titan(recess=3) { // extruder platform for e3d titan with (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
	difference() {		 // ir sensor is relative -28y; BLTouch +20y, Proximity +6y (going by translates)
		translate([0,-5.5,0]) cubeX([widthE,heightE+11,wall],radius=2,center=true); // extruder side
		//extmount();
		hull() {	// hole for e3dv6, shifted to front by 11mm
			translate([-17.5+shifthotend2,-16+shifthotend,-10]) cylinder(h=20,d=e3dv6,$fn=100);
			translate([-35+shifthotend2,-16+shifthotend,-10]) cylinder(h=20,d=e3dv6);
		}
		translate([20,-5,-10]) cylinder(h=20,d=20,$fn=100); // remove some plastic under the motor
		translate([0,16,44]) rotate([90,0,0]) sidemounts();
		if(recess == 0) translate([-16,-4,0]) blt(1); // BLTouch mount
		if(recess == 1) translate([-16,-4,0]) blt(0); // BLTouch mount in a recess
		if(recess == 2) translate([-16,10,-6]) cylinder(h=wall*2,r=psensord/2,$fn=50); // proximity sensor
		if(recess == 3) ir_mount(); // mounting holes for irsensor bracket
	}
	translate([0,-30,0]) rotate([90,0,90]) titanmotor(shifttitanup);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sidemounts() {	// mounting holes (copied from fan() & servo() modules
	translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([-extruder/2-25,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset]) // l-r
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
//
	translate([-extruder/2-25,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([-extruder/2-25,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
//
	translate([-extruder/2-25,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset]) // l-f
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ir_mount() // ir screw holes for mounting to extruder plate
{
	translate([spacing+shiftir+shifthotend,-25,0]) rotate([90,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
	translate([shiftir+shifthotend,-25,0]) rotate([90,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titanmotor(ShiftUp=0) {
	difference() {	// motor mounting holes
		translate([-1,0,0]) cubeX([54,50+ShiftUp,5],2);
		translate([25,25+ShiftUp,-1]) rotate([0,0,45])  NEMA17_x_holes(8, 2);
	}
	difference() { // front support
		translate([-1,0,0]) color("red") cubeX([4,50,50],2);
		translate([-3,50,4]) rotate([56,0,0]) cube([7,50,70]);
		translate([-4,-4,36]) cube([wall,wall,wall]);
	}
	difference() { // rear support
		translate([49,0,0]) color("blue") cubeX([4,50,50],2);
		translate([47,50,4]) rotate([56,0,0]) cube([7,50,70]);
		translate([47,-4,36]) cube([wall,wall,wall]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_belt2(PosX,PosY,PosZ,Dual) {
	translate([PosX,PosY,PosZ])	belt_drive2(Dual);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_base_mounting() {	// mounting holes to mgn12h
	color("red") translate([(puck_l/2)+(hole_sep/2),3.5,-9]) cylinder(h=thickness*3,d=screw3);
	color("blue") translate([(puck_l/2)-(hole_sep/2),3.5,-9]) cylinder(h=thickness*3,d=screw3);
	color("white") translate([(puck_l/2)+(hole_sep/2),hole_sep+3.5,-9]) cylinder(h=thickness*3,d=screw3);
	color("black") translate([(puck_l/2)-(hole_sep/2),hole_sep+3.5,-9]) cylinder(h=thickness*3,d=screw3);
	// countersinks
	color("red") translate([(puck_l/2)+(hole_sep/2),3.5,thickness-1]) cylinder(h=thickness*5,d=screw3hd);
	color("blue") translate([(puck_l/2)-(hole_sep/2),3.5,thickness-1]) cylinder(h=thickness*5,d=screw3hd);
	color("white") translate([(puck_l/2)+(hole_sep/2),hole_sep+3.5,thickness-1]) cylinder(h=thickness*5,d=screw3hd);
	color("black") translate([(puck_l/2)-(hole_sep/2),hole_sep+3.5,thickness-1]) cylinder(h=thickness*5,d=screw3hd);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_drive2(Dual=0)	// corexy
{
	difference() {	// right wall
		translate([-wall+wall,0,0]) color("blue") cubeX([wall-2,40,29+belt_adjustUD],2);
		translate([-wall/2-2,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-wall/2-2,belt_adjust,4+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([3.5,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
		translate([3.5,belt_adjust,4+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
	}
	beltbump2(0);
	difference() {	// left wall
		translate([35.4+wall/2,0,0]) color("white") cubeX([wall-2,40,29+belt_adjustUD],2);
		translate([32,belt_adjust,4+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([32,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([38.5,belt_adjust,4+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
		translate([32,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([38.5,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
	}
	// rear wall
	if(Dual) {
		difference() {
			translate([-wall/2+5,42-wall,0]) color("pink") cubeX([44,wall-2,belt_adjust+belt_adjustUD],2);
			translate([0,40,0]) rotate([90,0,0]) bowden_nuts(25);
		}
	} else {
		translate([-wall/2+5,42-wall,0]) color("pink") cubeX([44,wall-2,belt_adjust+belt_adjustUD],2);
	}
	// front wall
	//translate([-wall/2+1,0,0]) color("cyan") cubeX([47,wall-2,belt_adjust],2);
	beltbump2(1);
}

module beltbump2(Bump) { // add a little plastic at the belt clamp screw holes at the edge
	if(Bump) {
		difference() {	
			translate([39.4,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) color("cyan") cylinder(h = wall-2, r = screw3+0.5,$fn=50);
			translate([32,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([38.5,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
		}
	} else {
		difference() {	
			translate([0,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) color("pink") cylinder(h = wall-2, r = screw3+0.5,$fn=50);
			translate([-wall/2-2,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([3.5,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
