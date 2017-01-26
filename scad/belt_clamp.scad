///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// belt_clamp.h - variable file for the CXY-MGNv2, a corexy with mgn12 rails
// created: 1/3/2017
// last modified: 1/25/2017
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/3/17	- removed what's here from the other x carriage belt files to have a common set of belt clamps.
//			  this file is called by use <belt_clamp.scad> in those files now.
//			  replaced minkowsi() with cubeX() to be consistent with the rest of the parts.
// 1/17/17	- added colors in preview for easier editing.
// 1/25/27	- added nut holes to all sides of the belt adjsuting screw holes and made the belt slots a bit deeper.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//beltclamp();  // keep this commented when not editing

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
		translate([-1,0,-wall/2+4.5]) color("lightcoral") cubeX([10,30,9],2);
		// belt notches
		translate([-1.5,5.5,7.75]) color("white") cube([11,7,3.5]);
		translate([-1.5,16.5,7.75]) color("blue") cube([11,7,3.5]);
		// mounting screw holes
		translate([4,3,-5]) color("red") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([4,26,-5]) color("white") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		// adjusting screw
		translate([-5,9,4.5]) rotate([0,90,0]) color("blue") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-2,9,4.5]) rotate([0,90,0]) color("salmon") nut(nut3,3);
		translate([7,9,4.5]) rotate([0,90,0]) color("green") nut(nut3,3);
		translate([-5,20,4.5]) rotate([0,90,0]) color("gray") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([7,20,4.5]) rotate([0,90,0]) color("black") nut(nut3,3);
		translate([-2,20,4.5]) rotate([0,90,0]) color("white") nut(nut3,3);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_anvil()
{
	translate([0,0,-3]) rotate([0,0,90]) difference() {
		rotate([0,90,0]) color("red") cylinder(h = 9, r = 4, $fn= 100);
		translate([3,0,-6]) color("white") cube([15,10,10],true);
		translate([4.5,0,-3]) color("blue") cylinder(h = 5, r = screw3/2,$fn = 50);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_roundclamp() // something round to let the belt smoothly move over when using the tensioner screw
{
	rotate([0,90,90]) difference() {
		color("red") cylinder(h = 30, r = 4, $fn= 100);
		translate([-6,0,3]) rotate([0,90,0]) color("white") cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([-6,0,26]) rotate([0,90,0]) color("black") cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([4.5,0,8]) color("gray") cube([2,8,45],true); // flatten the top & bottom
		translate([-4.5,0,8]) color("cyan") cube([2,8,45],true);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module nut(Size,Length) {
	cylinder(h=Length,d=Size,$fn=6);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
