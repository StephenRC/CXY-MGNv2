//////////////////////////////////////////////////////////////////////////
// blower.scad - adapter for blower fans to the extruder mounts
//////////////////////////////////////////////////////////////////////////
// created 5/21/2016
// last update 11/11/16
//////////////////////////////////////////////////////////////////////////
// 6/29/16 Made fan mount a bit thicker
// 7/19/16 Added adapter3() for corexy x-carriage extruder plate
// 8/26/16 Uses fanduct.scad see http://www.thingiverse.com/thing:387301
//		   Have it in the same folder as this file
// 9/30/16 Added adapter for the titan extruder setup, some vars and modules are from
//		   corexy-x-carriage.scad
// 11/11/16 Modified for CXY-MGNv2 printer
//////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>
use <fanduct.scad> // http://www.thingiverse.com/thing:387301
$fn=50;
//////////////////////////////////////////////////////////////////////////
// vars
//////////////////////////////////////////////////////////////////////////
thickness = 6.5;
Mheight = 6;
Mwidth = 40;
Fspace = 15;
Fwidth = Fspace + 6;
Fheight = 15;
thickness3 = 6.5;
Mheight3 = 6;
Mwidth3 = 60;
Fheight3 = 10;
Mwidth4 = 45;
// from corexy-x-carriage.scad ------------------------------------------------
wall = 8;		// thickness of the plates
width = 75;		// width of back/front/extruder plates
depthE = wall;	// thickness of the extruder plate
heightE = 60; 	// screw holes may need adjusting when changing the front to back size
extruder = 50;	// mounting hole distance
extruder_back = 18; // adjusts extruder mounting holes from front edge
fan_spacing = 32;	// hole spaceing for a 40mm fan
fan_offset = -6;  // adjust to align fan with extruder
servo_spacing = fan_spacing;
servo_offset = 20; // adjust to move servo mount
screw_depth = 25;
//////////////////////////////////////////////////////////////////////////

//rotate([90,0,0]) adapter();
//rotate([90,0,0]) adapter2();
//adapter3();
//translate([0,-20,0])
//	adaptertitan();
//translate([0,45,0])
//	adaptertitan2();
//translate([-15,0,0]) FanDuct();
//translate([-45,0,0]) FanDuct();
adapter_bowden();

/////////////////////////////////////////////////////////////////////////////////////////

module adapter_bowden() {
	difference() {
		cubeX([Mwidth4,Mheight3,thickness3],2);
		translate([Mwidth4/2-fan_spacing/2,10,thickness3/2]) fanmountingholes();
	}
	translate([Mwidth4/2-Fwidth/2,-Fwidth+9,0]) cubeX([Fwidth,Fwidth-6,thickness3]);
	translate([Mwidth4/2-Fwidth*2-0.5,-4.55,0]) rotate([90,0,0]) fanmounttitan();
}

/////////////////////////////////////////////////////////////////////////

module fanmountingholes() {
	rotate([90,0,0]) cylinder(h=20,d=screw3);
	translate([fan_spacing,0,0]) rotate([90,0,0]) cylinder(h=20,d=screw3);
}

//////////////////////////////////////////////////////////////////////////////

module adapter() {
	difference() {
		cube([Mwidth,Mheight,thickness]); 
		ext_mount();
	}
	fanmount();
}

module adapter2() {
	difference() {
		cube([Mwidth,Mheight,thickness]);
		ext_mount();
	}
	fanmount2();
}

module fanmount() { // mount the blower
	difference() {
		translate([Mwidth/2-3,0,thickness]) cube([Fwidth,thickness,Fheight]);
		translate([Mwidth/2,-1,Fheight-Fspace/2+1]) cube([Fspace,thickness+2,Fspace]);
		translate([Mwidth/2-5,thickness/2,Fheight]) rotate([0,90,0]) cylinder(h=Fwidth*2,r=screw4/2,$fn=50);
	}
}

