///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// x_carriage_wades_belt.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/13/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

x_carriage_wades_belt(3);	// for BLTouch: 0 = top mounting through hole, 1 - recess mount
							// 2 - proximity sensor hole in psensord size
							// 3 or higher = none
translate([45,-20,-4]) beltclamp();
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_wades_belt(Type=4) {
	x_carriage_wades(Type,10);
	translate([17,35,-4]) x_carriage_belt3();
	//translate([35,10,0]) beltclamp();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_belt3() {
	difference() {
		translate([5,-24,5]) x_carriage_belt2(-45,10,0);
		translate([-40.5,-4,3]) main_base_mounting();
	}
	difference() {
		translate([-40,-14,0]) color("red") cubeX([45.5,40,wall+1],2);
		translate([-40.5,-4,3]) main_base_mounting();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_wades(recess=0,Length=0) // bolt-on extruder platform, works for either makerslide or lm8uu versions
{
	difference() {
		cubeX([widthE,heightE,wall],radius=2,center=true); // extruder side
		if(recess == 2) {
			translate([0,-height/3-6,0]) { // extruder notch
				minkowski() {
					cube([25,60,wall+5],true);
					cylinder(h = 1,r = 5,$fn=50);
				}
			}
		} else {
			translate([0,-height/3,0]) { // extruder notch
				minkowski() {
					cube([25,60,wall+5],true);
					cylinder(h = 1,r = 5,$fn=50);
				}
			}
		}
		// extruder mounting holes
		hull() {
			translate([extruder/2+2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
			translate([extruder/2-4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
		}
		hull() {
			translate([-extruder/2+4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
			translate([-extruder/2-2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
		}
		translate([0,28,41+wall/2]) rotate([90,0,0]) servo();
		translate([0,26,41+wall/2]) rotate([90,0,0]) fan();
		// BLTouch mounting holes
		if(recess == 1) {	// dependent on the hotend, for mounting under the extruder plate
			translate([-bltl/2+3,bltw/2+3,bltdepth]) minkowski() { // depression for BLTouch
				// it needs to be deep enough for the retracted pin not to touch bed
				cube([bltl-6,bltw-6,wall]);
				cylinder(h=1,r=3,$fn=100);
			}
			translate([-bltl/2+8,bltw/2,-5]) cube([bltd,bltd+1,wall+3]); // hole for BLTouch
			translate([bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
			translate([-bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
		}
		if(recess == 0) {	// for mounting on top of the extruder plate
			translate([-bltl/2+8,bltw/2,-5]) cube([bltd,bltd+1,wall+3]); // hole for BLTouch
			translate([bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
			translate([-bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
		}
		if(recess == 2) { // proximity sensor
			translate([0,10,-6]) cylinder(h=wall*2,r=psensord/2,$fn=50);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module servo()
{		// mounting holes
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module fan()
{		// mounting holes
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);

		//translate([-extruder/2,-heightE/2 - 1.8*wall+2,heightE - extruder_back]) // metal extruder cooling fan mount
			//rotate([0,0,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50); // one screw hole in front
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_belt2(PosX,PosY,PosZ,Dual) {
	translate([PosX,PosY,PosZ])	belt_drive2(Dual);
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module nut(Size,Length) {
	cylinder(h=Length,d=Size,$fn=6);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module beltclamp() // belt clamps and adjuster parts
{
	translate([0,0,3.5]) belt_roundclamp();
	translate([10,0,-0.5]) belt_adjuster();
	translate([25,0,4]) belt_anvil();
	translate([0,35,3.5]) belt_roundclamp();
	translate([10,35,-0.5]) belt_adjuster();
	translate([25,35,4]) belt_anvil();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_adjuster()
{
	difference() {
		minkowski() {
			translate([0,0,-wall/2+4.5]) cube([8,30,9]);
			cylinder(h = 1,r = 1,$fn=50);
		}
		translate([-1.5,5.5,9]) cube([11,7,3.5]);
		translate([-1.5,16.5,9]) cube([11,7,3.5]);
		translate([4,3,-5]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([4,26,-5]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-5,9,4.5]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-2,9,4.5]) rotate([0,90,0]) nut(nut3,3);
		translate([-5,20,4.5]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([7,20,4.5]) rotate([0,90,0]) nut(nut3,3);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_anvil()
{
	translate([0,0,-3]) rotate([0,0,90]) difference() {
		rotate([0,90,0]) cylinder(h = 9, r = 4, $fn= 100);
		translate([3,0,-6]) cube([15,10,10],true);
		translate([4,0,-3]) cylinder(h = 5, r = screw3/2,$fn = 50);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_roundclamp() // something round to let the belt smoothly move over when using the tensioner screw
{
	rotate([0,90,90]) difference() {
		cylinder(h = 30, r = 4, $fn= 100);
		translate([-6,0,3]) rotate([0,90,0])cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([-6,0,26]) rotate([0,90,0])cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([4.5,0,8]) cube([2,8,45],true); // flatten the top & bottom
		translate([-4.5,0,8]) cube([2,8,45],true);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////