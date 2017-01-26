///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// x_carriage_titan_belt.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 1/25/2017
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/3/16	- now uses belt_clamp.scad
// 1/17/17	- added nut clearance hole for bottom belt clamp nuts, removed servo mounting holes.
//			  Uses brackets in bltouch_bracket.scad.  Shifted belt clamp holes down.
// 1/24/17	- Added wire chain bracket mounting holes.
// 1/25/17	- Adjusted belt clamp holes, opened up the sides of the Titan mount
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
use <belt_clamp.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

x_carriage_titan_belt(1);	// 0 - no belt clamps; 1 for belt clamps

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_titan_belt(Clamps) {
	translate([-7.9,-34,4]) titan();
	difference() {
		translate([-40,-14,5]) belt_drive2();
		translate([-40.5,-5,4]) main_base_mounting();
	}
	difference() {
		translate([-40,-14,0]) color("lightcoral") cubeX([45.4,40,wall+1],2);
		translate([-40.5,-5,4]) main_base_mounting();
		// nut clearance for bottom belt clamp holes
		hull() { // lower on blue
			translate([-37,belt_adjust-14,2+belt_adjustUD]) rotate([0,90,0]) nut(nut3+0.5,15);
			translate([-37,belt_adjust-14,10+belt_adjustUD]) rotate([0,90,0]) nut(nut3+0.5,15);
		}
		translate([-wall/2-40,belt_adjust-14,2+belt_adjustUD]) rotate([0,90,0])
			color("white") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		hull() { // lower on gray
			translate([-13,belt_adjust-14,4+belt_adjustUD-2]) rotate([0,90,0]) nut(nut3+0.5,15);
			translate([-13,belt_adjust-14,10+belt_adjustUD]) rotate([0,90,0]) nut(nut3+0.5,15);
		}
		translate([-wall/2-2,belt_adjust-14,2+belt_adjustUD]) rotate([0,90,0])
			color("white") cylinder(h = 2*wall, r = screw3/2,$fn=50);
	}
	if(Clamps) translate([40,-70,0]) beltclamp();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titan() { // extruder platform for e3d titan
	difference() {
		translate([0,-5.5,0]) color("cyan") cubeX([widthE,heightE+11,wall],radius=2,center=true); // extruder side
		//extmount();
		color("pink") hull() {	// hole for e3dv6, shifted to front by 11mm
			translate([-17.5+shifthotend2,-16+shifthotend,-10]) cylinder(h=20,d=e3dv6,$fn=100);
			translate([-45+shifthotend2,-16+shifthotend,-10]) cylinder(h=20,d=e3dv6,$fn=100);
		}
		translate([20,-5,-10]) color("white") cylinder(h=20,d=20,$fn=100); // remove some plastic under the motor
		translate([0,16,44]) rotate([90,0,0]) sidemounts();
		sensor_mount(); // mounting holes for sensor bracket
	}
	translate([0,-30,0]) rotate([90,0,90]) titanmotor(shifttitanup);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sidemounts() {	// mounting holes (copied from fan() & servo() modules
	translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 - fan_offset])
		rotate([0,90,0]) color("red") cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 - fan_offset])
		rotate([0,90,0]) color("white") cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sensor_mount() // sensor mount screw holes
{
	translate([spacing+shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("khaki") cylinder(h=20,r=screw3t/2,$fn=50);
	translate([shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("wheat") cylinder(h=20,r=screw3t/2,$fn=50);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titanmotor(ShiftUp=0) {
	difference() {	// motor mounting holes
		translate([-1,0,0]) color("purple") cubeX([54,50+ShiftUp,5],2);
		translate([25,25+ShiftUp,-1]) rotate([0,0,45]) color("salmon") NEMA17_x_holes(8, 2);
	}
	difference() { // front support
		translate([-1,20,-38]) rotate([56,0,0]) color("red") cubeX([4,50,60],2);
		translate([-3,-10,-48]) cube([7,70,50]);
		translate([-4,-49,-30]) cube([wall,50,70]);
		titanmotor_slots();
	}
	difference() { // rear support
		translate([49,20,-38]) rotate([56,0,0]) color("blue") cubeX([4,50,60],2);
		translate([47,-10,-48]) cube([7,70,50]);
		translate([47,-49,-30]) cube([wall,50,70]);
		titanmotor_slots();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titanmotor_slots() {
	color("cyan") hull() {
		translate([-10,33,6]) rotate([0,90,0]) cylinder(h=70,d=5,$fn=100);
		translate([-10,13,12]) rotate([0,90,0]) cylinder(h=70,d=16,$fn=100);
	}
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

module belt_drive2()	// corexy
{
	difference() {	// right wall
		translate([-wall+wall,0,0]) color("blue") cubeX([wall-2,40,23+belt_adjustUD],2);
		translate([-wall/2-2,belt_adjust,20+belt_adjustUD]) rotate([0,90,0])
			color("cyan") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-wall/2-2,belt_adjust,belt_adjustUD-3]) rotate([0,90,0])
			color("white") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([3.5,belt_adjust,22+belt_adjustUD-2]) rotate([0,90,0]) nut(nut3,3); // top
		translate([3.5,belt_adjust,belt_adjustUD-3]) rotate([0,90,0]) nut(nut3,3);	// bottom
	}
	beltbump2(0);
	difference() {	// left wall
		translate([35.4+wall/2,0,0]) color("white") cubeX([wall-2,40,23+belt_adjustUD],2);
		translate([32,belt_adjust,belt_adjustUD-3]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([32,belt_adjust,20+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([38.5,belt_adjust,belt_adjustUD-3]) rotate([0,90,0]) nut(nut3,3);
		translate([32,belt_adjust,20+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([38.5,belt_adjust,20+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
	}
	beltbump2(1);
	// rear wall
	difference() {
		translate([-wall/2+5,42-wall,0]) color("pink") cubeX([44,wall-2,belt_adjust+belt_adjustUD-2],2);
		wire_chain_mount();
	}
	// front wall
	translate([-wall/2+4,0,0]) color("cyan") cubeX([45,wall-2,belt_adjust],2);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module wire_chain_mount() {	// wire chain mounting holes
	translate([-wall/2+26,50-wall,20]) rotate([90,0,0]) color("red") cylinder(h=10,d=screw4t);
	translate([-wall/2+26,50-wall,10]) rotate([90,0,0]) color("blue") cylinder(h=10,d=screw4t);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module beltbump2(Bump) { // add a little plastic at the belt clamp screw holes at the top edge
	if(Bump) {
		difference() {	
			translate([39.4,belt_adjust,20+belt_adjustUD]) rotate([0,90,0])
				color("cyan") cylinder(h = wall-2, d = 2.6*screw3,$fn=50);
			translate([32,belt_adjust,20+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, d = screw3,$fn=50);
			translate([38.5,belt_adjust,20+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
		}
	} else {
		difference() {	
			translate([0,belt_adjust,20+belt_adjustUD]) rotate([0,90,0])
				color("pink") cylinder(h = wall-2, d = 2.6*screw3,$fn=50);
			translate([-wall/2-2,belt_adjust,20+belt_adjustUD]) rotate([0,90,0])
				cylinder(h = 2*wall, d = screw3,$fn=50);
			translate([3.5,belt_adjust,20+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
