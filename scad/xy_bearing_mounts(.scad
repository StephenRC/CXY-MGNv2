///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// xy_bearing_mounts(.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/13/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

xy_bearing_mounts();
translate([-28,-27,-41.7]) xy_bearing_spacers();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module xy_bearing_mounts() {
	rotate([0,90,0]) 
		single_xy_bearing_mount(0,0);
	translate([70,0,0]) rotate([0,90,0]) single_xy_bearing_mount(1,0);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_xy_bearing_mount(Side=0,YEndStop=0) {
	translate([0,-puck_w-7,-thickness]) {
		main_base(13,-7.4,0);
		difference() {
			translate([(puck_l/2)-((sq_w+10)/2),(puck_w/2)-((sq_d+10)/2),1]) al_mount();
			main_base_mounting();
		}
	}
	difference() {
		translate([(puck_l-bearing_bracket_width)/2,-puck_w-7,-4]) cubeX([bearing_bracket_width,40,wall+1],2);
		translate([(puck_l-bearing_bracket_width)/2-3.7,-puck_w-7,1]) main_base_mounting();
	}
	translate([(puck_l-bearing_bracket_width)/2,puck_w+8,5]) rotate([180,0,0]) b_mount(Side,0);
	if(Side) {
		translate([10,-22,10]) rotate([0,-90,0]) printchar("L",2,5);
		translate([33,34.75,-1.5]) rotate([0,90,90]) printchar("U");
		translate([16,34.75,-1.5]) rotate([0,90,90]) printchar("D");
	} else {
		translate([10,-22,10]) rotate([0,-90,0]) printchar("R",2,5);
		translate([33,34.75,-1.5]) rotate([0,90,90]) printchar("U");
		translate([16,34.75,-1.5]) rotate([0,90,90]) printchar("D");
	}
	if(YEndStop) y_endstop_strike();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module xy_bearing_spacers() {
	translate([0,0,0]) rotate([0,0,-0]) bearspacer(one_stack);
	translate([0,15,0]) rotate([0,0,-0]) bearspacer(one_stack);
	translate([15,0,0]) rotate([0,0,-0]) bearspacer(one_stack);
	translate([15,15,0]) rotate([0,0,-0]) bearspacer(one_stack);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module y_endstop_strike() { // not needed
	translate([0,0,thickness-4]) cubeX([5,puck_w,6],2); // extra bump for endstop to hit
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_mount() { // holds x-axis to y-axis slider
	difference() {
		color("green") cubeX([sq_w+10,sq_d+10,26.5],2);
		color("red") translate([5,5,-1]) cube([sq_w,sq_d,35]);
	}
	translate([0,0,22]) difference() { // extra support of x-axis
		color("green") cubeX([sq_w+10,sq_d+5.3,36],2);
		color("red") translate([5,5,-1]) cube([sq_w,sq_d,40]);
		color("blue") translate([-5,puck_w/2-2,10+thickness/2]) rotate([0,90,0]) cylinder(h=sq_w+20,d=screw3);
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
		color("white") cubeX([bearing_bracket_width,one_stack*2+10,thickness],2);
		hull() {
			translate([18,13,-3]) cylinder(h=20,d=15,$fn=100);
			translate([18,21,-3]) cylinder(h=20,d=15,$fn=100);
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