module fanmount2() { // mount the blower
	difference() {
		translate([Mwidth/2-2.5,0,thickness]) cube([Fwidth,thickness,Fheight*2]);
		translate([Mwidth/2,-1,Fheight+Fspace/2]) cube([Fspace,thickness+2,Fspace]);
		translate([Mwidth/2-5,thickness/2,Fheight*2]) rotate([0,90,0]) cylinder(h=Fwidth*2,r=screw4/2,$fn=50);
		translate([Mwidth/2-5,thickness-1,Mheight-0.9]) rotate([-20,0,0]) cube([Fwidth+5,thickness,Fheight]);
	}
}

module ext_mount() {
	//mounting screw holes
	translate([8,thickness+2,thickness/2]) rotate([90,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
	translate([32,thickness+2,thickness/2]) rotate([90,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
}

module adapter3() {
	difference() {
		cube([Mwidth3,Mheight3,thickness3]);
		ext_mount3();
	}
	translate([6,7,0]) rotate([90,0,0]) fanmount3();
}

module ext_mount3() {	//mounting screw holes
	translate([5,thickness3+2,thickness3/2]) rotate([90,0,0]) cylinder(h=20,r=screw3/2,$fn=50);
	translate([21,thickness3+2,thickness3/2]) rotate([90,0,0]) cylinder(h=20,r=screw3/2,$fn=50);
}

module fanmount3() { // mount the blower
	difference() {
		translate([Mwidth3/2+2,0,thickness3]) cube([Fwidth,thickness3*3.5,Fheight3*2.5]);
		translate([Mwidth3/2+5,-1,Fheight3+1]) cube([Fspace,thickness3*3.5+2,Fspace*2]);
		translate([Mwidth3/2-5,thickness3/2+14,Fheight3*2+6]) rotate([0,90,0]) cylinder(h=Fwidth*2,r=screw4/2,$fn=50);
	}
}

module adaptertitan() { // stepper motor side
	translate([0,Mheight3,0]) rotate([0,0,180]) difference() {
		cubeX([Mwidth3,Mheight3,thickness3],2);
		translate([0,-25,48]) rotate([90,0,90]) mountingholes();
	}
	translate([-42,-Fwidth+9,0]) cubeX([Fwidth,Fwidth-6,thickness3]);
	translate([-74,-4.55,0]) rotate([90,0,0]) fanmounttitan();
}

module adaptertitan2() { // extruder cooling fan side
	translate([0,Mheight3,0]) rotate([0,0,180]) difference() {
		cubeX([Mwidth3,Mheight3+4,thickness3],2);
		translate([0,-25,48]) rotate([90,0,90]) mountingholes();
		translate([9,-9,-2]) cubeX([35,Fwidth-6,thickness3+4],2);
	}
	difference() {
		translate([-68,6,0]) rotate([90,0,0]) fanmounttitan(14);
		translate([-45,0,-2]) cubeX([35,Fwidth-6,thickness3+4],2);
		translate([-45,5,0.5]) rotate([40,0,0]) cubeX([35,Fwidth-6,thickness3+2],2);
	}
}

module fanmounttitan(Add=0) { // mount the blower
	difference() {
		translate([Mwidth3/2+2,0,thickness3-1]) cubeX([Fwidth,thickness3*2.7,Fheight3*1.7+Add]);
		translate([Mwidth3/2+5,-1,Fheight3]) cubeX([Fspace,thickness3*3.5+2,Fspace*2]);
		translate([Mwidth3/2,13,Fheight3*2-3+Add]) rotate([0,90,0]) cylinder(h=Fwidth*2,r=screw4/2,$fn=50);
	}
}

module mountingholes(Inner=0) {	// mounting holes (copied from fan() & servo() modules in corexy-x-carriage.scad)
	// outer holes
	translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw3/2,$fn=50);
	translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw3/2,$fn=50);
	// inner holes
	if(Inner) {
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw3/2,$fn=50);
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw3/2,$fn=50);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////