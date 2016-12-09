//////////////////////////////////////////////////////////////////////////////////////////////////////////
// bltouchbracket.scad - bracket for a bltouch
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 11/27/2016
// last update 12/5/2016
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// 12/5/16 - adjusted position to for the cxy-mgnv2 with a 1.75mm e3dv6
/////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubex.scad>
$fn=50;
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
//---------------------------------------------------------------------------------------
// following are taken from https://miscsolutions.wordpress.com/mini-height-sensor-board
// it's used for the mounting holes on the CXY-MGNv2 bowden mount
hole1x = 2.70;
//hole1y = 14.92;
hole2x = 21.11;
//hole2y = 14.92;
//holedia = 2.8;
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////

adapter(0);  // 1 - show bltouch mockup

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module adapter(BLT=0) {
	if(BLT) translate([28.5,16,17]) rotate([90,90,180]) blt(0);
	difference() {
		cubeX([mount_width,mount_height,thickness],2); // mount base
		ext_mount();
	}
	difference() {
		translate([0,mount_height-thickness,0]) cubeX([mount_width,thickness,mount_height+3],2); // mount base
		translate([2.5,16,17]) rotate([90,90,0]) blt_screw_mount(thickness+5);
		body();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

module blt_screw_mount(Len) {
	translate([blt_width/2-1,(blt_mount_offset+8)/2+blt_mount_offset/2,-Len/2-1]) cylinder(h=Len,d=blt_screw);
	translate([blt_width/2-1,(blt_mount_offset+8)/2-blt_mount_offset/2,-Len/2-1]) cylinder(h=Len,d=blt_screw);
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

///////////////////////////// end of bltouchbracket.scad ////////////////////////////////////////////////////