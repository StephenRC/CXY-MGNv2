//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 2/4/2019 - mgn12 slider mounting holes
// Last Uptate: 2/4/19
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
puck_l = 45.4;	// length of mgn12h
puck_w = 27;	// width of mgn12h
hole_sep = 20;	// distance between mouning holes on mgn12h
mgn_fh = 13;	// full height of mgn12h & rail assembly
mgn_rh = 8;	// height of mgn12 rail
mgn_rw = 12;	// width of mgn12 rail
mgn_oh = 7.5;	// overhange of mgn12h on the rail
MGNHoleLength = 15;
$fn=100;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

mgn_mounting_holes();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mgn_mounting_holes() {	// mounting holes to mgn12h
	color("red") translate([(puck_l/2)+(hole_sep/2),3.5,-9]) cylinder(h=MGNHoleLength,d=screw3);
	color("blue") translate([(puck_l/2)-(hole_sep/2),3.5,-9]) cylinder(h=MGNHoleLength,d=screw3);
	color("white") translate([(puck_l/2)+(hole_sep/2),hole_sep+3.5,-9]) cylinder(h=MGNHoleLength,d=screw3);
	color("black") translate([(puck_l/2)-(hole_sep/2),hole_sep+3.5,-9]) cylinder(h=MGNHoleLength,d=screw3);
	// countersinks
	color("red") translate([(puck_l/2)+(hole_sep/2),3.5,MGNHoleLength-10]) cylinder(h=MGNHoleLength,d=screw3hd);
	color("blue") translate([(puck_l/2)-(hole_sep/2),3.5,MGNHoleLength-10]) cylinder(h=MGNHoleLength,d=screw3hd);
	color("white") translate([(puck_l/2)+(hole_sep/2),hole_sep+3.5,MGNHoleLength-10]) cylinder(h=MGNHoleLength,d=screw3hd);
	color("black") translate([(puck_l/2)-(hole_sep/2),hole_sep+3.5,MGNHoleLength-10]) cylinder(h=MGNHoleLength,d=screw3hd);
}

////////////////////////end of mgn12.scad///////////////////////////////////////////////////////////////////////////////
