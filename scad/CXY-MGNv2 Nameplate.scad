///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CXY-MGNv2 Nameplate - nameplate for the printer
// created: 7/11/2018
// last modified: 7/14/18
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/configuration.scad> // http://github.com/prusajr/PrusaMendel, which also uses functions.scad & metric.scad
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
use <inc/Nema17.scad>	// https://github.com/mtu-most/most-scad-libraries
use <inc/corner-tools.scad>
use <b5_____.ttf>
$fn=50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//vars
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// "Babylon5:style=Regular" is b5_____.ttf
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

plate();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module plate() {
	difference() {
		color("cyan") cubeX([125,20,3]);
		translate([5,10,-5]) color("red") cylinder(h=10,d=screw3,$fn=100);
		translate([120,10,-5]) color("blue") cylinder(h=10,d=screw3,$fn=100);
		translate([9,4.5,1]) printchar("CXY-MGNV2",5,12);
	}	
}

/////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,TxtHeight=1,TxtSize=3.5) { // print something
	color("darkgray") linear_extrude(height = TxtHeight) text(String, font = "Babylon5:style=Regular",size=TxtSize,align="center");
}


///////////////// end of CXY-MSv1 Nameplate.scad ///////////////////////////////////////////////////////////////////////