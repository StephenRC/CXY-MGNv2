///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// prox_mount2.scad - mount on the x-carriage
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 12/30/2016
// last update 12/30/16
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubex.scad>
$fn=50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
psensord = 19;	// diameter of proximity sensor
widthE = 75;	// extruder plate width
wall = 8;		// thickness of the plates
// following are taken from https://miscsolutions.wordpress.com/mini-height-sensor-board
hole1x = 2.70;
hole1y = 14.92;
hole2x = 21.11;
hole2y = 14.92;
holedia = 2.8;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

rotate([0,-90,0])
//	prox_mount(0);
	ir_mount(0);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module prox_mount(Shift) {
	difference() {
		translate([0,0,0]) color("red") cubeX([30,30,5],2);
		translate([15,12,-2]) color("olive") cylinder(h=wall*2,d=psensord,$fn=100); // proximity sensor hole
	}
	difference() {
		translate([0,25,-13]) color("pink") cubeX([30,5,17],2);
		translate([15,12,-10]) color("azure") cylinder(h=wall*2,d=psensord+8.5,$fn=100); // proximity sensor nut clearance
	}
	difference() {
		translate([0,25,-13]) color("blue") cubeX([40,26+Shift,5],2);
		translate([3,20,-10]) rotate([0,0,0]) extmount();
	}
	support();
	support2();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module fan(Screw=screw3t,Left=1) {	// fan mounting holes
	if(Left) {
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = 3*(depthE+screw_depth),d = Screw,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = 3*(depthE+screw_depth),d = Screw,$fn=50);
	} else { // one side fan mounting holes
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = depthE+screw_depth,d = Screw,$fn=50);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = depthE+screw_depth,d = Screw,$fn=50);

	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module extmount() {		// screw holes to mount extruder plate
	//translate([0,30-wall/2,-10]) color("red") cylinder(h = 25, r = screw3/2, $fn = 50);
	translate([widthE/2-5,30-wall/2,-10]) color("white") cylinder(h = 25, r = screw3/2, $fn = 50);
	//translate([-(widthE/2-5),30-wall/2,-10]) color("blue") cylinder(h = 25, r = screw3/2, $fn = 50);
	translate([widthE/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, r = screw3/2, $fn = 50);
	//translate([-(widthE/4-2),30-wall/2,-10]) color("purple") cylinder(h = 25, r = screw3/2, $fn = 50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module support() {
	difference() {
		translate([0,34,-25.6]) rotate([50,0,0]) cubeX([5,20,25],2);
		translate([-1,8,-20]) cube([7,20,25],2);
		translate([-1,22,-30]) cube([7,25,20],2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module support2() {
	difference() {
		translate([25,32,-26.6]) rotate([46,0,0]) cubeX([5,20,25],2);
		translate([24,7,-19]) cube([7,20,25],2);
		translate([24,22,-32]) cube([7,25,20],2);
	}

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ir_mount(Shift) {
	translate([15,-5,0]) color("red") cubeX([15,35,5],2);
	translate([15,25,-13]) color("pink") cubeX([15,5,17],2);
	difference() {
		translate([15,25,-13]) color("blue") cubeX([26,26+Shift,5],2);
		translate([4,20,-10]) rotate([0,0,0]) extmount();
	}
	translate([-10,0,0]) support2();
	support2();
	difference() {
		translate([15,-4,-5]) cubeX([15,5,9]);
		translate([3,-1.5,-2]) rotate([0,90,0]) cylinder(h=40,d=screw3t);
	}
	difference() {
		translate([15,hole2x-4,-5]) cubeX([15,5,8]);
		translate([3,hole2x-1.5,-2]) rotate([0,90,0]) cylinder(h=40,d=screw3t);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

