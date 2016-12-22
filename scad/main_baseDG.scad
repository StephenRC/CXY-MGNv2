///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// main_baseDG.scad - drill guides for x-axis ends and spacers for a corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/20/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 12/17/16 - made this seperate to make a drill guide for metal mount place at each end of the x-axis for 2020
// 12/19/16 - added spacer for 2020 mount to position xy_bearings in the same position as the al slot version
//			  test fit 2020 and found the mgn mouting screws too close to the 2020, modified to use screws to hold
//			  spacer and riser together.  Made a spacer to fill in between mgn and al parts.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NOTES:
//	The small plate with the large center round hole is the spacer.  The other two are drill guides.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
belt_bearing_height = 20;
AL_thickness = 6.35;	// set to thickness of 1/4" al used for xy_spacer that can be trheaded
xy_spacer_2020_thickness = 10 - AL_thickness;	// amount needed to get xy_bearings in correct position
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

main_baseDG(0);  // set arg to 0 for one drill guide or 1 for two sets

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_baseDG(Two=0) {
	difference() {
		main_base(40,0,0,1);
		main_mounting(screw3);
		main_base_mounting2(-5);
	}
	if(Two) translate([-50,0,0]) {
		difference() {
			main_base(40,0,0,1);
			main_mounting(screw3);
			main_base_mounting2(-5);
		}
	}
	translate([50,0,0]) xy_spacer_2020(xy_spacer_2020_thickness);
	translate([50,30,0]) xy_spacer_2020(xy_spacer_2020_thickness);
	if(Two) {
		translate([-100,0,0]) main_base2();
		translate([-100,30,0]) main_base2();
	} else
		translate([-50,0,0]) main_base2();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_base2() {
	difference() {
		main_base(0,0,0,1);
		main_mounting(screw3t);
		mount2020_CS();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_mounting(ScrewSize=screw3,Depth=-2) {
	translate([5,7,Depth]) color("red") cylinder(h=20,d=ScrewSize,$fn=100);
	translate([40,22,Depth]) color("white") cylinder(h=20,d=ScrewSize,$fn=100);
	translate([5,22,Depth]) color("blue") cylinder(h=20,d=ScrewSize,$fn=100);
	translate([40,7,Depth]) color("green") cylinder(h=20,d=ScrewSize,$fn=100);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_base(Wider=0,Longer=0,NoHoles=0,Drill=0) { // main part that mounts on the mgn12h
	difference() {
		translate([-Longer/2,0,0]) cubeX([puck_l+Longer,puck_w+Wider,thickness],2);
		if(!NoHoles) main_base_mounting(Drill);
		mount2020();
		if(Wider) translate([0,hole_sep+3.5+belt_bearing_height,-2]) belt_holder_screws();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_base_mounting(Drill=0) {	// mounting holes to mgn12h
	color("red") translate([(puck_l/2)+(hole_sep/2),3.5,-9]) cylinder(h=thickness*3,d=screw3);
	color("blue") translate([(puck_l/2)-(hole_sep/2),3.5,-9]) cylinder(h=thickness*3,d=screw3);
	color("white") translate([(puck_l/2)+(hole_sep/2),hole_sep+3.5,-9]) cylinder(h=thickness*3,d=screw3);
	color("black") translate([(puck_l/2)-(hole_sep/2),hole_sep+3.5,-9]) cylinder(h=thickness*3,d=screw3);
	if(!Drill) {	// countersinks
		color("red") translate([(puck_l/2)+(hole_sep/2),3.5,thickness-1]) cylinder(h=thickness*5,d=screw3hd);
		color("blue") translate([(puck_l/2)-(hole_sep/2),3.5,thickness-1]) cylinder(h=thickness*5,d=screw3hd);
		color("white") translate([(puck_l/2)+(hole_sep/2),hole_sep+3.5,thickness-1]) cylinder(h=thickness*5,d=screw3hd);
		color("black") translate([(puck_l/2)-(hole_sep/2),hole_sep+3.5,thickness-1]) cylinder(h=thickness*5,d=screw3hd);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_base_mounting2(Depth=-2) {	// mounting holes to mgn12h
	color("red") translate([(puck_l/2)+(hole_sep/2),3.5,Depth]) cylinder(h=thickness*3,d=screw3hd);
	color("blue") translate([(puck_l/2)-(hole_sep/2),3.5,Depth]) cylinder(h=thickness*3,d=screw3hd);
	color("white") translate([(puck_l/2)+(hole_sep/2),hole_sep+3.5,Depth]) cylinder(h=thickness*3,d=screw3hd);
	color("black") translate([(puck_l/2)-(hole_sep/2),hole_sep+3.5,Depth]) cylinder(h=thickness*3,d=screw3hd);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mount2020() {
	translate([puck_l/2,puck_w/2,-2]) color("cyan") cylinder(h=20,d=screw5,$fn=100);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mount2020_CS() {
	translate([puck_l/2,puck_w/2,-2]) color("cyan") cylinder(h=20,d=screw5hd,$fn=100);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_holder_screws() {
	// taken from xy_bearing_mounts.scad and y modified to 10.5 less y than it is in xy_bearing_mounts.scad
	translate([10,1.5,-5]) color("red") cylinder(h=20,d=screw5,$fn=100);
	translate([10,13.5,-5]) color("blue") cylinder(h=20,d=screw5,$fn=100);
	translate([35,1.5,-5]) color("white") cylinder(h=20,d=screw5,$fn=100);
	translate([35,13.5,-5]) color("black") cylinder(h=20,d=screw5,$fn=100);
	color("red") hull() {  // belt hole
		translate([22.5,3,-3]) cylinder(h=20,d=15,$fn=100);
		translate([22.5,11,-3]) cylinder(h=20,d=15,$fn=100);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module xy_spacer_2020(Thick=xy_spacer_2020_thickness) {
	difference() {
		cubeX([puck_l,puck_w,Thick]); // use default radius of 1, if it gets to thin on 2, it grows in z
		translate([(puck_l-bearing_bracket_width)/2-3.7,0,2]) main_base_mounting();
		translate([(puck_l-bearing_bracket_width)/2-3.7,0,-5]) mount2020_CS();
		main_mounting(screw3,-8);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////