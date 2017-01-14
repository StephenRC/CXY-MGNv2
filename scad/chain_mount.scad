///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// chain_mount.scad - corexy with mgn12 rails
// created: 1/4/2017
// last modified: 1/4/2017
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/4/17	- frame mount for the wire chain, other end mounts to x-carriage, screw holes are M4 tapping size
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

chain_mount();
translate([60,10,0]) rotate([0,0,90]) chain_mount_extension();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module chain_mount() {
	difference() {
		translate([20,0,0]) color("blue") cubeX([20,5,83],2);
		translate([30,8,75]) rotate([90,0,0]) color("khaki") cylinder(h=10,d=screw4t);
		translate([30,8,65]) rotate([90,0,0]) color("darkkhaki") cylinder(h=10,d=screw4t);
	}
	translate([60,26.8,0]) rotate([0,0,180]) frame_mount();
	translate([27.5,-25,sq_d+12]) support();
}

module chain_mount_extension() {
	difference() {
		translate([20,0,0]) color("blue") cubeX([20,83,5],2);
		translate([30,75,-2]) color("khaki") cylinder(h=10,d=screw4t);
		translate([30,65,-2]) color("darkkhaki") cylinder(h=10,d=screw4t);
		translate([30,5,-2]) color("deeppink") cylinder(h=10,d=screw4);
		translate([30,15,-2]) color("hotpink") cylinder(h=10,d=screw4);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_sq_slots_m() { // square al slots
	color("Red") translate([50,104.5-sq_w,sq_d]) cube([150,sq_w,sq_d],true);		// horz
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module frame_mount(FullWrap=0) {
	difference() {
		if(FullWrap) color("lightgrey") cubeX([60,sq_w+10,sq_d+10],2); // install during main frame assembly
		else color("lightgrey") cubeX([60,sq_w+10,sq_d+6.1],2); // installable after main frame is assembled
		translate([100,100,-7]) rotate([0,0,180]) al_sq_slots_m();
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module support() {
	difference() {
		translate([0,34,-25.6]) rotate([24,0,0]) color("pink") cubeX([5,20,65],2);
		translate([-1,3,-20]) cube([7,25,70],2);
		translate([-1,22,-30]) cube([7,30,20],2);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////