///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// mgn12.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/7/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
// The x-carriage is currently for Titan+E3VD6 & Bowden+E3DV6 using Titan
//---------------------------------------------------------------------------------------------------------------------
// 10/31/16 - mgn12.scad is based on CXY-MSv1 printer files
// 11/10/16 - Commented out the mounting screw holes in single_upper_bracket(), single_lower_bracket(), and
//			  angled_brackets() since they're going to be drilled when making the screw holes in the aluminum
//			  Tweaked angled supports on motor_upper_brackets()
// 11/11/16 - Added belt to x_carraiges and z-axis brackets and adjusted ir & fan mounts on bowden mount and adjusted
//			  motor position on bowden_titan().  Added blower.scad & fanduct.scad files
// 11/12/16 - Split the folowing into two parts that are held together by screws: x_carriage_titan_belt(),
//			  x_carriage_e3dv6_bowden, x_carriage_e3dv6_bowden_belt() and x_carriage_wades()
//			  Made plate() to make it easy to make each section of parts
// 11/13/16 - Made v2 upper/lower brackets to use less plastic and print faster
// 11/20/16 - Adjusted motor_upper_brackets, bowden carraige belt position
// 11/23/16 - Added a dual bowden setup, front/rear of x-axis carriage mounting
// 11/25/16 - Designed v3 of motor upper brackets where the motor mounts are a separate part so now it uses less
//			  filament for supports.  The idler upper brackets the idler mounts were moved inline with the main
//			  part and the idler spacers were made longer.
// 11/26/16 - Added ability to adjust z of second bowden extruder, but not fully implemented.
// 11/27/16 - Changed bearing spacers for idler upper to tapered spacers.  Added irsensorbracket.scad
// 11/28/16 - Made lower brackets shorter and rotated verticals to match the uppers.
// 11/29/16 - Made motor upper brackets shorter.
// 12/1/16  - Tuned bearing positions.  Made xy_bearing_mounts longer to support the x-axis better.
// 12/2/16  - Added built in support for extended al slot in xy_bearing_mounts and labeled L & R.
// 12/7 /16 - Labeled motor upper brackets & motor mounts L & R.  Changed the angled supports on the corner brackets
//			  to open braces.
// 12/8/16  - Changed all wades mounts to mount with the mgn on top.
//---------------------------------------------------------------------------------------------------------------------
// NOTES:
// Some of the parts need support added in the slicer.
// Use #4x1/2" self drilling sheet metal screws for holding aluminum in brackets
// The printed angled_brackets() may be replaced by angled aluminum, slot in the corner and bend one side accordingly
// and use two screws at each end
// Blower fan mounts are in blower.scad, blower fan nozzle in fanduct.scad
// The v3 motor upper mounts use three M5 screws and two of them go through the aluminum u-channel.
// Remove the built in support for extended al slot in xy_bearing_mounts after printing.
// X & Y enstops mount directly on the aluminum holding the mgn rail.
//--------------------------------------------------------------------------------------------------------------------
// THINGS TO DO:
// Check & adjust z on dual bowden e3dv6 mount, ir not needed on second mount
// Need adjustable ir mount length for bowden & wades
// IDEX
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
use <inc/Nema17.scad>	// https://github.com/mtu-most/most-scad-libraries
$fn=50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// variables
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
puck_l = 45.4;	// length of mgn12h
puck_w = 27;	// width of mgn12h
hole_sep = 20;	// distance between mouning holes on mgn12h
mgn_fh = 13;	// full height of mgn12h & rail assembly
mgn_rh = 8;		// height of mgn12 rail
mgn_rw = 12;	// width of mgn12 rail
mgn_oh = 7.5;	// overhange of mgn12h on the rail
idler_upper_spacer_height = 18;
psensord = 19;	// diameter of proximity sensor (x offset is 0)
//------------------------------------------------------------------------------------------------
bearing_bracket_width = 38;	// width of the xy bearing bracket
f625z_d = 16;		// diameter of bearing where the belt rides
Obelt_height = 20;//26;	// how far out from the carriage plate the inner belt is on the sides
Ibelt_height = 11;//17;	// how far out from the carriage plate the outer belt is on the sides
belt_height = Obelt_height+2; // height of walls
belt_offset = 2.5;	// adjust distance between inner & outer belts bearings
belt = 10;			// belt width (used in base() to make the large center hole)
Ibelt_adjust = -2;	// adjust inner belt bearing postion (- closer to plate, + farther away)
Obelt_adjust = 2;	// adjust outer belt bearing postion (- closer to plate, + farther away)
one_stack = 11.78;	// just the length of two washers & two F625Z bearings
//---------------------------------------------------------------------------------------------------
clearance = 0.6;		// additional clearance for AL parts
sq_w = 16.2+clearance;	// 1/2" Plywood u-channel AL width
sq_d = 12.7+clearance;	// 1/2" Plywood u-channel AL depth
ag_w = 19.1+clearance;	// 3/4" AL angle width
ag_t = 1.6+clearance;	// 3/4" AL angle thickness
//---------------------------------------------------------------------------------------------------
e3dv6 = 35;			// hole for e3dv6
shifttitanup = 0;	// move motor up/down
shifthotend = 0;	// move hotend opening front/rear
shifthotend2 = 2;	// move hotend opening left/right
spacing = 17; 		// ir sensor bracket mount hole spacing
shiftir = -20;	// shift ir sensor bracket mount holes
wall = 8;		// thickness of the plates
depth = wall;	// used where depth is a better description
height = 90;	// height of the back/front plates
widthE = 75;	// extruder plate width
depthE = wall;	// thickness of the extruder plate
heightE = 60; 	// screw holes may need adjusting when changing the front to back size
extruder = 50;	// mounting hole distance
// BLTouch variables - uses the screw2 size for the mounting holes, which work fine with the provided screws or can
// ----------------   tapped for 3mm screws
bltouch = 18;// hole distance on BLTouch by ANTCLabs
bltl = 30;	// length of bltouch mount plus a little
bltw = 16;	// width of bltouch mount plus a little
bltd = 14;	// diameter of bltouch body plus 1mm
bltdepth = -2;	// a recess to adjust the z position to keep the retracted pin from hitting the bed
//                         value provided was for the inital test
// BLTouch X offset: 0 - centered behind hotend
// BLTouch Y offset: 38mm - behind hotend (see titan module for titan offsets)
// BLTouch Z offset: you'll have to check this after assembly
// BLTouch retracted size: 42.6mm - as measured on the one I have
// BLTouch extended size: 47.87mm
// The hotend tip must be in the range of the BLTouch to use the plate as coded in here,
// adjust the BLTouch vars as necessary
// The top mounting through hole works for the old MakerGear hotend (which is what I have)
// J-head and the E3dV6 - not tested
//---------------------------------------------------------------------------------------
// following are taken from https://miscsolutions.wordpress.com/mini-height-sensor-board
hole1x = 2.70;
hole1y = 14.92;
hole2x = 21.11;
hole2y = 14.92;
holedia = 2.8;
//---------------------------------------------------------------------------------------
iroffset = 3;		// ir sensor mount hole distance
iroffset2 = 9;		// shift extruder mount holes
irnotch_d = 4;		// depth of notch to clear thru hole components
irmount_height = 25;	// height of the mount
irmount_width = 35;	// width of the mount
irthickness = 6;		// thickness of the mount
irmounty = irmount_height-3; // position of the ir mount holes from end
irreduce = 13.5; 	// hole in ir mount vertical position
irrecess = -2;		// recess in ir mount for pin heater vertical depth
//-----------------------------------------------------------------------------------------
fan_spacing = 32;
fan_offset = -6;	// adjust to align fan with extruder
servo_spacing = 32;
servo_offset = 20;	// adjust to move servo mount
screw_depth = 25;
extruder_back = 18;	// adjusts extruder mounting holes from front edge
//-------------------------------------------------------------------------------------------
b_posY = 14;		// bearing position X
b_posX = 15;		// bearing position Y
b_height = 10;		// amount to raise bearings
nut5_d = 9.5;		// diameter of z rod nut (point to point + a little)
layer_t = 0.2;		// layer thickness used to print
Vthickness = 7;		// thickness of bearing support vertical section
Tthickness = 5;		// thickness of bearing support top and fillet
//------------------------------------------------------------------------------------------
hole_off = 140;			// mounting holes on makerslide carriage plate
outside_d = 155;		// overall length
thicknessZ = 20;		// actually the width
shift1 = 4;				// amount to shift mounting columns up/down
raise = 30 + shift1;	// zrod distance from the carriage plate
zrod = 5 + clearance;	// z rod thread size
znut_d = 9.5;			// diameter of z rod nut (point to point + a little)
z_height = zrod + 10 - clearance;	// height is zrod dependent
zshift = 18;	// move the zrod hole
zadjust = 17.5;	// move inner cylinder hull to make connection to bar
znut_depth = 5; // how deep to make the nut hole
// Sizes below are for a TR8 flanged nut
flange_screw = 4;		// screw hole
flangenut_d = 10.7;		// threaded section outside diameter
flangenut_od = 22.5;	// flange outside diameter
flangenut_n	= 16.5;		// flange nut distance of opposite screw holes
TR8_d = 8+clearance;	// diameter of TR8
//--------------------------------------------------------------------------------------
shaft_offset = 10.5;	// adjust center of stepper motor or bearing mount
base_offset = 5.5;		// shift base
b_width = 55;			// base width
b_length = 48.5 + shaft_offset;	// base length
thickness = 5; 			// thickness of everything
m_height = 40;			// mount wall height
dia_608 = 22+clearance;		// outside diameter of a 608
GT2_40t_h = 6.1;			// thickness of the clamping part on the 40 tooth GT2 pulley
idler_spacer_thickness = GT2_40t_h + 0.9;	// thickness of idler bearing spacer
nut_clearance = 17;			// clearance for a 8mm nut
h_608 = 7; 					// thickness of a 608
layer = 0.25;				// printed layer thickness
shiftbm = 0; 				// move belt motor mount up/down (- shifts it up)
dia_f625z = 18;				// f625z flange diameter
//-------------------------------------------------------------------------------------
e3dv6_clearance = 0.1;	// to make the center land a tad thinner
// from http://wiki.e3d-online.com/wiki/E3D-v6_Documentation
e3dv6_od = 16;	// e3dv6 mount outside diameter
e3dv6_id = 12;	// e3dv6 mount inner diameter
ed3v6_tl = 3.7;	// e3dv6 mount top lad height
e3dv6_il = 6-e3dv6_clearance;	// e3dv6 mount inner land height
e3dv6_bl = 3;	// e3dv6 mount bottom land height
e3dv6_total = ed3v6_tl + e3dv6_il + e3dv6_bl; // e3dv6 total mount height
//-------------------------------------------------------------------------------------
shift_ir_bowden = 5; // shift ir mount on bowden mount
belt_adjust = 20;	// belt clamp hole position (increase to move rearward)
belt_adjustUD = 5;	// move belt clamp up/down
nut3 = 6.2;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

