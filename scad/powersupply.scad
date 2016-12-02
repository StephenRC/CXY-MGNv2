////////////////////////////////////////////////////////////////////////////////////////////////////////////
// powersupply.scad - mount a pwoersupply to the cxy-mgnv2
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 12/1/2016
// last update 12/1/16
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NOTE: Uses Digi-Key Part number: CCM1666-ND
//		 http://www.digikey.com/product-detail/en/te-connectivity-corcom-filters/1609112-3/CCM1666-ND/758835
//		 ---------------------------------------------------------------------------------------------------
//		 If the socket hole size changes, then the size & postions of the walls/wings & socket may need adjusting
//       The socket has screw mounting holes, after installing the socket, drill them with 2.5mm bit for M3 screws
//		 Cover uses three M3 screws, use M3 tap in holes on sock
///////////////////////////////////////////////////////////////////////////////////////////////////////////
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
include <inc/screwsizes.scad>
$fn = 50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
clearance = 0.6;		// additional clearance for AL parts
sq_w = 16.2+clearance;	// 1/2" Plywood u-channel AL width
sq_d = 12.7+clearance;	// 1/2" Plywood u-channel AL depth
ag_w = 19.1+clearance;	// 3/4" AL angle width
ag_t = 1.6+clearance;	// 3/4" AL angle thickness
spacing = 25; // vertical distance between mounting holes
d_spacing = 150; // horizontal distance between the mounting holes
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

mount();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mount() {
	rotate([180,0,0]) al_mount();
	translate([5,-5,-5]) ps_mount();
	translate([100,0,0]) rotate([180,0,0]) al_mount();
	translate([d_spacing,-5,-5]) ps_mount();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ps_mount() {
	difference() {
		cubeX([20,5,50],2);
		screw_v();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module screw_v() {
	translate([10,7,13]) rotate([90,0,0]) cylinder(h=90,d=screw4);
	translate([10,7,13+spacing]) rotate([90,0,0]) cylinder(h=90,d=screw4);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_mount() {
	difference() {
		color("lightgrey") cubeX([74,sq_w+10,sq_d+5],2);
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots_m();
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_sq_slots_m() { // square al slots
	color("Red") translate([50,104.5-sq_w,sq_d]) cube([150,sq_w,sq_d],true);		// horz
}


///////////// end of powersupply.scad ////////////////////////////////////////////////////////////////////////////