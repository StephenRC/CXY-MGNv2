////////////////////////////////////////////////////////////////////////////////////////////////////////////
// powersocket.scad - uses a pc style power socket with switch
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 7/4/2016
// last update 1/12/17
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/4/16	- Added cover
// 8/5/16	- adjusted cover & 2020 mounting holes
// 12/3/16	- Modified for cxy-mgnv2 & added colors
// 12/8/16	- Added relief for the the tabs that hold in the socket.
// 1/4/17	- Added a power switch holder for a rectangular switch
// 1/12/17	- Added a label to the power switch mount
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NOTE: Old vars uses Digi-Key Part number: CCM1666-ND
//		 http://www.digikey.com/product-detail/en/te-connectivity-corcom-filters/1609112-3/CCM1666-ND/758835
//		 ---------------------------------------------------------------------------------------------------
//		 If the socket hole size changes, then the size & postions of the walls & socket may need adjusting
//       The old socket has screw mounting holes, after installing the socket, drill them with 2.5mm bit for M3 screws
//		 Cover uses three M3 screws, use M3 tap in holes on socket
///////////////////////////////////////////////////////////////////////////////////////////////////////////
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
include <inc/screwsizes.scad>
use <BABIND.TTF>	// true type font used for the label
$fn = 50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
s_width = 32;//40;	// socket hole width
s_height = 28;//27;	// socket hole height
socket_shift = 0; // move socket left/right
socket_s_shift = 0; // move socket up/down
//-----------------------------------------------------------------
clearance = 0.6;		// additional clearance for AL parts
sq_w = 16.2+clearance;	// 1/2" Plywood u-channel AL width
sq_d = 12.7+clearance;	// 1/2" Plywood u-channel AL depth
ag_w = 19.1+clearance;	// 3/4" AL angle width
ag_t = 1.6+clearance;	// 3/4" AL angle thickness
///////////////////////////////////////////////////////////////////////////////////////////////////////////

all();
//testfit();	// print part of it to test fit the socket
//switch();		// 3 args: width, length, clip thickness; defaults to 13,19.5,2

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module all() {
	sock();
	translate([0,8,45]) rotate([180,0,0]) cover();
	translate([18,95,0]) switch();		// 3 args: width, length, clip thickness; defaults to 13,19.5,2
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module sock() {
	difference() {
		color("cyan") cubeX([s_width+40,s_height+40,5],2); // base
		// socket hole
		translate([s_width/2+socket_shift,s_height/2+14+socket_s_shift,-2]) color("blue") cube([s_width,s_height,10]);
		translate([s_width,9,-2]) cylinder(h=10,r=screw5/2); // center 2020 mounting hole
		translate([s_width/2+socket_shift-3,s_height/2+14+socket_s_shift,2]) color("blue") cube([s_width+6,s_height,10]);
	}
	difference() { // top wall
		translate([0,s_height+35,0]) color("pink") cubeX([s_width+40,5,40],2);
		translate([s_width,62,22]) cylinder(h=20,d=screw3t); // top screw hole
	}
	difference() { // left wall
		translate([0,19,0]) color("lightblue") cubeX([5,s_height+21,40],2);
		translate([5,40,22]) cylinder(h=25,d=screw3t); // left
	}
	difference() { // right wall
		translate([s_width+35,19,0]) color("lime") cubeX([5,s_height+21,40],2);
		translate([s_width+35,40,22]) cylinder(h=25,d=screw3t); // right
	}
	coverscrewholes();
	translate([0,-2,0]) al_mount();
}

//////////////////////////////////////////////////////////////////

module coverscrewholes() {
	difference() {
		translate([5,40,20]) color("cyan") cylinder(h=20,d=screw5); // left
		translate([5,35,13]) rotate([0,-45,0]) cube([10,10,5]);
		translate([5,40,22]) cylinder(h=25,d=screw3t); // left
	}
	difference() {
		translate([s_width+35,40,20]) color("pink") cylinder(h=20,d=screw5); // right
		translate([s_width+27,35,22]) rotate([0,45,0]) cube([10,10,5]);
		translate([s_width+35,40,22]) cylinder(h=25,d=screw3t); // right
	}
	difference() {
		translate([s_width,62,20]) color("lightblue") cylinder(h=20,d=screw5); // top screw hole
		translate([s_width-5,55,20]) rotate([-45,0,0]) cube([10,10,5]);
		translate([s_width,62,22]) cylinder(h=25,d=screw3t); // top screw hole
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module testfit() { // may need adjusting if the socket size is changed
	difference() {
		sock();
		translate([-28,-10,-5]) cube([s_width+90,s_height,50]); // walls around socket only
		translate([-28,-2,-2]) cube([s_width+90,s_height+50,5]); // remove some from bottom
		translate([-28,-2,6]) cube([s_width+90,s_height+50,50]); // shorten vertical 2020 wings
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module cover() {
	difference() {
		translate([0,13.9,40]) color("cyan") cubeX([s_width+40,s_height+26,5],2); // base
		translate([5,40,30]) color("blue") cylinder(h=20,d=screw3); // left
		translate([s_width+35,40,30]) color("red") cylinder(h=20,d=screw3); // right
		translate([s_width,62,30]) color("yellow") cylinder(h=20,d=screw3); // top
	}
	difference() {
		translate([0,13.9,25]) color("lightblue") cubeX([s_width+40,5,20],2); // short wall
		color("purple") hull() {
			translate([s_width,25,30]) rotate([90,0,0]) cylinder(h=15,d=10);
			translate([s_width,25,25]) rotate([90,0,0]) cylinder(h=15,d=10);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_mount() {
	difference() {
		color("lightgrey") cubeX([72,sq_w+10,sq_d+5],2);
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots_m();
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_sq_slots_m() { // square al slots
	color("Red") translate([50,104.5-sq_w,sq_d]) cube([150,sq_w,sq_d],true);		// horz
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module switch(s_w=13,s_l=19.5,s_t=2) {
	difference() {
		color("cyan") cubeX([s_l+15,s_w+15,5],2);
		translate([s_l/2-2,s_w/2+1,-2]) color("pink") cube([s_l,s_w,8]);
		translate([s_l/2-3.5,s_w/2+1,s_t]) color("red") cube([s_l+3,s_w,8]);
		switch_label();
	}
	translate([0,-2,0]) color("blue") cubeX([5,s_l+11,s_w+15],2);
	translate([s_l+10,-2,0]) color("salmon") cubeX([5,s_l+11,s_w+15],2);
	translate([s_l-18,s_w+10.5,0]) color("tan") cubeX([s_l+13,5,s_w+15],2);
	difference() {
		translate([s_l-18,-2,0]) color("brown") cubeX([s_l+13,5,s_w+15],2);
		switch_label();
	}
	difference() {
		translate([-18,-23,0]) al_mount();
		switch_label();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module switch_label() {
	translate([5.5,3,1]) rotate([180,0,0]) printchar("POWER",2,4);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=4) { // print something
	color("black") linear_extrude(height = Height) text(String, font = "Babylon Industrial:style=Normal",size=Size);
}

//////////////// end of powersocket.scad ///////////////////////////////////////////////////////////////////////////