plate(9);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module plate(WhichOne) { // the modules called here are the current versions used for the printer
	if(WhichOne == 0) {
		xy_bearing_mounts();  // requires print support to be enabled in the slicer
		translate([-28,-27,-41.7]) xy_bearing_spacers();
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 1) {
		feet(4); // arg is quanity to print and be multiples of 2
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 2) {
		lower_brackets_v2();
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 3) {
		motor_upper_brackets_v3(0);	// 0 - both, 1 - lower belt (R), 2 - upper belt (L), 3 - both motor mounts only
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 4) {
		idler_upper_brackets_v2(0);
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 5) {
		idler_bracket_support();
		translate([40,0,0]) idler_bracket_support();
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 6) {
		tapered_bearspacer(idler_upper_spacer_height);
		translate([25,0,0]) tapered_bearspacer(idler_upper_spacer_height);
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 7) {
		angled_brackets(4,1); // Qty; 0 = al angle to square or 1 = square to square
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 8) {
		x_carriage_titan_belt();
	//-------------------------------------------------------------------------------------------------------------
	}
	if(WhichOne == 9) {
		x_carriage_e3dv6_bowden_belt(1,0);
		translate([40,40,0]) bowden_titan();
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 10) {
		x_carriage_wades_belt(3);	// for BLTouch: 0 = top mounting through hole, 1 - recess mount
									// 2 - proximity sensor hole in psensord size
									// 3 or higher = none
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 11) {
		beltclamp();
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 12) {
		z_nut_carriers(); // add arg of 1 for just one; defaults to two carriers
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 13) {
		z_belt_motor_v2(1,0,0);
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 14) {
		z_axis_brackets_bearing(); // 0 - one bracket; no arg defaults to two
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 15) {
		z_axis_brackets_2();
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne == 16) { // dual hotend setup
		x_carriage_e3dv6_bowden_belt(1,1,0);	// third arg moves second mount up/down, if down(-), supports are
		translate([0,40,0]) bowden_titan();		// to print the dual mount, this hasn't been fully tested
	}
	//-------------------------------------------------------------------------------------------------------------
	if(WhichOne > 16) echo("Oops! Plate Number too high");
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
nozzle = 0.5;

module idler_bracket_support() {	// needs support in slicer
	translate([6,0,0]) color("red") cubeX([sq_w-2,thickness,(one_stack*2)+idler_upper_spacer_height+thickness],2);
	difference() {	// base
		translate([0,-(f625z_d+thickness+5)-5,0]) color("grey")  cubeX([sq_w+10,85,thickness],2);
		translate([(sq_w+10)/2,46.5,-2]) cylinder(h=thickness*2,d=screw5);
		translate([(sq_w+10)/2,-(f625z_d+2),-2]) cylinder(h=thickness*2,d=screw5);
	}
	difference() {	// top
		translate([6,-(f625z_d+thickness+5),(one_stack*2)+idler_upper_spacer_height])
			color("pink") cubeX([sq_w-2,f625z_d+thickness*3,thickness],2);
		translate([(sq_w+10)/2,-(f625z_d+2),(one_stack*2)+idler_upper_spacer_height-2]) cylinder(h=thickness*2,d=screw5);
	}
	idler_s();	// angled support wall
	translate([(sq_w+10)/2,-(f625z_d+thickness-3),0]) tapered_bearspacer(idler_upper_spacer_height);
	translate([(sq_w+10)/2,-(f625z_d+thickness-3),(one_stack*2)+idler_upper_spacer_height-3]) bearspacer(4);
	//  test fit two one_stack sets minus 3mm for the extra washers in the var
	//translate([(sq_w+10)/2,-(f625z_d+thickness-6),(one_stack*2)+idler_upper_spacer_height-23.6])
	//	cylinder(h=one_stack*2-3,d=screw8);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module idler_s() {
	difference() {
		translate([(sq_w+10)/2-thickness/2,0,-40]) rotate([45,0,0]) color("blue") cubeX([thickness,60,60]);
		translate([8,-18,-55]) cube([thickness*2,60,60]);
		translate([8,-58,-25]) cube([thickness*2,60,70]);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module lower_brackets_v2() {
	single_lower_bracket_v2();
	translate([130,0,0]) rotate([0,0,90]) single_lower_bracket_v2();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_lower_bracket_v2() {
	difference() {	
		union() {
			color("grey") cubeX([sq_w+10,60,sq_d+10],2);
			color("lightgrey") cubeX([60,sq_w+10,sq_d+10],2);
			upper_bracket_support(0);
		}
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots();
	}
	difference() {
		translate([0,23.3,0]) rotate([90,0,0]) union() {
			color("grey") cubeX([sq_d+10,60,sq_d+10],2);
			color("lightgrey") cubeX([60,sq_d+10,sq_d+10],2);
			upper_bracket_support(0);
		}
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots();
	}
	difference() {
		translate([0,0,0]) rotate([90,0,90]) union() {
			color("grey") cubeX([sq_d+10,60,sq_d+10],2);
			color("lightgrey") cubeX([60,sq_d+10,sq_d+10],2);
			upper_bracket_support(0);
		}
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module idler_upper_brackets_v2(Spacer_H = 0) {
	single_upper_bracket_v2();
	difference() {
		translate([0,4,23.3]) rotate([180,0,0]) color("green") bearing_bracket(0,b_posY-2);
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots2();
	}
	if(Spacer_H) translate([50,-13,0]) tapered_bearspacer(Spacer_H);
	translate([140,0,0]) {
		translate([-10,-1.2,0]) rotate([0,0,90]) single_upper_bracket_v2(0);
	}
	difference() {
		translate([106,3,23.3]) rotate([180,0,0]) color("blue")  bearing_bracket(0,b_posY-2);
		translate([110,98.8,-0.5]) rotate([0,0,-90]) al_sq_slots2();
	}
	if(Spacer_H) translate([80,-13,0]) tapered_bearspacer(Spacer_H);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_upper_bracket_v2() { // for the horizontal square to vertical square
	difference() {	
		union() {
			color("grey") cubeX([sq_w+10,60,sq_d+10],2);
			color("lightgrey") cubeX([60,sq_w+10,sq_d+10],2);
			upper_bracket_support(0);
		}
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots2();
	}
	difference() {
		translate([0,23.3,0]) rotate([90,0,0]) union() {
			color("grey") cubeX([sq_d+10,60,sq_d+10],2);
			color("lightgrey") cubeX([60,sq_d+10,sq_d+10],2);
			upper_bracket_support(0);
		}
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots2();
	}
	difference() {
		translate([0,0,0]) rotate([90,0,90]) union() {
			color("grey") cubeX([sq_d+10,60,sq_d+10],2);
			color("lightgrey") cubeX([60,sq_d+10,sq_d+10],2);
			upper_bracket_support(0);
		}
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots2();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module upper_bracket_support(Solid=0) {	// angled supports
	if(Solid) {
		difference() {
			translate([16,-69,(sq_d+10)/2-thickness/2]) rotate([0,0,45]) color("cyan") cubeX([92,92,thickness],2);
			translate([-18,-113,(sq_d+10)/2-thickness/2-1]) cube([120,120,thickness+2]);
			translate([-110,-40,(sq_d+10)/2-thickness/2-1]) cube([120,140,thickness+2]);
		}
	} else {
		difference() {
			translate([75,-4,(sq_d+10)/2-thickness/2]) rotate([0,0,45]) color("cyan") cubeX([10,85,thickness],2);
			translate([-18,-99,(sq_d+10)/2-thickness/2-1]) cube([120,120,thickness+2]);
			translate([-98,-40,(sq_d+10)/2-thickness/2-1]) cube([120,140,thickness+2]);
			translate([59,18,(sq_d+10)/2-thickness/2-1]) cube([10,10,thickness+2]);
			translate([18,59,(sq_d+10)/2-thickness/2-1]) cube([10,10,thickness+2]);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_axis_brackets_bearing(Qty_of_2=1) {
	single_z_axis_bracket();
	translate([34,0,8.4]) rotate([0,180,-90]) bearing_mount_v2(1);
	translate([37,35,-10.9]) lockring();
	if(Qty_of_2) {
		translate([-40,0,0]) {
			mirror() single_z_axis_bracket();
			translate([-34,0,8.4]) rotate([0,180,90]) bearing_mount_v2(0);
			translate([-37,35,-10.9]) lockring();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_mount_v2(Spc=0,SpcThk=idler_spacer_thickness) { // bearing holder at bottom of z-axis
	rotate([180,0,0]) {
		side_support_v2();
		difference() {
			translate([0,-(shaft_offset-base_offset),0]) cubeX([b_width,b_length,thickness],2,center=true);
			translate([0,-shaft_offset,-6]) cylinder(h=10,d=dia_608,$fn=100);
		}
		translate([0,-shaft_offset,0]) bearing_hole(0);
	}
//	if(Spc) translate([35,20,11]) idler_spacers(0,SpcThk);
	one_attached_idler_v2(1);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module one_attached_idler_v2(Spc=0) { // Spc = spacers, Spt = add support to attached idler plate
	difference() { // needs to be a bit wider with Spt==1
		translate([-27.5,30,-2.5]) cubeX([54.5,25,thickness],2);
		translate([dia_f625z-dia_f625z/2+2,60-dia_f625z,-5]) cylinder(h=10,d=screw5);
		translate([-dia_f625z+5,60-dia_f625z,-5]) cylinder(h=10,d=screw5);
	}
	translate([22.5,26,-2.5]) cubeX([thickness,29,sq_d+8.5],2);
	translate([-27.5,26,-2.5]) cubeX([thickness,29,sq_d+8.5],2);
	//if(Spc) translate([-37,20,12.3]) idler_spacers(0,idler_spacer_thickness);
	if(Spc) translate([35,20,12.3]) idler_spacers(0,idler_spacer_thickness);
}

/////////////////////////////////////////////////////////////////////////////////////////

module side_support_v2() {
	translate([b_width/2-thickness,-(b_length-28.5),-(sq_d+6)]) cubeX([thickness,b_width,sq_d+8],2);
	translate([-(b_width/2),-(b_length-28.5),-(sq_d+6)]) cubeX([thickness,b_width,sq_d+8],2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_axis_brackets_2() {
	single_z_axis_bracket();
	translate([30,0,0]) mirror() single_z_axis_bracket();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_z_axis_bracket() {
	difference() {
		cubeX([sq_w+10,125,sq_w+5],2,center=true);
		translate([0,0,sq_w]) z_al_sq_slots();
	}
	difference() {
		translate([0,0,30]) color("cyan") cubeX([sq_w+10,sq_w+10,60],2,center=true);
		translate([20,0,59]) cube([sq_w+10,mgn_rw+mgn_oh*2,100],true);
		translate([0,0,sq_w]) z_al_sq_slots();
	}
	z_axis_support();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_axis_support() {
	difference() {
		translate([-2.5,11,-43]) rotate([45,0,0]) color("blue") cubeX([5,70,70]);
		translate([-3.5,-41,-15]) cube([7,50,90]);
		translate([-3.5,-20,-45]) cube([7,90,50]);
	}
	difference() {
		translate([-2.5,-11,-43]) color("red") rotate([45,0,0]) cubeX([5,70,70]);
		translate([-3.5,-10,-15]) cube([7,80,90]);
		translate([-3.5,-70,-45]) cube([7,90,50]);
	}

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_al_sq_slots() { // square al slots
	color("Blue") translate([0,0,sq_w-35.3]) cube([sq_w,300,sq_d],true);	// horz
	color("Green") translate([0,0,64]) cube([sq_d,sq_w,150],true); //vert
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_wades_belt(Type=4) {
	x_carriage_wades(Type,10);
	translate([17,35,-4]) x_carriage_belt3();
	//translate([35,10,0]) beltclamp();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_belt3() {
	difference() {
		translate([5,-24,5]) x_carriage_belt2(-45,10,0);
		translate([-40.5,-4,3]) main_base_mounting();
	}
	difference() {
		translate([-40,-14,0]) color("red") cubeX([45.5,40,wall+1],2);
		translate([-40.5,-4,3]) main_base_mounting();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_titan_belt() {
	translate([-7.9,-34,4]) titan();
	difference() {
		translate([5,-24,5]) x_carriage_belt2(-45,10,0);
		translate([-40.5,-4,3]) main_base_mounting();
	}
	difference() {
		translate([-40,-14,0]) color("red") cubeX([45.5,40,wall+1],2);
		translate([-40.5,-4,3]) main_base_mounting();
	}
	translate([40,-70,0]) beltclamp();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_e3dv6_bowden_belt(DoClamps=0,Dual=0,Adjust=0) { // mkae these held together by screws
	translate([50,0,0]) x_carriage_e3dv6_bowden(Dual,8,Dual,Adjust);
	translate([0,40,0]) rotate([0,0,0]) x_carriage_belt2(50,-45,0,Dual);
	if(DoClamps) translate([15,45,0]) rotate([0,0,0]) bowden_belt(1);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_belt(DoClamp=0) {
	if(DoClamp) translate([-12,-20,0]) bowden_clamp();
	translate([0,-90,0]) beltclamp();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_belt2(PosX,PosY,PosZ,Dual) {
	difference() {
		translate([PosX,PosY,PosZ])	belt_drive2(Dual);
		x_carriage_belt_mountscrews(PosX,PosY+10,PosZ);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_belt(PosX,PosY,PosZ) {
	difference() {
		translate([PosX,PosY,PosZ])	belt_drive();
		x_carriage_belt_mountscrews(PosX,PosY+10,PosZ);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_belt_mountscrews(PosX,PosY,PosZ) {
	translate([PosX+5,PosY+10,PosZ+4]) rotate([90,0,0]) color("blue") cylinder(h=40,d=screw3t);
	translate([PosX+fan_spacing+5,PosY+10,PosZ+4]) rotate([90,0,0]) color("red") cylinder(h=40,d=screw3t);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_belt_mountscrews3(PosX,PosY,PosZ) {
	translate([PosX+5,PosY+10,PosZ+4]) rotate([90,0,0]) color("blue") cylinder(h=40,d=screw3);
	translate([PosX+fan_spacing+5,PosY+10,PosZ+4]) rotate([90,0,0]) color("red") cylinder(h=40,d=screw3);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_bearing_mounts() {
	bearing_mount(1);
	translate([-37,35,-2.5]) lockring();
	translate([70,0,0]) bearing_mount(1);
	translate([-37,15,-2.5]) lockring();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_wades(recess=0,Length=0) // bolt-on extruder platform, works for either makerslide or lm8uu versions
{
	difference() {
		cubeX([widthE,heightE,wall],radius=2,center=true); // extruder side
		if(recess == 2) {
			translate([0,-height/3-6,0]) { // extruder notch
				minkowski() {
					cube([25,60,wall+5],true);
					cylinder(h = 1,r = 5,$fn=50);
				}
			}
		} else {
			translate([0,-height/3,0]) { // extruder notch
				minkowski() {
					cube([25,60,wall+5],true);
					cylinder(h = 1,r = 5,$fn=50);
				}
			}
		}
		// extruder mounting holes
		hull() {
			translate([extruder/2+2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
			translate([extruder/2-4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
		}
		hull() {
			translate([-extruder/2+4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
			translate([-extruder/2-2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
		}
		translate([0,28,41+wall/2]) rotate([90,0,0]) servo();
		translate([0,26,41+wall/2]) rotate([90,0,0]) fan();
		// BLTouch mounting holes
		if(recess == 1) {	// dependent on the hotend, for mounting under the extruder plate
			translate([-bltl/2+3,bltw/2+3,bltdepth]) minkowski() { // depression for BLTouch
				// it needs to be deep enough for the retracted pin not to touch bed
				cube([bltl-6,bltw-6,wall]);
				cylinder(h=1,r=3,$fn=100);
			}
			translate([-bltl/2+8,bltw/2,-5]) cube([bltd,bltd+1,wall+3]); // hole for BLTouch
			translate([bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
			translate([-bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
		}
		if(recess == 0) {	// for mounting on top of the extruder plate
			translate([-bltl/2+8,bltw/2,-5]) cube([bltd,bltd+1,wall+3]); // hole for BLTouch
			translate([bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
			translate([-bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
		}
		if(recess == 2) { // proximity sensor
			translate([0,10,-6]) cylinder(h=wall*2,r=psensord/2,$fn=50);
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_nut_carriers(Qty=2) {
	for (i=[0:Qty-1]) {
		translate([i*(puck_l+5),0,0]) z_nut_carrier();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_nut_carrier() {
	main_base2();
	difference() {
		translate([33,0,35.5]) rotate([0,0,90]) znut2(1);
		translate([0,64,0]) main_base_mounting();	// notch the znut2 for the mgn mounting screw holes
		translate([0,64,15]) main_base_mounting();	// make a longer notch for mgn mounting screw holes
		translate([0,0,-8]) cube([puck_l,puck_w*5,10]);
	}
	z_nut_carrier_support();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_nut_carrier_support() {
	translate([puck_l/2-thickness/2,20,0]) cubeX([thickness,45,22],2);
	difference() {
		translate([0,20,0]) cubeX([puck_l,thickness,22],2);
		translate([12,30,15]) rotate([90,0,0]) cylinder(h=thickness*2,d=screw5);
		translate([32,30,15]) rotate([90,0,0]) cylinder(h=thickness*2,d=screw5);
	}

	translate([puck_l/2-thickness/2,90,0]) cubeX([thickness,47,22],2);
	difference() {
		translate([0,140-thickness,0]) cubeX([puck_l,thickness,22],2);
		translate([12,145,15]) rotate([90,0,0]) cylinder(h=thickness*2,d=screw5);
		translate([32,145,15]) rotate([90,0,0]) cylinder(h=thickness*2,d=screw5);
	}
}

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_base2() { // main part that mounts on the mgn12h
	difference() {
		cubeX([puck_l,160,thickness],2);
		translate([0,64,0]) main_base_mounting();
		// 2040 mountng holes
		translate([12,10,-2]) cylinder(h=thickness*2,d=screw5);
		translate([32,10,-2]) cylinder(h=thickness*2,d=screw5);
		translate([12,150,-2]) cylinder(h=thickness*2,d=screw5);
		translate([32,150,-2]) cylinder(h=thickness*2,d=screw5);
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

module bearspacer(length=one_stack) {	// fill in the non-bearing space
	difference() {
		cylinder(h=length,r=screw5);
		translate([0,0,-1]) cylinder(h=length+5,r=screw5/2);
	}

}

//////////////////////////////////////////////////////////////////////////////////////

module tapered_bearspacer(length=one_stack) {	// fill in the non-bearing space
	difference() {
		cylinder(h=length,r1=screw5+5,r2=screw5,$fn=100);
		translate([0,0,-1]) cylinder(h=length+5,r=screw5/2);
	}

}

///////////////////////////////////////////////////////////////////////////////////////////

module base() { // base mount
	difference() {
		color("white") cubeX([bearing_bracket_width,one_stack*2+10,thickness],2);
		hull() {
			translate([18,13,-3]) cylinder(h=20,d=15,$fn=100);
			translate([18,21,-3]) cylinder(h=20,d=15,$fn=100);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module feet(Qty=4) {
	for(i=[0:(Qty/2-1)]) {
		translate([i*40,0,0]) {
			difference() {
				cylinder(h=15,d1=35,d2=25,$fn=100);
				translate([0,0,10]) cube([sq_w,sq_d,11],true); // al slot
			}
		}
	}
	for(i=[0:(Qty/2-1)]) {
		translate([i*40,40,0]) {
			difference() {
				cylinder(h=15,d1=35,d2=25,$fn=100);
				translate([0,0,10]) cube([sq_w,sq_d,11],true); // al slot
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module lower_brackets() { // for the lower horizontals to vertical
	single_lower_bracket();
	translate([-10,0,0]) rotate([0,0,90]) single_lower_bracket();
	translate([95,55,0]) rotate([0,0,-90]) single_lower_bracket();
	translate([85,55,0]) rotate([0,0,-180]) single_lower_bracket();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_lower_bracket() {
	difference() {
		union() {
			difference() {
			cubeX([100,100,sq_w+10],2);
			translate([0,0,-1]) cylinder(h=sq_w+12,d=147,$fn=100);
			}
			difference() {
				translate([0,90-sq_w,100]) rotate([-90,0,0]) difference() {
					cubeX([100,100,sq_w+10],2);
					translate([0,0,-1]) cylinder(h=sq_w+12,d=147,$fn=100);
				}
			}
			translate([174,0,0]) rotate([0,0,90]) difference() {
				translate([0,90-sq_w,100]) rotate([-90,0,0]) difference() {
					cubeX([100,100,sq_w+10],2);
					translate([0,0,-1]) cylinder(h=sq_w+12,d=146,$fn=100);
				}
			}
		}
		al_sq_slots();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_sq_slots() { // square al slots
	color("Red") translate([4.5,105-sq_w,sq_d]) cube([150,sq_w,sq_d],true);		// horz
	color("Blue") translate([105-sq_w,3.5,sq_d]) cube([sq_w,150,sq_d],true);			// horz
	color("Green") translate([105-sq_w,105-sq_w,50]) cube([sq_w,sq_d,150],true);	//vert
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_sq_slots2() { // square al slots
	color("Red") translate([4.5,105-sq_w,sq_d-1.2]) cube([150,sq_w,sq_d],true);		// horz
	color("Blue") translate([105-sq_w,3.5,sq_d-1.2]) cube([sq_w,150,sq_d],true);	// horz
	color("Green") translate([104.5-sq_w,105-sq_w,80.5]) cube([sq_d,sq_w,150],true); //vert
}

////////////////////////////////////////////////////////////////////////////////////////////

module diag_side4() {
	difference() {
		translate([62,81.5,9]) rotate([-58,0,0]) color("blue") cubeX([10,27,10],2);
		translate([61,96.5,-43]) cube([12,15,50],2);
		translate([60,71.5,25]) rotate([0,90,0]) cube([17,50,25],2);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

module diag_side3() {
	difference() {
		translate([62,81.5,13]) rotate([-58,0,0]) color("blue") cubeX([10,27,10],2);
		translate([61,96.5,-43]) cube([12,15,50],2);
		translate([60,71.5,18]) rotate([0,90,0]) cube([17,50,25],2);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

module diag_side2() {
	difference() {
		translate([-82,86,7]) rotate([-58,0,0]) color("yellow") cubeX([10,20,10],2);
		translate([-83,96.5,-45]) cube([12,15,50],2);
		translate([-83,53.5,16]) rotate([0,90,0]) cube([12,50,15],2);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

module diag_side1() {
	difference() {
		translate([-82,76.5,12]) rotate([-58,0,0]) color("yellow") cubeX([10,30,10],2);
		translate([-83,94.5,-45]) cube([12,15,50],2);
		translate([-83,53.5,17]) rotate([0,90,0]) cube([12,50,15],2);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module idler_upper_brackets(Spacer_H = idler_upper_spacer_height) {
	difference() {
		single_upper_bracket();
		translate([74,-2,-4.3]) cube([mgn_rw+2*mgn_oh+1,120,10]);
	}
	translate([100.8,126.7,35.8-mgn_fh]) rotate([180,0,0]) mirror() bearing_bracket(0,b_posY);
	translate([60,120,-mgn_fh+5.805]) bearspacer(Spacer_H);
	difference() {
		translate([-10,-1.2,0]) rotate([0,0,90]) single_upper_bracket(0);
		translate([-110.5,-2,-4.3]) cube([mgn_rw+2*mgn_oh+1,120,10]);
	}
	translate([-110.01,126,35.8-mgn_fh]) rotate([180,0,0]) bearing_bracket(0,b_posY-1);
	translate([-60,120,-mgn_fh+5.805]) bearspacer(Spacer_H);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_upper_bracket() { // for the horizontal al angles to vertical square
	difference() {	
		union() {
			difference() {
			color("grey") cubeX([100,100,sq_w+10],2);
			translate([0,0,-1]) cylinder(h=sq_w+12,d=147,$fn=100);
			}
			difference() {
				translate([0,90.01-sq_w,100]) rotate([-90,0,0]) difference() {
					color("cornsilk") cubeX([100,100,sq_w+10],2);
					translate([0,0,-1]) cylinder(h=sq_w+12,d=146,$fn=100);
				}
			}
			translate([174,0,0]) rotate([0,0,90]) difference() {
				translate([0,90-sq_w,100]) rotate([-90,0,0]) difference() {
					color("white") cubeX([100,100,sq_w+10],2);
					translate([0,0,-1]) cylinder(h=sq_w+12,d=146,$fn=100);
				}
			}
		}
		translate([0,0,0]) al_sq_slots2();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
module al_ag_slots2() { // one al angle slot and two sq slots
	color("Red") translate([107.5-ag_w,4,sq_d+0.1]) rotate([90,0,0]) cube([sq_d,sq_w,150],true); // horz
	color("Blue") translate([100-ag_w,79.8,ag_w-14.7]) rotate([0,0,90]) al_angle(150);
	color("Green") translate([104.5-sq_w,105-sq_w,80]) cube([sq_d,sq_w,150],true); //vert
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
module al_ag_slots() { // al angle slots
	color("Red") translate([114-ag_w,-73,ag_w+4.5]) rotate([0,180,0]) al_angle(150); // horz
	color("Blue") translate([98-ag_w,96.5,ag_w+4.5]) rotate([0,180,90]) al_angle(150);
	color("Green") translate([104.5-sq_w,105-sq_w,50]) cube([sq_d,sq_w,150],true); //vert
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_angle(Len = 150) {	// the al angle used to make the al angle slots
	cube([ag_w,Len,ag_t]);
	cube([ag_t,Len,ag_w]);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_angled_bracket(Sq=0) {
	if(!Sq) {
		difference() {
			cubeX([100,30,ag_w+10],2);
			// al slots
			translate([-4,sq_w/2+6.5,sq_d/2+8]) cube([150,sq_w,sq_d],true);
			translate([135-ag_w,-20,ag_w+4.5]) rotate([0,180,45]) al_angle(150);
		}
	} else { //	if(Sq) {
		difference() {
			cubeX([100,30,ag_w+10],2);
			// al slots
			translate([90,sq_w-1.5,sq_d]) cube([100,sq_w,sq_d],true);
			translate([65-ag_w,10,sq_w-3.5]) rotate([0,180,45]) cube([sq_w,150,sq_d],true);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module angled_brackets(Qty=4,Typ=0) {
	if(!Typ) {
		for(i=[0:(Qty-1)]) { // al slot to al angle
			translate([0,i*50,0]) single_angled_bracket(0);
		}
	} else {
		for(i=[0:(Qty-1)]) { // al slot to al slot
			translate([0,i*50,0]) single_angled_bracket(1);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_titan() {
	translate([0,18,0]) rotate([0,0,180]) main_base(5);
	//translate([-puck_l,-(thickness*3),0]) color("blue") cubeX([puck_l,thickness*3,wall],2);
	//translate([-5,-21,3]) color("pink") cubeX([5,thickness*4.2,puck_w+5],2);
	translate([-7.9,-40,4]) titan();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titan(recess=3) { // extruder platform for e3d titan with (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
	difference() {		 // ir sensor is relative -28y; BLTouch +20y, Proximity +6y (going by translates)
		translate([0,-5.5,0]) cubeX([widthE,heightE+11,wall],radius=2,center=true); // extruder side
		//extmount();
		hull() {	// hole for e3dv6, shifted to front by 11mm
			translate([-17.5+shifthotend2,-16+shifthotend,-10]) cylinder(h=20,d=e3dv6,$fn=100);
			translate([-35+shifthotend2,-16+shifthotend,-10]) cylinder(h=20,d=e3dv6);
		}
		translate([20,-5,-10]) cylinder(h=20,d=20,$fn=100); // remove some plastic under the motor
		translate([0,16,44]) rotate([90,0,0]) sidemounts();
		if(recess == 0) translate([-16,-4,0]) blt(1); // BLTouch mount
		if(recess == 1) translate([-16,-4,0]) blt(0); // BLTouch mount in a recess
		if(recess == 2) translate([-16,10,-6]) cylinder(h=wall*2,r=psensord/2,$fn=50); // proximity sensor
		if(recess == 3) ir_mount(); // mounting holes for irsensor bracket
	}
	translate([0,-30,0]) rotate([90,0,90]) titanmotor(shifttitanup);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_titan() { // platform for e3d titan
	difference() {
		cubeX([40,54,5],2); // extruder side
		translate([20,28,-10]) cylinder(h=20,d=20,$fn=100); // remove some plastic under the motor
		translate([10,10,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		translate([30,10,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		translate([10,45,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		translate([30,45,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
	}
	translate([0,1,1]) rotate([90,0,90]) titanmotor(5+shifttitanup);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titanmotor(ShiftUp=0) {
	difference() {	// motor mounting holes
		translate([-1,0,0]) cubeX([54,50+ShiftUp,5],2);
		translate([25,25+ShiftUp,-1]) rotate([0,0,45])  NEMA17_x_holes(8, 2);
	}
	difference() { // front support
		translate([-1,0,0]) color("red") cubeX([4,50,50],2);
		translate([-3,50,4]) rotate([56,0,0]) cube([7,50,70]);
		translate([-4,-4,36]) cube([wall,wall,wall]);
	}
	difference() { // rear support
		translate([49,0,0]) color("blue") cubeX([4,50,50],2);
		translate([47,50,4]) rotate([56,0,0]) cube([7,50,70]);
		translate([47,-4,36]) cube([wall,wall,wall]);
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sidemounts() {	// mounting holes (copied from fan() & servo() modules
	translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([-extruder/2-25,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset]) // l-r
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
//
	translate([-extruder/2-25,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([-extruder/2-25,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
//
	translate([-extruder/2-25,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset]) // l-f
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ir_mount() // ir screw holes for mounting to extruder plate
{
	translate([spacing+shiftir+shifthotend,-25,0]) rotate([90,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
	translate([shiftir+shifthotend,-25,0]) rotate([90,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
}

/////////////////////////////////////////////////////////////////////////////////////////

module motor_mount() {
	difference() {
		cubeX([59,59,5],radius=2,center=true);
		translate([0,0,-4]) rotate([0,0,45])  NEMA17_x_holes(7, 2);
	}
	diag_side();
	translate([0,-27,23]) color("blue") cubeX([59,5,48],radius=2,center=true);
}

////////////////////////////////////////////////////////////////////////////////////////////

module diag_side() {
	difference() {
		translate([24.4,-33,35]) rotate([-45,0,0]) color("red") cubeX([5,60,10],2);
		translate([23,-33.5,-10]) cube([10,60,10],2);
		translate([23,-36.5,6]) cube([10,10,60],2);
	}
	difference() {
		translate([-29.4,-33,36]) rotate([-45,0,0]) color("cyan") cubeX([5,60,10],2);
		translate([-32,-30.5,-10]) cube([10,50,10],2);
		translate([-32,-36,45]) rotate([0,90,0]) cube([50,10,10],2);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////

module motor_mount0(Side=0) {	// 0 - lower belt motor; 1 = upper belt motor
	difference() {	// motor mounting holes
		cubeX([59,59,5],radius=2,center=true);
		translate([0,0,-4]) rotate([0,0,45])  NEMA17_x_holes(7, 2);
	}
	diag_side0(Side);
}

/////////////////////////////////////////////////////////////////////////////////////////

module bearing_bracket(TapIt=0,Ypos = b_posY) {
	difference() {
		cubeX([24,30,sq_d+10],2);
		if(TapIt)
			translate([Ypos,b_posX,-2]) cylinder(h=50,r=screw5t/2);
		else {
			translate([Ypos,b_posX,-2]) cylinder(h=50,r=screw5/2);
			translate([Ypos,b_posX,-b_height-23]) cylinder(h=50,d=nut5_d,$fn=6); // nut hole
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

module diag_side0(Side) {
	if(Side) {
		difference() {
			translate([-6,24.5,-7]) rotate([0,-33,0]) cubeX([50,5,10],2);
			translate([-20,23.5,-10]) cube([50,10,10],2);
			translate([27,23.5,40]) rotate([0,90,0]) cube([50,10,10],2);
		}
	} else {
		difference() {
			translate([-6,-29.5,-7]) rotate([0,-33,0]) cubeX([50,5,10],2);
			translate([-20,-30.5,-10]) cube([50,10,10],2);
			translate([27,-30.5,40]) rotate([0,90,0]) cube([50,10,10],2);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module znut2(Type=0) {	// 0 = nut, 1 = TR8 leadscrew
	difference() {
		zholesupport(Type);	// may need some extra around zrod hole
		zholeCS(Type);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module zholeCS(Type) { // countersink flange nut
	if(Type==1) {
		translate([outside_d/2,znut_depth,z_height/2-zshift]) 
			rotate([90,0,0]) cylinder(h=10,d=flangenut_od,$fn=100);
	}
	//if(Type==0) ; // nothing
}

//////////////////////////////////////////////////////////////////

module zhole(Type) {
	if(!Type) {
		translate([outside_d/2,thicknessZ*1.5,z_height/2-zshift])
			rotate([90,0,0]) cylinder(h=thicknessZ*2,r = zrod/2,$fn=100);
	}
	if(Type) {
		translate([outside_d/2,thicknessZ*1.5,z_height/2-zshift])
			rotate([90,0,0]) cylinder(h=thicknessZ*2,r = flangenut_d/2,$fn=100);

	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module zholesupport(Type) { // will it need extra width at the zrod?
	difference() {
		if(!Type) {
			hull() {
				translate([outside_d/2,thicknessZ,z_height/2-zshift+zadjust])
					rotate([90,0,0]) cylinder(h=thicknessZ,r = zrod*2.5,$fn=100);
				translate([outside_d/2,thicknessZ,z_height/2-zshift]) rotate([90,0,0])
					cylinder(h=thicknessZ,r = zrod*2.5,$fn=100);
			}
		}
		if(Type) {
			hull() {
				translate([outside_d/2,thicknessZ,z_height/2-zshift-zadjust])
					rotate([90,0,0]) cylinder(h=thicknessZ,r = flangenut_od/1.5,$fn=100);
				translate([outside_d/2,thicknessZ,z_height/2-zshift]) rotate([90,0,0])
					cylinder(h=thicknessZ,r = flangenut_od/1.5,$fn=100);
			}
		}
		zhole(Type);
		znuthole(Type);
	}
}

/////////////////////////////////////////////////////////////////////

module znuthole(Type) {
	if(!Type) {
		translate([outside_d/2,znut_depth,z_height/2-zshift]) rotate([90,0,0]) cylinder(h=thicknessZ,r = znut_d/2,$fn=6);
	}
	if(Type) { // make mounting screw holes
		translate([outside_d/2+flangenut_n/2,thicknessZ+5,z_height/2-zshift])
			rotate([90,0,0]) cylinder(h=thicknessZ+8,r = flange_screw/2);
		translate([outside_d/2-flangenut_n/2,thicknessZ+5,z_height/2-zshift])
			rotate([90,0,0]) cylinder(h=thicknessZ+8,r = flange_screw/2);
		translate([outside_d/2,thicknessZ+5,z_height/2-zshift+flangenut_n/2])
			rotate([90,0,0]) cylinder(h=thicknessZ+8,r = flange_screw/2);
		translate([outside_d/2,thicknessZ+5,z_height/2-zshift-flangenut_n/2])
			rotate([90,0,0]) cylinder(h=thicknessZ+8,r = flange_screw/2);
	}
}

////////////////////////////////////////////////////////////////////////////

module testnut(Type) { 	// a shortened nut section for test fitting of the nut & zrod or flange nut
	difference() {
		translate([-60,0,0]) zholesupport(Type);
		if(!Type) translate([-10,znut_depth+3,-35]) cube([60,20,60]);
		if(Type) translate([-10,5,-40]) cube([60,20,60]);
		translate([-60,-3.5,0]) zholeCS(Type);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_mount(Spc=0,SpcThk=idler_spacer_thickness) { // bearing holder at bottom of z-axis
	rotate([180,0,0]) {
		mount();
		difference() {
			translate([0,-(shaft_offset-base_offset),0]) cubeX([b_width,b_length,thickness],2,center=true);
			translate([0,-shaft_offset,-6]) cylinder(h=10,d=dia_608,$fn=100);
		}
		translate([0,-shaft_offset,0]) bearing_hole();
	}
	if(Spc) translate([0,10,-2.5]) idler_spacers(0,SpcThk);
	one_attached_idler(1);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_hole(Support=1) {	// holds the bearing
	translate([0,0,-6.5]) difference() {
		translate([0,0,thickness/3]) cylinder(h=h_608,d=dia_608+5,$fn=100);
		translate([0,0,0]) cylinder(h=15,d=dia_608,$fn=100);
	}
	translate([0,0,-10]) difference() {
		translate([-25,-16,thickness/3]) cubeX([dia_608+27,dia_608+10,h_608/2]);//cylinder(h=h_608/2,d=dia_608+12,$fn=100);
		translate([0,0,0]) cylinder(h=15,d=nut_clearance,$fn=100);
	}
	if(Support) bearing_hole_support();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_hole_support() { // print support for bearing hole
	translate([0,0,-5]) cylinder(h=layer,d=dia_608+5,$fn=100);
}

////////////////////////////////////////////////////////////////////////////

module mount() {
	difference() {
		translate([0,22,-18]) cubeX([b_width,thickness,m_height],2, center=true);
		translate([0,30,-8]) rotate([90,0,0]) cylinder(h=20,d=screw3); // top screw hole
		translate([0,30,-30]) rotate([90,0,0]) cylinder(h=20,d=screw3); // bottom screw hole
		translate([-15,30,-8]) rotate([90,0,0]) cylinder(h=20,d=screw3);	// top screw hole
		translate([15,30,-8]) rotate([90,0,0]) cylinder(h=20,d=screw3);	// bottom screw hole
	}
	side_support();
}

/////////////////////////////////////////////////////////////////////////////////////////

module side_support() {
	difference() {	// side support
		translate([b_width/2-thickness,-(b_length-28.5),-38]) cubeX([thickness,b_width,m_height],2);
		translate([b_width/2-thickness-0.5,-(b_length-45.5),-90]) rotate([60,0,0]) cube([6,60,60]);
		hull() {
			translate([b_width/2-thickness-0.5,7,-14]) rotate([0,90,0]) cylinder(h=6,r=10,$fn=100);
			translate([b_width/2-thickness-0.5,-12,-9]) rotate([0,90,0]) cylinder(h=6,r=5,$fn=100);
		}
	}
	difference() { // side support
		translate([-(b_width/2),-(b_length-28.5),-38]) cubeX([thickness,b_width,m_height],2);
		translate([-(b_width/2+0.5),-(b_length-45.5),-90]) rotate([60,0,0]) cube(size=[6,60,60]);
		hull() {
			translate([-(b_width/2+0.5),7,-14]) rotate([0,90,0]) cylinder(h=6,r=10,$fn=100);
			translate([-(b_width/2+0.5),-12,-9]) rotate([0,90,0]) cylinder(h=6,r=5,$fn=100);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module idler_spacers(Two=0,Thk=idler_spacer_thickness,Spt=0) {
	difference() {
		cylinder(h=Thk,d=screw5+5);
		translate([0,0,-1]) cylinder(h=idler_spacer_thickness*2,d=screw5);
	}
	if(Two) {
		translate([15,0,0]) difference() {
			cylinder(h=Thk,d=screw5+5);
			translate([0,0,-1]) cylinder(h=idler_spacer_thickness*2,d=screw5);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module lockring() { // lock ring to hold TR8 leadscrew in bearing, may not be necessary since gravity will hold it
	difference() {
		cylinder(h=h_608+1,d=nut_clearance-2,$fn=100);
		translate([0,0,-1]) cylinder(h=15,d=TR8_d,$fn=100);
		translate([0,0,2.5]) rotate([90,0,0]) cylinder(h=10,d=screw3t);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_belt_motor(idler=1) { // motor mount for belt drive
	rotate([180,0,0]) {
		nema_plate(0);	// nema17 mount
		mountbelt();	// motor mount base
	}
	difference() {	// mount to 2020
		translate([-b_width/2,-45,-thickness/2-shiftbm]) cubeX([b_width,24.5,21],2);	// base
		translate([-b_width/2-1,-38,-21-shiftbm]) rotate([45,0,0]) cube([b_width+2,22,40]); // remove half
		hull() {
			translate([-b_width/2+20,-32,-thickness/2-shiftbm]) cylinder(h=40,d=screw3);	// mounting screw holes
			translate([-b_width/2+5,-32,-thickness/2-shiftbm]) cylinder(h=40,d=screw3);	// mounting screw holes
		}
		hull() {
			translate([b_width/2-5,-32,-thickness/2-shiftbm]) cylinder(h=40,d=screw3);
			translate([b_width/2-20,-32,-thickness/2-shiftbm]) cylinder(h=40,d=screw3);
		}
		hull() {
			translate([-b_width/2+5,-32,-thickness/2-shiftbm+1]) cylinder(h=15,d=screw3hd);	// countersinks
			translate([-b_width/2+20,-32,-thickness/2-shiftbm+1]) cylinder(h=15,d=screw3hd);	// countersinks
		}
		hull() {
			translate([b_width/2-5,-32,-thickness/2-shiftbm+1]) cylinder(h=15,d=screw3hd);
			translate([b_width/2-20,-32,-thickness/2-shiftbm+1]) cylinder(h=15,d=screw3hd);
		}
		translate([-b_width/2-1,-42,-22.5]) cube([b_width+5,22.5,20],2); // make sure it doesn't go past top
	}
	belt_motor_mount_support();	// make 2020 mount holes printable
	if(idler) attached_idler(1,1);	// add idler to the motor mount
	if(idler) translate([0,45,0]) attached_idler(0); // top idler plate
	//translate([11,42,5]) testf625z(); // this is use to check bearing clearance to support wall
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_belt_motor_v2(idler=0,Iplate=0,FullWrap=1) { // motor mount for belt drive
	translate([-30,-47,-2.5]) difference() {
		if(FullWrap) color("lightgrey") cubeX([60,sq_w+10,sq_d+10],2); // install during main frame assembly
		else color("lightgrey") cubeX([60,sq_w+10,sq_d+6.1],2); // installable after main frame is assembled
		translate([100,100,-0.5]) rotate([0,0,180]) al_sq_slots_m();
	}
	rotate([180,0,0]) {
		nema_plate(0);	// nema17 mount
		side_support_v2();
	}
	if(idler) attached_idler(Iplate,1,0);	// add idler to the motor mount
	//if(Iplate) translate([0,45,0]) attached_idler(0); // top idler plate
	//translate([11,42,5]) testf625z(); // this is use to check bearing clearance to support wall
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_sq_slots_m() { // square al slots
	color("Red") translate([50,104.5-sq_w,sq_d]) cube([150,sq_w,sq_d],true);		// horz
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_motor_mount_support() {	// print support for inner hole
	hull() {	
		translate([-b_width/2+5,-32,-thickness/2-shiftbm+16]) cylinder(h=layer,d=screw5hd);
		translate([-b_width/2+20,-32,-thickness/2-shiftbm+16]) cylinder(h=layer,d=screw5hd);
	}
	hull() {
		translate([b_width/2-5,-32,-thickness/2-shiftbm+16]) cylinder(h=layer,d=screw5hd);
		translate([b_width/2-20,-32,-thickness/2-shiftbm+16]) cylinder(h=layer,d=screw5hd);
	}
}

////////////////////////////////////////////////////////////////////////////

module mountbelt() { // the three sides of the motor mount; same as mount(), but no screw holes
	translate([0,22,-18]) cubeX([b_width,thickness,m_height],2, center=true);
	side_support();
}

////////////////////////////////////////////////////////////////////////////

module nema_plate(makerslide=0) {
	difference() {
		translate([0,-(shaft_offset-base_offset),0]) cubeX([b_width,b_length,thickness],2,center=true);
		translate([0,-shaft_offset,-4]) rotate([0,0,45]) NEMA17_x_holes(7, 2);
		if(makerslide) notchit();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module attached_idler(Spc=0,Spt=0,QtySpc=1) { // Spc = spacers, Spt = add support to attached idler plate
	if(Spt) {
		difference() { // needs to be a bit wider with Spt==1
			translate([-27.5,30,-2.5]) cubeX([55,20,thickness],2);
			translate([-dia_f625z+dia_f625z/2-8,60-dia_f625z,-5]) cylinder(h=10,d=screw5);
			translate([dia_f625z-dia_f625z/2+8,60-dia_f625z,-5]) cylinder(h=10,d=screw5);
		}
	} else {
		difference() {
			translate([-12,30,-2.5]) cubeX([33,40,thickness],2);
			translate([-2,60,-5]) cylinder(h=10,d=screw5);
			translate([dia_f625z-dia_f625z/2+2,60-dia_f625z,-5]) cylinder(h=10,d=screw5);
		}
	}
	if(Spt) {
		translate([22.5,26,-2.5]) cubeX([thickness,24,thickness*4.36],2);
		translate([-27.5,26,-2.5]) cubeX([thickness,24,thickness*4.36],2);
	}
	if(Spc) translate([-7.5,10,-2.5]) idler_spacers(QtySpc,idler_spacer_thickness);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module one_attached_idler(Spc=0) { // Spc = spacers, Spt = add support to attached idler plate
	difference() { // needs to be a bit wider with Spt==1
		translate([-27.5,30,-2.5]) cubeX([54.5,25,thickness],2);
		translate([dia_f625z-dia_f625z/2+2,60-dia_f625z,-5]) cylinder(h=10,d=screw5);
		translate([-dia_f625z+5,60-dia_f625z,-5]) cylinder(h=10,d=screw5);
	}
	translate([22.5,26,-2.5]) cubeX([thickness,29,thickness*3],2);
	translate([-27.5,26,-2.5]) cubeX([thickness,29,thickness*3],2);
	if(Spc) translate([-35,50,-2.5]) idler_spacers(0,idler_spacer_thickness);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_e3dv6_bowden(DoClamp=1,ExtendBase=0,Dual=0,Adjust=0) {
	difference() {
		main_base(ExtendBase);
		belt_nut_slot();
		if(Dual) translate([0,37,0]) rotate([90,0,0]) bowden_nuts(15);
	}
	difference() {
		translate([0,puck_w/2-e3dv6_total/2,0]) rotate([90,0,0]) bowden_mount();
		main_base_mounting();	// open up access to mgn mouting holes
		translate([8,puck_w/2-e3dv6_total/2-10,5]) cubeX([10,5,10]);	// access hole for M4 nuts
		translate([30,puck_w/2-e3dv6_total/2-10,5]) cubeX([10,5,10]);	// access hole for M4 nuts
	}
	if(Dual) {
		difference() {
			translate([48,puck_w/2-e3dv6_total/2+13,Adjust]) rotate([-90,180,0]) bowden_mount();
			main_base_mounting();
			translate([8,puck_w/2-e3dv6_total/2+16,5]) cubeX([10,5,10]);
			translate([30,puck_w/2-e3dv6_total/2+16,5]) cubeX([10,5,10]);
			translate([43,11,0]) cube([10,20,10]);
			translate([43,12,6.9]) cube([10,20,10]);
		}
	}
	//translate([24,80,0]) rotate([90,0,0]) cylinder(h=200,d=screw2); // this is to help center the bowden mounts
	if(DoClamp && !Dual) translate([0,40,0]) bowden_clamp();
	if(DoClamp && Dual) translate([30,50,0]) rotate([0,0,90]) bowden_clamp();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_mount() {
	difference() {
		hull() {
			cubeX([puck_l,e3dv6_total,3],2);
			translate([e3dv6_od/2,0,27]) cubeX([e3dv6_od*2,e3dv6_total,3],2);
		}
		translate([e3dv6_od+e3dv6_od/2,e3dv6_total,31]) rotate([90,0,0]) e3dv6();
		bowden_screws();
		bowden_bottom_ir_mount_hole();
		bowden_bottom_fan_mount_hole();
	}
	bowden_nut_support();
	bowden_ir();
	bowden_fan();
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_screws() {
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,-5]) color("red") cylinder(h=50,d=screw4);
	translate([35,puck_w/2-e3dv6_total/2-0.5,-5]) color("blue") cylinder(h=50,d=screw4);
	bowden_nuts();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_nuts(Len=24) {
	translate([35,puck_w/2-e3dv6_total/2-0.5,-1.5]) color("red") cylinder(h=Len,d=nut4,$fn=6);
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,-1.5]) color("blue") cylinder(h=Len,d=nut4,$fn=6);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_screws_CS() {
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,-5]) color("red") cylinder(h=50,d=screw4);
	translate([35,puck_w/2-e3dv6_total/2-0.5,-5]) color("blue") cylinder(h=50,d=screw4);
	translate([35,puck_w/2-e3dv6_total/2-0.5,-1.5]) color("red") cylinder(h=24,d=screw4hd);
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,-1.5]) color("blue") cylinder(h=24,d=screw4hd);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_nut_support() {
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,22.51]) color("red") cylinder(h=layer,d=nut4);
	translate([35,puck_w/2-e3dv6_total/2-0.5,22.51]) color("blue") cylinder(h=layer,d=nut4);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_head_support() {
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,2.51]) color("red") cylinder(h=layer,d=screw4hd);
	translate([35,puck_w/2-e3dv6_total/2-0.5,2.51]) color("blue") cylinder(h=layer,d=screw4hd);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_clamp() {
	difference() {
		translate([e3dv6_od/2,0,0]) cubeX([e3dv6_od*2,e3dv6_total,15],2);
		translate([e3dv6_od+e3dv6_od/2,e3dv6_total,16]) rotate([90,0,0]) e3dv6();
		translate([0,0,-20]) bowden_screws_CS();
	}
	bowden_head_support();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module e3dv6() {
	cylinder(h=e3dv6_total,d=e3dv6_id,$fn=100);
	translate([0,0,e3dv6_total-ed3v6_tl]) cylinder(h=ed3v6_tl+1,d=e3dv6_od,$fn=100);
	translate([0,0,-1]) cylinder(h=e3dv6_bl+1,d=e3dv6_od,$fn=100);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_ir() {
	difference() {
		translate([2,0,10.5]) color("pink") cubeX([5,7,hole2x+9+shift_ir_bowden]);
		translate([0,3.5,hole2x+14.5+shift_ir_bowden]) rotate([0,90,0]) color("red") cylinder(h=10,d=screw3t);
		bowden_bottom_ir_mount_hole();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_bottom_ir_mount_hole() {
	translate([-1,3.5,14.5+shift_ir_bowden]) color("blue") rotate([0,90,0]) cylinder(h=15,d=screw3t);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_fan() {
	difference() {
		translate([41,0,2]) color("cyan") cubeX([5,7,fan_spacing+18]);
		translate([39,3.5,fan_spacing+14.5]) rotate([0,90,0]) color("red") cylinder(h=10,d=screw3t);
		bowden_bottom_fan_mount_hole();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_bottom_fan_mount_hole() {
	translate([37,3.5,14.5]) rotate([0,90,0]) color("blue") cylinder(h=15,d=screw3t);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module servo()
{		// mounting holes
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module fan()
{		// mounting holes
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);

		//translate([-extruder/2,-heightE/2 - 1.8*wall+2,heightE - extruder_back]) // metal extruder cooling fan mount
			//rotate([0,0,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50); // one screw hole in front
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module iradapter(Top) {  // ir sensor bracket stuff is from irsensorbracket.scad
	difference() {
		cubeX([irmount_width,irmount_height,irthickness],2); // mount base
		//reduce();
		block_mount();
		recess();
	}
	//ir_supports();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ir_supports() {
	translate([0,0,0]) /*rotate([38,0,0])*/ cubeX([5,irmount_height-1.5,25],2);
	translate([irmount_width-5,0,0]) /*rotate([38,0,0])*/ cubeX([5,irmount_height-1.5,25],2);
}

module recess() { // make space for the thru hole pin header
	translate([hole1x+7,hole1y+irrecess+(irmount_height/4),irnotch_d]) cube([15.5,10,5]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module reduce() { // reduce plastic usage and gives somewhere for air to go if using an all-metal hotend w/fan
	translate([17,irmount_height-irreduce,-1]) cylinder(h=10,r = irmount_width/5);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module block_mount() // mounting screw holes for the ir sensor
{
	//mounting screw holes
	translate([hole1x+iroffset+2.5,irmounty,-5]) rotate([0,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
	translate([hole2x+iroffset+2.5,irmounty,-5]) rotate([0,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_drive()	// corexy
{
	difference() {	// base
		translate([-3,-0,0]) cubeX([47,40,wall],2);
		color("black") hull() {	// nut slot
			translate([-4,belt_adjust,8]) rotate([0,90,0]) nut(nut3,14); // make room for nut
			translate([-4,belt_adjust,4]) rotate([0,90,0]) nut(nut3,14); // make room for nut
		}
		color("white") hull() {	// nut slot
			translate([31,belt_adjust,8]) rotate([0,90,0]) nut(nut3,14);
			translate([31,belt_adjust,4]) rotate([0,90,0]) nut(nut3,14);
		}
		color("blue") hull() {
			translate([21,16,-5]) cylinder(h= 20, r = 8,$fn=50); // plastic reduction
			translate([21,25,-5]) cylinder(h= 20, r = 8,$fn=50);
		}
	}
	difference() {	// right wall
		translate([-wall/2-1,0,0]) color("blue") cubeX([wall-2,40,29],2);
		translate([-wall/2-2,belt_adjust,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-wall/2-2,belt_adjust,4]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-0.5,belt_adjust,27]) rotate([0,90,0]) nut(nut3,3);
		translate([-0.5,belt_adjust,4]) rotate([0,90,0]) nut(nut3,3);
	}
	beltbump(0);
	difference() {	// left wall
		translate([36+wall/2,0,0]) color("white") cubeX([wall-2,40,29],2);
		translate([32,belt_adjust,4]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([32,belt_adjust,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([38.5,belt_adjust,4]) rotate([0,90,0]) nut(nut3,3);
		translate([32,belt_adjust,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([38.5,belt_adjust,27]) rotate([0,90,0]) nut(nut3,3);
	}
	// rear wall
	translate([-wall/2+1,42-wall,0]) color("pink") cubeX([47,wall-2,belt_adjust],2);
	// front wall
	translate([-wall/2+1,0,0]) color("cyan") cubeX([47,wall-2,belt_adjust],2);
	beltbump(1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_drive2(Dual=0)	// corexy
{
	difference() {	// right wall
		translate([-wall+wall,0,0]) color("blue") cubeX([wall-2,40,29+belt_adjustUD],2);
		translate([-wall/2-2,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-wall/2-2,belt_adjust,4+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([3.5,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
		translate([3.5,belt_adjust,4+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
	}
	beltbump2(0);
	difference() {	// left wall
		translate([35.4+wall/2,0,0]) color("white") cubeX([wall-2,40,29+belt_adjustUD],2);
		translate([32,belt_adjust,4+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([32,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([38.5,belt_adjust,4+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
		translate([32,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([38.5,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
	}
	// rear wall
	if(Dual) {
		difference() {
			translate([-wall/2+5,42-wall,0]) color("pink") cubeX([44,wall-2,belt_adjust+belt_adjustUD],2);
			translate([0,40,0]) rotate([90,0,0]) bowden_nuts(25);
		}
	} else {
		translate([-wall/2+5,42-wall,0]) color("pink") cubeX([44,wall-2,belt_adjust+belt_adjustUD],2);
	}
	// front wall
	//translate([-wall/2+1,0,0]) color("cyan") cubeX([47,wall-2,belt_adjust],2);
	beltbump2(1);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_nut_slot() {
	color("black") hull() {	// nut slot
		translate([1,belt_adjust-5,8+belt_adjustUD]) rotate([0,90,0]) nut(nut3,14); // make room for nut
		translate([1,belt_adjust-5,4+belt_adjustUD]) rotate([0,90,0]) nut(nut3,14); // make room for nut
	}
	color("white") hull() {	// nut slot
		translate([31,belt_adjust-5,8+belt_adjustUD]) rotate([0,90,0]) nut(nut3,14);
		translate([31,belt_adjust-5,4+belt_adjustUD]) rotate([0,90,0]) nut(nut3,14);
	}
	translate([-wall/2-2,belt_adjust-5,27+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
	translate([-wall/2-2,belt_adjust-5,4+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
	translate([32,belt_adjust-5,4+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
	translate([32,belt_adjust-5,27+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
	//color("blue") hull() {
	//	translate([21,16,-5]) cylinder(h= 20, r = 8,$fn=50); // plastic reduction
	//	translate([21,25,-5]) cylinder(h= 20, r = 8,$fn=50);
	//}
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module nut(Size,Length) {
	cylinder(h=Length,d=Size,$fn=6);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module beltclamp() // belt clamps and adjuster parts
{
	translate([0,0,3.5]) belt_roundclamp();
	translate([10,0,-0.5]) belt_adjuster();
	translate([25,0,4]) belt_anvil();
	translate([0,35,3.5]) belt_roundclamp();
	translate([10,35,-0.5]) belt_adjuster();
	translate([25,35,4]) belt_anvil();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_adjuster()
{
	difference() {
		minkowski() {
			translate([0,0,-wall/2+4.5]) cube([8,30,9]);
			cylinder(h = 1,r = 1,$fn=50);
		}
		translate([-1.5,5.5,9]) cube([11,7,3.5]);
		translate([-1.5,16.5,9]) cube([11,7,3.5]);
		translate([4,3,-5]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([4,26,-5]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-5,9,4.5]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-2,9,4.5]) rotate([0,90,0]) nut(nut3,3);
		translate([-5,20,4.5]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([7,20,4.5]) rotate([0,90,0]) nut(nut3,3);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_anvil()
{
	translate([0,0,-3]) rotate([0,0,90]) difference() {
		rotate([0,90,0]) cylinder(h = 9, r = 4, $fn= 100);
		translate([3,0,-6]) cube([15,10,10],true);
		translate([4,0,-3]) cylinder(h = 5, r = screw3/2,$fn = 50);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_roundclamp() // something round to let the belt smoothly move over when using the tensioner screw
{
	rotate([0,90,90]) difference() {
		cylinder(h = 30, r = 4, $fn= 100);
		translate([-6,0,3]) rotate([0,90,0])cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([-6,0,26]) rotate([0,90,0])cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([4.5,0,8]) cube([2,8,45],true); // flatten the top & bottom
		translate([-4.5,0,8]) cube([2,8,45],true);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module beltbump(Bump) { // add a little plastic at the belt clamp screw holes at the edge
	if(Bump) {
		difference() {	
			translate([40,belt_adjust,27]) rotate([0,90,0]) cylinder(h = wall-2, r = screw3+0.5,$fn=50);
			translate([32,belt_adjust,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([38.5,belt_adjust,27]) rotate([0,90,0]) nut(nut3,3);
		}
	} else {
		difference() {	
			translate([-wall/2-1,belt_adjust,27]) rotate([0,90,0]) cylinder(h = wall-2, r = screw3+0.5,$fn=50);
			translate([-wall/2-2,belt_adjust,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([-0.5,belt_adjust,27]) rotate([0,90,0]) nut(nut3,3);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module beltbump2(Bump) { // add a little plastic at the belt clamp screw holes at the edge
	if(Bump) {
		difference() {	
			translate([39.4,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) color("cyan") cylinder(h = wall-2, r = screw3+0.5,$fn=50);
			translate([32,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([38.5,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
		}
	} else {
		difference() {	
			translate([0,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) color("pink") cylinder(h = wall-2, r = screw3+0.5,$fn=50);
			translate([-wall/2-2,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([3.5,belt_adjust,27+belt_adjustUD]) rotate([0,90,0]) nut(nut3,3);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//mgn_fh = 13;	// full height of mgn12h & rail assembly

module test_z_axis() {
	single_z_axis_bracket();
	translate([34,0,8.4]) rotate([0,180,-90]) bearing_mount_v2(1);
	
	translate([6.6,0,0]) cube([mgn_fh,20,50]);
	translate([19.6,-77.2,50]) rotate([0,90,0]) z_nut_carrier();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module motor_upper_brackets_v3(Select=0) { // 0 - both, 1 - lower belt, 2 - upper belt, 3 - both motor mounts only
	if(Select==0 || Select==1) {
		difference() {
			union() {
				single_upper_bracket_v2();
				translate([-17,0,0]) cubeX([21.5,20,sq_d+10],2);
				translate([-16.5,8,15]) rotate([90,180,-90]) printchar("R",2,5);
			}
			translate([12.5,-29,0]) rotate([0,0,-180]) motor_mount_v3_screws(0);
		}
		translate([12.5,-35,2.5]) rotate([0,0,-180]) motor_mount_v3(0);
	}
	if(Select==0 || Select==2) {
		difference() {
			union() {
				translate([140,0,0]) rotate([0,0,90]) single_upper_bracket_v2();
				translate([136,0,0]) cubeX([21.5,20,sq_d+10],2);
				translate([157,12,15]) rotate([90,180,90]) printchar("L",2,5);
			}
			translate([128,-29,0]) rotate([0,0,-180]) motor_mount_v3_screws(1);
		}
		translate([128,-35,2.5]) rotate([0,0,-180]) motor_mount_v3(1);
	}
	if(Select==3) {	// just both motor mounts
		translate([128,-35,2.5]) rotate([0,0,-180]) motor_mount_v3(1);
		translate([12.5,-35,2.5]) rotate([0,0,-180]) motor_mount_v3(0);
	}
}


/////////////////////////////////////////////////////////////////////////////////////////

module motor_mount_v3(Left=0) {
	if(!Left) { // right
		difference() {
			cubeX([59,59,5],radius=2,center=true);
			translate([0,0,-4]) rotate([0,0,45])  NEMA17_x_holes(7, 2);
		}
		diag_side();
		difference() {
			translate([0,-27,23+mgn_rh/2]) color("blue") cubeX([59,5,48+mgn_rh],radius=2,center=true);
			translate([0,0,mgn_rh]) motor_mount_v3_screws(Left);
		}
		translate([0,-25,20]) rotate([-90,0,0]) printchar("R",2,5);
	} else { // left
		difference() {
			cubeX([59,59,5],radius=2,center=true);
			translate([0,0,-4]) rotate([0,0,45])  NEMA17_x_holes(7, 2);
		}
		difference() {
			diag_side();
			translate([0,0,mgn_rh+10]) motor_mount_v3_screws(Left);
		}
		difference() {
			translate([0,-27,30+mgn_rh/2]) color("blue") cubeX([59,5,65+mgn_rh],radius=2,center=true);
			translate([0,0,mgn_rh+10]) motor_mount_v3_screws(Left);
		}
		translate([0,-25,30]) rotate([-90,0,0]) printchar("L",2,5);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////

module motor_mount_v3_screws(Left,Closed=0) {
	if(!Left) {
		translate([20,8,(sq_d+10)/2]) rotate([90,0,0]) cylinder(h=100,d=screw5);
		translate([20,-15,(sq_d+10)/2]) rotate([90,0,0]) cylinder(h=10,d=screw5hd);
		translate([-20,8,(sq_d+10)/2]) rotate([90,0,0]) cylinder(h=70,d=screw5);
		translate([-20,-15,(sq_d+10)/2]) rotate([90,0,0]) cylinder(h=10,d=screw5hd);
		translate([0,11,40]) rotate([90,0,0]) cylinder(h=70,d=screw5);
		translate([0,-15,40]) rotate([90,0,0]) cylinder(h=10,d=screw5hd);
		if(Closed) {
			translate([-20,-55.7966,(sq_d+10)/2]) rotate([90,0,0]) cylinder(h=7,d=screw5hd);
			translate([0,-52.31,40]) rotate([90,0,0]) cylinder(h=7,d=screw5hd);
		}
	} else {
		translate([20,8,(sq_d+10)/2]) rotate([90,0,0]) cylinder(h=70,d=screw5);
		translate([20,-15,(sq_d+10)/2]) rotate([90,0,0]) cylinder(h=10,d=screw5hd);
		translate([-20,5,(sq_d+10)/2]) rotate([90,0,0]) cylinder(h=70,d=screw5);
		translate([-20,-15,(sq_d+10)/2]) rotate([90,0,0]) cylinder(h=10,d=screw5hd);
		translate([0,11,40]) rotate([90,0,0]) cylinder(h=70,d=screw5);
		translate([0,-15,40]) rotate([90,0,0]) cylinder(h=10,d=screw5hd);
		if(Closed) {
			translate([20,-55.7966,(sq_d+10)/2]) rotate([90,0,0]) cylinder(h=7,d=screw5hd);
			translate([0,-52.31,40]) rotate([90,0,0]) cylinder(h=7,d=screw5hd);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=4) { // print something
	linear_extrude(height = Height) text(String, font = "Liberation Sans",size=Size);
}

///////////////// end of mgn12.scad //////////////////////////////////////////////////////////////////////////////////
