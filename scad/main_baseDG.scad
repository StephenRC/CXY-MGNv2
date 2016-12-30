///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// main_baseDG.scad - drill guides for x-axis ends and spacers for a corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/26/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 12/17/16 - made this seperate to make a drill guide for metal mount place at each end of the x-axis for 2020
// 12/19/16 - added spacer for 2020 mount to position xy_bearings in the same position as the al slot version
//			  test fit 2020 and found the mgn mouting screws too close to the 2020, modified to use screws to hold
//			  spacer and riser together.  Made a spacer to fill in between mgn and al parts.
// 12/24/16 - added code to check screw hole alignment
// 12/26/16 - made the mgn screw holes on the xy_spacers to pass the screw head.
//			  added labels.
// 12/27/16 - slotted M5 head clearance hole in spacers to allow assembly when printer frame is already together.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NOTES:
//	The pair of plates on the right are the spacers.  The other two are the drill guides.
//  1/4" Aluminum for the two plates. Needs to be thick enough to have sufficient threads to hold the parts together.
//  3.5mm bit for the holes the M3 screws pass through.
//  2.5mm bit for the M3 tapped holes in the small bottom plate.
//  5mm bit for the holes for the 2020 and xy_bearing holders.
//  After mounting the assemblies to the mgn, measure the length needed for the 2020 for the x-axis.
//---------------------------------------------------------------------------------------------------------------------
// Drill Guide MGN Mount: outer four are tapped for M3, inner four drilled 3.5mm, large hole to fit a M5 screw head
// Drill Guide 2020 XY: upper four are M5, lower outer are 3.5, lower center is 5mm, oblong hole to size in the guide
// Spacer (printed part): outer four are 3.5mm, inner four to clear M3 screw heads, large center to clear M5 screw head
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
screw3_5 = screw3 + 0.5; // they need a little wiggle room
belt_bearing_height = 20;
AL_thickness = 6.35;	// set to thickness of 1/4" al used for xy_spacer
xy_spacer_2020_thickness = 10 - AL_thickness;	// amount needed to get xy_bearings in correct position
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//main_baseDG(0,0);	// set first arg to 0 for one drill guide or 1 for two sets
					// second arg to 1 to test fit the parts
spacers_only();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_baseDG(Two=0,Test=0) {
	difference() {
		main_base(40,0,1,1);
		main_mounting(screw3_5);
		if(xy_spacer_2020_thickness < 3) main_base_mounting2(-5);
		translate([10,30,thickness-1.5]) printchar("Drill Guide");
		translate([5,11,thickness-1.5]) printchar("2020         XY");
	}
	if(Two) translate([-50,0,0]) {
		difference() {
			main_base(40,0,1,1);
			main_mounting(screw3_5);
			if(xy_spacer_2020_thickness < screw3hd_t) main_base_mounting2(-5);
			translate([10,30,thickness-1.5]) printchar("Drill Guide");
			translate([5,11,thickness-1.5]) printchar("2020         XY");
		}
	}
	translate([50,0,0]) xy_spacer_2020(xy_spacer_2020_thickness);
	if(!Test)
		translate([50,30,0]) xy_spacer_2020(xy_spacer_2020_thickness);
	else
		translate([0,0,-AL_thickness-2]) xy_spacer_2020(xy_spacer_2020_thickness);
	if(Two) {
		translate([-100,0,0]) main_base2();
		translate([-100,30,0]) main_base2();
	} else {
		if(!Test)
			translate([-50,0,0]) main_base2();
		else
			translate([0,0,-5]) main_base2();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module spacers_only() {
	xy_spacer_2020(xy_spacer_2020_thickness);
	translate([0,30,0]) xy_spacer_2020(xy_spacer_2020_thickness);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_base2() {
	difference() {
		main_base(0,0,0,1);
		main_mounting(screw3t);
		mount2020_CS();
		translate([4,15,thickness-1.5]) printchar("Drill          Guide");
		translate([4,10,thickness-1.5]) printchar("MGN        Mount");
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_mounting(ScrewSize=screw3_5,Depth=-2) {
	translate([5,7,Depth]) color("red") cylinder(h=20,d=ScrewSize,$fn=100);
	translate([40,22,Depth]) color("white") cylinder(h=20,d=ScrewSize,$fn=100);
	translate([5,22,Depth]) color("blue") cylinder(h=20,d=ScrewSize,$fn=100);
	translate([40,7,Depth]) color("green") cylinder(h=20,d=ScrewSize,$fn=100);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_base(Wider=0,Longer=0,NoHoles=0,Drill=0) { // main part that mounts on the mgn12h
	difference() {
		translate([-Longer/2,0,0]) {
			if(Wider) color("salmon") cubeX([puck_l+Longer,puck_w+Wider,thickness],2);
			else color("lightblue") cubeX([puck_l+Longer,puck_w+Wider,thickness],2);
		}
		if(!NoHoles) main_base_mounting(Drill);
		mount2020();
		if(Wider) translate([0,hole_sep+3.5+belt_bearing_height,-2]) belt_holder_screws();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_base_mounting(Drill=0) {	// mounting holes to mgn12h
	color("red") translate([(puck_l/2)+(hole_sep/2),3.5,-9]) cylinder(h=thickness*3,d=screw3_5);
	color("blue") translate([(puck_l/2)-(hole_sep/2),3.5,-9]) cylinder(h=thickness*3,d=screw3_5);
	color("white") translate([(puck_l/2)+(hole_sep/2),hole_sep+3.5,-9]) cylinder(h=thickness*3,d=screw3_5);
	color("black") translate([(puck_l/2)-(hole_sep/2),hole_sep+3.5,-9]) cylinder(h=thickness*3,d=screw3_5);
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

module xy_spacer_2020(Thick) {
	difference() {
		color("cyan") cubeX([puck_l,puck_w,Thick]); // use default radius of 1, if it gets to thin on 2, it grows in z
		translate([(puck_l-bearing_bracket_width)/2-3.7,0,2]) main_base_mounting();
		hull() {
			translate([(puck_l-bearing_bracket_width)/2-3.7,0,-5]) mount2020_CS();
			translate([(puck_l-bearing_bracket_width)/2-3.7,20,-5]) mount2020_CS();
		}
		main_mounting(screw3_5,-8);
		main_base_mounting2(-5);
		translate([1.5,12,thickness-2.5]) printchar("SPC",1.5,5);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=4) { // print something
	linear_extrude(height = Height) text(String, font = "Liberation Sans",size=Size);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////