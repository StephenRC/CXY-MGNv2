////////////////////////////////////////////////////////////////////////////////////////////////////////////
// powersocket.scad - uses a pc style power socket with switch
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 7/4/2016
// last update 8/5/16
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/4/16 - Added cover
// 8/5/16 - adjusted cover & 2020 mounting holes
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
s_width = 40;	// socket hole width
s_height = 27;	// socket hole height
socket_shift = 0; // move socket left/right
socket_s_shift = 0; // move socket up/down
///////////////////////////////////////////////////////////////////////////////////////////////////////////

sock();
translate([0,8,45]) rotate([180,0,0])
	cover();
//testfit();	// print part of it to test fit the socket & 2020
//supply();

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module supply() { // brackets for power supply
	// on todo list
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sock() {
	difference() {
		cubeX([s_width+40,s_height+40,5],2); // base
		translate([s_width/2+socket_shift,s_height/2+14+socket_s_shift,-2]) cube([s_width,s_height,10]); // socket hole
		translate([s_width,9,-2]) cylinder(h=10,r=screw5/2); // center 2020 mounting hole
	}
	difference() {
		translate([0,s_height+35,0]) cubeX([s_width+40,5,40],2); // top wall
		translate([s_width,62,22]) cylinder(h=20,d=screw3t); // top screw hole
	}
	difference() {
		translate([0,19,0]) cubeX([5,s_height+21,40],2); // left wall
		translate([5,40,22]) cylinder(h=25,d=screw3t); // left
	}
	difference() {
		translate([s_width+35,19,0]) cubeX([5,s_height+21,40],2); // right wall
		translate([s_width+35,40,22]) cylinder(h=25,d=screw3t); // right
	}
	difference() { // right wing
		translate([s_width+35,19,0]) cubeX([25,5,25],2); // wall
		translate([s_width+50,26,15]) rotate([90,0,0]) cylinder(h=10,r=screw5/2); // 2020 mounting hole
	}
	difference() { // left wing
		translate([-20,19,0]) cubeX([25,5,25],2); // wall
		translate([-10,26,15]) rotate([90,0,0]) cylinder(h=10,r=screw5/2); // 2020 mounting hole
	}
	coverscrewholes();
	difference() {
		translate([-20,0,0]) cubeX([25,23,5],2); // left wing base filler
		translate([-10,9,-2]) cylinder(h=10,r=screw5/2); // 2020 mounting hole
	}
	difference() {
		translate([s_width+35,0,0]) cubeX([25,23,5],2);	// right wing base filler
		translate([s_width+50,9,-2]) cylinder(h=10,r=screw5/2); // 2020 mounting hole
	}
}

//////////////////////////////////////////////////////////////////

module coverscrewholes() {
	difference() {
		translate([5,40,20]) cylinder(h=20,d=screw5); // left
		translate([5,35,13]) rotate([0,-45,0]) cube([10,10,5]);
		translate([5,40,22]) cylinder(h=25,d=screw3t); // left
	}
	difference() {
		translate([s_width+35,40,20]) cylinder(h=20,d=screw5); // right
		translate([s_width+27,35,22]) rotate([0,45,0]) cube([10,10,5]);
		translate([s_width+35,40,22]) cylinder(h=25,d=screw3t); // right
	}
	difference() {
		translate([s_width,62,20]) cylinder(h=20,d=screw5); // top screw hole
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
		translate([0,15,40]) cubeX([s_width+40,s_height+27,5],2); // base
		translate([5,42,30]) cylinder(h=20,d=screw3); // left
		translate([s_width+35,42,30]) cylinder(h=20,d=screw3); // right
		translate([s_width,64,30]) cylinder(h=20,d=screw3); // top
	}
	difference() {
		translate([0,15,25]) cubeX([s_width+40,5,20],2); // base
		hull() {
			translate([s_width,25,30]) rotate([90,0,0]) cylinder(h=15,d=10);
			translate([s_width,25,25]) rotate([90,0,0]) cylinder(h=15,d=10);
		}
	}
}

//////////////// end of powersocket.scad /////////////////////////
