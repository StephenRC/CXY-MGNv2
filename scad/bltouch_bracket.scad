//////////////////////////////////////////////////////////////////////////////////////////////////////////
// z-probe-brackets.scad - brackets for a bltouch, mini ir & proximity sensor
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 11/27/2016
// last update 9/18/21
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// 12/5/16 - adjusted position to for the cxy-mgnv2 with a 1.75mm e3dv6
////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubex.scad>
$fn=50;
//////////////////////////////////////////////////////////////////////////////////////////////////////////
Use2p5mmInsert=1;
//---------------------------------------------------------------------------------------
// following are taken from https://miscsolutions.wordpress.com/mini-height-sensor-board
// it's used for the mounting holes on the CXY-MGNv2 bowden mount
hole1x = 2.70;
hole1y = 14.92;
hole2x = 21.11;
hole2y = 14.92;
holedia = 2.8;
//---------------------------------------------------------------------------------------
offset = 4;		// ir sensor mount hole distance (from bottom of the mount slot to the nozzle)
spacing = hole2x - hole1x; 	// extruder mount hole spacing
offset2 = 6;	// shift extruder mount holes
//-----------------------------------------------------------------------------------------
// https://www.indiegogo.com/projects/bltouch-auto-bed-leveling-sensor-for-3d-printers#/
blt_len = 36.3;
blt_width = 11.53;
blt_screw = screw3;
blt_mount_offset = 18;
blt_min_tip = 6;
blt_max_tip = 11;
blt_bd_dia  = 14;
//-----------------------------------------------------------------------------------------
mount_height = 21;	// height of the mount
mount_width = 31;	// width of the mount
thickness = 6;		// thickness of the mount
//----------------------------------------------------------------------------------------
psensor_d = 19;
psensor_nut_d = 28;
//------------------------------------------------------------------------------------------
offset_ir = 3.5;		// ir sensor mount hole distance (from bottom of the mount slot to the nozzle)
spacing_ir = 17; 	// extruder mount hole spacing (wilson II is 23)
offset2_ir = 7;	// shift extruder mount holes
notch_d_ir = 4;	// depth of notch to clear thru hole components
//-----------------------------------------------------------------------------------------
hotend_length = 50; // 50 for E3DV6
board_overlap = 2.5; // amount ir borad overlap sensor bracket
irboard_length = 17 - board_overlap; // length of ir board less the overlap on the bracket
ir_gap = 0;		// adjust edge of board up/down
//-----------------------------------------------------------------------------------------
mounty = hotend_length - irboard_length - ir_gap-3; // position of the ir mount holes from end
shift_reduce = 0;  // move hole up/down
////////////////////////////////////////////////////////////////////////////////////////////////////////////

