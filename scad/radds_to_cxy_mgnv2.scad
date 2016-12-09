/////////////////////////////////////////////////////////////////////////////////////////////////////
// radds_to_cxy_mgnv2.scad - convert from 2020 to al channel mount
/////////////////////////////////////////////////////////////////////////////////////////////////////
// created 12/1/2016
// last update 12/1/16
/////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/cubex.scad>
$fn=50;
/////////////////////////////////////////////////////////////////////////////////////////////////////
clearance = 0.6;		// additional clearance for AL parts
sq_w = 16.2+clearance;	// 1/2" Plywood u-channel AL width
sq_d = 12.7+clearance;	// 1/2" Plywood u-channel AL depth
ag_w = 19.1+clearance;	// 3/4" AL angle width
ag_t = 1.6+clearance;	// 3/4" AL angle thickness
/////////////////////////////////////////////////////////////////////////////////////////////////////

mount();

module mount() {
	import("RADDS-MK2020.stl");
	translate([3,-10,-16]) rotate([0,0,90]) al_mount();
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

///////////// end of radds_to_cxy_mgnv2.scad ////////////////////////////////////////////////////////////////////////
