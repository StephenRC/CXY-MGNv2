////////////////////////////////////////////////////////////////////////////////////////////////////////////
// powersupply.scad - mount a pwoersupply to the cxy-mgnv2
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 12/1/2016
// last update 12/3/16
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 12/3/16 - Added mockup of p/s to check fit & added color
////////////////////////////////////////////////////////////////////////////////////////////////////////////
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
include <inc/screwsizes.scad>
$fn = 50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
//--------------------------------------------------------------------------
// power supply size & hole positions
width = 114;
length = 215;
height = 50;
hole_x1 = 33;
hole_x2 = 182.5;
hole_z1 = 12;
hole_z2 = 37;
//--------------------------------------------------------------------------
clearance = 0.6;		// additional clearance for AL parts
sq_w = 16.2+clearance;	// 1/2" Plywood u-channel AL width
sq_d = 12.7+clearance;	// 1/2" Plywood u-channel AL depth
ag_w = 19.1+clearance;	// 3/4" AL angle width
ag_t = 1.6+clearance;	// 3/4" AL angle thickness
spacing = 25; // vertical distance between mounting holes
d_spacing = hole_x2 - hole_x1; // horizontal distance between the mounting holes
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

mount();
//testps();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mount() {
	mountA();
	mountB();
	translate([0,30,0]) mountC();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mountA() {
	rotate([180,0,0]) al_mount(5);
	translate([5,-5,-10]) color("red") ps_mount(0,10);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mountB() {
	translate([100,0,0]) rotate([180,0,0]) al_mount(5);
	translate([d_spacing,-5,-5]) color("blue") ps_mount(-5,10);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mountC() {
	translate([0,7,-5]) rotate([180,0,0]) al_mount();
	translate([60,90.25,-5]) rotate([0,0,-90]) ps_mount2(-5);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ps_mount2(posZ) {
	difference() {
		translate([0,0,posZ]) color("cyan") cubeX([110,5,60],2);
		translate([2,0,5]) screw_v();
		hull() {
			translate([35,7,25]) rotate([90,0,0]) cylinder(h=10,d=30,$fn=100);
			translate([80,7,25]) rotate([90,0,0]) cylinder(h=10,d=30,$fn=100);
		}
	}
	translate([0,0,-13.3+posZ]) color("lightblue") cubeX([86.8,5,sq_d+5],2);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ps_mount(posZa,posZb) {
	translate([0,0,posZa]) difference() {
		cubeX([20,5,60],2);
		translate([0,0,posZb]) screw_v();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module screw_v() {
	translate([10,7,13]) rotate([90,0,0]) cylinder(h=90,d=screw4);
	translate([10,7,13+spacing]) rotate([90,0,0]) cylinder(h=90,d=screw4);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_mount(PosZ) {
	translate([0,0,PosZ]) difference() {
		color("lightgrey") cubeX([74,sq_w+10,sq_d+5],2);
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots_m();
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_sq_slots_m() { // square al slots
	color("Red") translate([50,104.5-sq_w,sq_d]) cube([150,sq_w,sq_d],true);		// horz
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

module ps() { // p/s model
	cube([length,width,height]);
	translate([hole_x1,130,hole_z1]) rotate([90,0,0]) cylinder(h=150,d=screw4);
	translate([hole_x2,130,hole_z1]) rotate([90,0,0]) cylinder(h=150,d=screw4);
	translate([hole_x1,130,hole_z2]) rotate([90,0,0]) cylinder(h=100,d=screw4);
	translate([hole_x2,130,hole_z2]) rotate([90,0,0]) cylinder(h=100,d=screw4);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module testps() {
	%ps();
	translate([18,119,-1.1]) mountA();
	//-----------------------------------------------------------
	translate([23,119,-1.1]) mountB();
	//-----------------------------------------------------------
	translate([-45,60,-1.1]) rotate([0,0,-90]) mountC();
}

///////////// end of powersupply.scad ////////////////////////////////////////////////////////////////////////////