adapter(0);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module adapter(Sensor=0) {
	if(Sensor==0) {
		%translate([28.5,13,18]) rotate([90,90,180]) blt(0); // show bltouch in position
		difference() {
			translate([0,mount_height-thickness,0]) cubeX([mount_width,thickness,mount_height+3],2);
			translate([2.5,16,17]) rotate([90,90,0]) blt_screw_mount(thickness+5);
			body();
		}
		base_mount();
	}
	if(Sensor==1) {
		rotate([-90,0,0]) { // lay it down for a better proximity hole when printed
			difference() {
				translate([0,mount_height-1.5*thickness,0]) cubeX([psensor_d+12,1.5*thickness,psensor_d+15],2);
				translate([15.5,25,19]) rotate([90,0,0]) cylinder(h=20,d=psensor_d,$fn=100);
				translate([15.5,14,19]) rotate([90,0,0]) cylinder(h=20,d=psensor_nut_d,$fn=6);
			}
			base_mount();
		}
	}
	if(Sensor==2) iradapter(0);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module base_mount() {
	difference() {
		cubeX([mount_width,mount_height,thickness],2); // mount base
		ext_mount();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module body() { // hole for the body
	translate([mount_width/2-7,mount_height/2+1,0]) cube([blt_bd_dia,10,blt_bd_dia+10]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ext_mount() // screw holes for mounting to extruder plate
{
	hull() { // slot it to make it easier to get the second screw started
		translate([spacing+offset2+2.5,5,-3]) rotate([0,0,0]) cylinder(h=25,r=screw3/2,$fn=50);
		translate([spacing+offset2-2,5,-3]) rotate([0,0,0]) cylinder(h=25,r=screw3/2,$fn=50);
	}
	hull() { // slot it to make it easier to get the second screw started
		translate([offset2+2,5,-3]) rotate([0,0,0]) cylinder(h=25,r=screw3/2,$fn=50);
		translate([offset2-2.5,5,-3]) rotate([0,0,0]) cylinder(h=25,r=screw3/2,$fn=50);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module blt_screw_mount(Len,Screw=blt_screw) {
	translate([blt_width/2-1,(blt_mount_offset+8)/2+blt_mount_offset/2,-Len/2-1]) color("pink") cylinder(h=Len,d=Screw);
	translate([blt_width/2-1,(blt_mount_offset+8)/2+blt_mount_offset/2-9,-Len/2-1]) color("plum") cylinder(h=Len,d=screw5);
	translate([blt_width/2-1,(blt_mount_offset+8)/2-blt_mount_offset/2,-Len/2-1]) color("gray") cylinder(h=Len,d=Screw);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module blt(Ext=0) { // simple model of the blt
	difference() {
		cube([blt_width,blt_mount_offset+8,2]);
		translate([blt_width/2,(blt_mount_offset+8)/2+blt_mount_offset/2,-1]) cylinder(h=5,d=blt_screw);
		translate([blt_width/2,(blt_mount_offset+8)/2-blt_mount_offset/2,-1]) cylinder(h=5,d=blt_screw);
	}
	translate([blt_width/2,(blt_mount_offset+8)/2,0]) cylinder(h=blt_len,d=8);
	if(Ext) translate([blt_width/2,(blt_mount_offset+8)/2,0]) cylinder(h=blt_len+blt_max_tip,d=screw2);
	else translate([blt_width/2,(blt_mount_offset+8)/2,0]) cylinder(h=blt_len+blt_min_tip,d=screw2);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module iradapter() {
	difference() {
		cubeX([mount_width,hotend_length - irboard_length - ir_gap,thickness],2); // mount base
		reduce_ir();
		block_mount();
		ext_mount_ir();
		recess_ir();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module recess_ir() { // make space for the thru hole pin header
	translate([hole1x+1.5+offset_ir,hole1y+2+((hotend_length - irboard_length - ir_gap)/4),notch_d_ir]) cube([15.5,10,5]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module reduce_ir() { // reduce amount of plastic used
	translate([15,hotend_length - irboard_length - ir_gap-18.5+shift_reduce,-1]) cylinder(h=10,r = mount_width/4);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module block_mount() // mounting screw holes for the ir sensor
{
	//mounting screw holes
	translate([hole1x+offset_ir,mounty,-5]) rotate([0,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
	translate([hole2x+offset_ir,mounty,-5]) rotate([0,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ext_mount_ir() // screw holes for mounting to extruder plate
{
	hull() {
		translate([spacing_ir+offset2_ir-1,5,-3]) rotate([0,0,0]) cylinder(h=20,r=screw3/2,$fn=50);
		translate([spacing_ir+offset2_ir+1,5,-3]) rotate([0,0,0]) cylinder(h=20,r=screw3/2,$fn=50);
	}
	hull() { // slot it to make it easier to get the second screw started
		translate([offset2_ir+1,5,-3]) rotate([0,0,0]) cylinder(h=20,r=screw3/2,$fn=50);
		translate([offset2_ir-1,5,-3]) rotate([0,0,0]) cylinder(h=20,r=screw3/2,$fn=50);
	}
}
///////////////////////////// end of bltouchbracket.scad ////////////////////////////////////////////////////