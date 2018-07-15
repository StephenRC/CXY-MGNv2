///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// xy_bearing_mounts.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/18/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 12/17/16 - Added a version that uses a metal plate on each end and a 2020 for the x-axis.
// 12/18/16 - Adjusted mounting hole postions on 2020 version.
// 12/30/16 - Stiffened up rail_on_al() version and added a second screw to hold the x-axis al
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Supports needed to print rail_on_al() version
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// AL u-channel verion:
// Remove support after printing and use two screws that go all the way through to hole the al u-channel
//---------------------------------------------------------------------------------------------------------------------
// Metal plate version:
// Use main_baseDG.scad for the drill guide for the holes for the mounting.
// Make the plate the size of the drill guide and at least 1/8" thick.
// Four 5mm holes hold the belt holders onto the plate.
// Countersink 5mm hole for the 2020 for screw head clearance.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//rail_on_al();	// requires supports
rail_on_2020();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module rail_on_al() {
	xy_bearing_mounts();
	translate([-28,-27,-41.7]) xy_bearing_spacers(0);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module rail_on_2020() {
	xy_bearing_mounts_2020();
	translate([-28,-27,-41.7]) xy_bearing_spacers(1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module xy_bearing_mounts() {
	rotate([0,90,0]) 
		single_xy_bearing_mount(0);
	translate([90,0,0]) rotate([0,90,0]) single_xy_bearing_mount(1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module xy_bearing_mounts_2020() {
	rotate([0,90,0]) 
		single_xy_bearing_mount_2020(0);
	translate([50,0,0]) rotate([0,90,0]) single_xy_bearing_mount_2020(1);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_xy_bearing_mount_2020(Side=0) {
	difference() {
		translate([(puck_l-bearing_bracket_width)/2,puck_w+8,5]) rotate([180,0,0]) b_mount(Side,0);
		translate([10,12,-5]) color("red") cylinder(h=20,d=screw5,$fn=100);
		translate([10,24,-5]) color("blue") cylinder(h=20,d=screw5,$fn=100);
		translate([35,12,-5]) color("white") cylinder(h=20,d=screw5,$fn=100);
		translate([35,24,-5]) color("black") cylinder(h=20,d=screw5,$fn=100);
	}
	if(Side) {
		translate([13,15.5,0.5]) rotate([0,180,0]) printchar("L",2,5);
		translate([33,34.75,-1.5]) rotate([0,90,90]) printchar("U");
		translate([16,34.75,-1.5]) rotate([0,90,90]) printchar("D");
	} else {
		translate([13,15.5,0.5]) rotate([0,180,0]) printchar("R",2,5);
		translate([33,34.75,-1.5]) rotate([0,90,90]) printchar("U");
		translate([16,34.75,-1.5]) rotate([0,90,90]) printchar("D");
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_xy_bearing_mount(Side=0) {
	translate([0,-puck_w-7,-thickness]) {
		main_base(13,-7.4,0);
		difference() {
			translate([(puck_l/2)-((sq_w+10)/2),(puck_w/2)-((sq_d+10)/2),1]) al_mount();
			main_base_mounting();
		}
	}
	difference() {
		translate([(puck_l-bearing_bracket_width)/2,-puck_w-7,-4]) cubeX([bearing_bracket_width,40,2*wall-2],2);
		translate([(puck_l-bearing_bracket_width)/2-3.7,-puck_w-7,1]) main_base_mounting();
	}
	translate([(puck_l-bearing_bracket_width)/2,puck_w+8,5]) rotate([180,0,0]) b_mount(Side,0);
	//translate([(puck_l-bearing_bracket_width)/2,puck_w-26,1.5]) base();
	if(Side) {
		translate([10,-22,12]) rotate([0,-90,0]) printchar("L",2,5);
		translate([33,34.75,-1.5]) rotate([0,90,90]) printchar("U");
		translate([16,34.75,-1.5]) rotate([0,90,90]) printchar("D");
	} else {
		translate([10,-22,12]) rotate([0,-90,0]) printchar("R",2,5);
		translate([33,34.75,-1.5]) rotate([0,90,90]) printchar("U");
		translate([16,34.75,-1.5]) rotate([0,90,90]) printchar("D");
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module xy_bearing_spacers(Inline=0) {
	if(Inline) {
		translate([0,15,0]) rotate([0,0,-0]) bearspacer(one_stack);
		translate([15,15,0]) rotate([0,0,-0]) bearspacer(one_stack);
		translate([30,15,0]) rotate([0,0,-0]) bearspacer(one_stack);
		translate([45,15,0]) rotate([0,0,-0]) bearspacer(one_stack);
	} else {
		rotate([0,0,-0]) bearspacer(one_stack);
		translate([0,15,0]) rotate([0,0,-0]) bearspacer(one_stack);
		translate([15,0,0]) rotate([0,0,-0]) bearspacer(one_stack);
		translate([15,15,0]) rotate([0,0,-0]) bearspacer(one_stack);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_mount() { // holds x-axis to y-axis slider
	difference() {
		color("green") cubeX([sq_w+10,sq_d+10,26.5],2);
		color("red") translate([5,5,-1]) cube([sq_w,sq_d,35]);
	}
	translate([0,0,22]) difference() { // extra support of x-axis
		color("green") cubeX([sq_w+10,sq_d+5.3,56],2);
		color("red") translate([5,5,-1]) cube([sq_w,sq_d,60]);
		color("blue") translate([-5,puck_w/2-2,5+thickness/2]) rotate([0,90,0]) cylinder(h=sq_w+20,d=screw3);
		color("blue") translate([-5,puck_w/2-2,45+thickness/2]) rotate([0,90,0]) cylinder(h=sq_w+20,d=screw3);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_base(Wider=0,Longer=0,NoHoles=0) { // main part that mounts on the mgn12h
	difference() {
		translate([-Longer/2,0,0]) cubeX([puck_l+Longer,puck_w+Wider,thickness],2);
		if(!NoHoles) main_base_mounting();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_base_mounting() {	// mounting holes to mgn12h
	color("red") translate([(puck_l/2)+(hole_sep/2),3.5,-9]) cylinder(h=thickness*3,d=screw3);
	color("blue") translate([(puck_l/2)-(hole_sep/2),3.5,-9]) cylinder(h=thickness*3,d=screw3);
	color("white") translate([(puck_l/2)+(hole_sep/2),hole_sep+3.5,-9]) cylinder(h=thickness*3,d=screw3);
	color("black") translate([(puck_l/2)-(hole_sep/2),hole_sep+3.5,-9]) cylinder(h=thickness*3,d=screw3);
	// countersinks
	color("red") translate([(puck_l/2)+(hole_sep/2),3.5,thickness-1]) cylinder(h=thickness*5,d=screw3hd);
	color("blue") translate([(puck_l/2)-(hole_sep/2),3.5,thickness-1]) cylinder(h=thickness*5,d=screw3hd);
	color("white") translate([(puck_l/2)+(hole_sep/2),hole_sep+3.5,thickness-1]) cylinder(h=thickness*5,d=screw3hd);
	color("black") translate([(puck_l/2)-(hole_sep/2),hole_sep+3.5,thickness-1]) cylinder(h=thickness*5,d=screw3hd);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=4) { // print something
	linear_extrude(height = Height) text(String, font = "Liberation Sans",size=Size);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module b_mount(upper,spacers) {	// bearing mount bracket
	base();
	walls(upper,0);
	walls(upper,1);
	//translate([3,one_stack*2+7,belt_height+f625z_d+2]) rotate([90,0,0]) cylinder(h=belt_height,d=screw5);
	//translate([bearing_bracket_width-3,one_stack*2+7,belt_height+f625z_d+2]) rotate([90,0,0]) cylinder(h=belt_height,d=screw5);
	if(spacers) {	// don't need them for the test prints after the first print
		translate([-10,one_stack-2,0]) rotate([0,0,-0]) bearspacer(one_stack);
		translate([-10,one_stack*2,0]) rotate([0,0,-0]) bearspacer(one_stack);
	}
}

//////////////////////////////////////////////////////////////////////////////////////

module walls(upper,lower) {	// the walls that hold the bearings
	if(lower) {
		difference() {	// lower bearing support wall
			color("cyan") cubeX([bearing_bracket_width,5,belt_height+f625z_d+5],2);
			bearscrews(upper);
		}
	} else {
		difference() {	// upper bearing support wall
			color("lightblue") translate([0,one_stack*2+5,0]) cubeX([bearing_bracket_width,5,belt_height+f625z_d+5],2);
			bearscrews(upper);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////

module bearscrews(upper) {	// bearing screw holes
	if(upper) { // upper farther, lower closer
		translate([bearing_bracket_width-f625z_d/2-belt_offset,50,Ibelt_height+f625z_d/2+Ibelt_adjust])
			rotate([90,0,0]) color("red") cylinder(h=60,r=screw5/2);
		translate([f625z_d/2+belt_offset,50,Obelt_height+f625z_d/2+Obelt_adjust])
			rotate([90,0,0]) color("blue") cylinder(h=60,r=screw5/2);
	} else {	// upper closer, lower farther
		translate([bearing_bracket_width-f625z_d/2-belt_offset,50,Obelt_height+f625z_d/2+Obelt_adjust])
			rotate([90,0,0]) color("red") cylinder(h=60,r=screw5/2);
		translate([f625z_d/2+belt_offset,50,Ibelt_height+f625z_d/2+Ibelt_adjust])
			rotate([90,0,0]) color("blue") cylinder(h=60,r=screw5/2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////

module base() { // base mount
	difference() {
		translate([0,0,-thickness]) color("white") cubeX([bearing_bracket_width,one_stack*2+10,2*thickness],2);
		hull() {
			translate([18,13,-15]) cylinder(h=30,d=15,$fn=100);
			translate([18,21,-15]) cylinder(h=30,d=15,$fn=100);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////

module bearspacer(length=one_stack) {	// fill in the non-bearing space
	difference() {
		cylinder(h=length,r=screw5);
		translate([0,0,-1]) cylinder(h=length+5,r=screw5/2);
	}

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////