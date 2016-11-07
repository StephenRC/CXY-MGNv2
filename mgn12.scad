///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// mgn12 v2 - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 11/7/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CXY-MGNv2 is partially based on CXY-MSv1 printer
// Colors are for making it easier to edit the correct bits
// The x-carriage is currently for Titan+E3VD6 & Bowden+E3DV6 using Titan
//---------------------------------------------------------------------------------------------------------------------
// May need to shift the z-axis motor mount up/down
// May need to shift z-bearing mount away from mount & up/down
// Add belt mount & x endstop mount to x_carriage()
// Add x-carriage for a Wades/Makergear style setup
// Add supports for z-axis al
// May need to add printing supports for motor_upper_brackets() & idler_upper_brackets()
// May need spacers for idler_upper_brackets() and a support bracket
// Need blower fan mount & adjustable ir mount length for bowden & Wades/Makergear style
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
thickness = 7;	// thickness of base that mounts on the mgn12h
mgn_fh = 13;	// full height of mgn12h & rail assembly
mgn_rh = 8;		// height of mgn12 rail
mgn_rw = 12;	// width of mgn12 rail
mgn_oh = 7.5;	// overhange of mgn12h on the rail
idler_upper_spacer = 5;
psensord = 19;	// diameter of proximity sensor (x offset is 0)
//------------------------------------------------------------------------------------------------
bearing_bracket_width = 38;	// width of the xy bearing bracket
f625z_d = 16;		// diameter of bearing where the belt rides
Obelt_height = 26;	// how far out from the carriage plate the inner belt is on the sides
Ibelt_height = 17;	// how far out from the carriage plate the outer belt is on the sides
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
zadjust = 9.5;	// move inner cylinder hull to make connection to bar
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
// from http://wiki.e3d-online.com/wiki/E3D-v6_Documentation
e3dv6_od = 16;	// e3dv6 mount outside diameter
e3dv6_id = 12;	// e3dv6 mount inner diameter
ed3v6_tl = 3.7;	// e3dv6 mount top lad height
e3dv6_il = 6;	// e3dv6 mount inner land height
e3dv6_bl = 3;	// e3dv6 mount bottom land height
e3dv6_total = ed3v6_tl + e3dv6_il + e3dv6_bl; // e3dv6 total mount height
shift_ir_bowden = 5; // shift ir mount on bowden mount

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//single_xy_bearing_mount(0); // arg is left/right
//xy_bearing_mounts();
//feet(4); // arg is quanity to print and must be multiples of 2
//lower_brackets();
//translate([230,0,0])
//	upper_brackets();
//single_upper_bracket();
//al_ag_slots();
//al_ag_slots2();
//al_sq_slots2();
//motor_upper_brackets();
//translate([0,-130,0])
//	idler_upper_brackets();
//single_upper_bracket();
//angled_brackets(4,1); // Qty; 0 = al angle to square or 1 = square to square
//single_angled_bracket(1); // 0 = al angle to square; 1 = square to square
//x_carriage_titan();
//x_carriage_e3dv6_bowden();
rotate([-90,0,0])		// rotate is to get x_carriage_wades() in printing position
						// for BLTouch: 0 = top mounting through hole, 1 - recess mount
						// 2 - proximity sensor hole in psensord size
						// 3 - dc42's ir sensor
						// 4 or higher = none
	x_carriage_wades(3);	// 4 or higher = none
//bowden_titan();
//z_nut_carrier();
//z_nut_carriers();
//bearing_mount(1);
//z_bearing_mounts();
//translate([70,90,0]) rotate([0,0,90])
//	z_belt_motor();
//main_base(); // for test printing

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_bearing_mounts() {
	bearing_mount(1);
	translate([-37,35,-2.5]) lockring();
	translate([70,0,0]) bearing_mount(1);
	translate([-37,15,-2.5]) lockring();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_wades(recess=0) // bolt-on extruder platform, works for either makerslide or lm8uu versions
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
	if(recess == 3) { // dc42's ir sensor mount
		difference() {
			translate([irmount_width/2,5,0]) rotate([90,0,180]) iradapter();
			translate([-puck_l/2,widthE/2-7.5,-puck_w/2]) rotate([90,0,0]) main_base_mounting();
		}
	}
	translate([puck_l/2,widthE/2-7.5,puck_w/2]) rotate([90,180,0]) main_base();
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_nut_carriers() {
	z_nut_carrier();
	translate([puck_l+5,0,0]) z_nut_carrier();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_nut_carrier() {
	main_base2();
	difference() {
		translate([33,0,29]) rotate([0,0,90]) znut2(1);
		translate([0,64,0]) main_base_mounting();
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
	single_xy_bearing_mount(0,1);
	translate([58,0,0]) single_xy_bearing_mount(1,0);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_xy_bearing_mount(Left=0,YEndStop=0) {
	main_base(5);
	difference() {
		translate([(puck_l/2)-((sq_w+10)/2),(puck_w/2)-((sq_d+10)/2),0]) al_mount();
		main_base_mounting();
	}
	color("navy") translate([puck_l/2-6.5,puck_w-3,thickness-1]) cube([13,4,12]);
	if(!Left) translate([(puck_l-bearing_bracket_width)/2,puck_w,0]) b_mount(0,1); // may need to be swapped
	if(Left) translate([(puck_l-bearing_bracket_width)/2,puck_w,0]) b_mount(1,1);
	if(YEndStop) y_endstop_strike();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module y_endstop_strike() { // not needed
	//translate([0,0,thickness-4]) cubeX([5,puck_w,6],2); // extra bump for endstop to hit
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_mount() { // holds x-axis to y-axis slider
	difference() {
		color("green") cubeX([sq_w+10,sq_d+10,20],2);
		color("red") translate([5,5,-1]) cube([sq_w,sq_d,25]);
		color("blue") translate([-5,puck_w/2-2,10+thickness/2]) rotate([0,90,0]) cylinder(h=sq_w+20,d=screw3);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_base(Wider=0) { // main part that mounts on the mgn12h
	difference() {
		cubeX([puck_l,puck_w+Wider,thickness],2);
		main_base_mounting();
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
	//translate([10,80-2.5,0]) color("red") cylinder(h=50,d=screw3);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module main_base_mounting() {	// mounting holes to mgn12h
	color("red") translate([(puck_l/2)+(hole_sep/2),3.5,-1]) cylinder(h=thickness*2,d=screw3);
	color("blue") translate([(puck_l/2)-(hole_sep/2),3.5,-1]) cylinder(h=thickness*2,d=screw3);
	color("white") translate([(puck_l/2)+(hole_sep/2),hole_sep+3.5,-1]) cylinder(h=thickness*2,d=screw3);
	color("black") translate([(puck_l/2)-(hole_sep/2),hole_sep+3.5,-1]) cylinder(h=thickness*2,d=screw3);
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
	if(spacers) {	// don't need them for the test prints after the first print
		translate([-10,one_stack-2,0]) rotate([0,0,-0]) bearspacer(one_stack);
		translate([-10,one_stack*2,0]) rotate([0,0,-0]) bearspacer(one_stack);
	}
}

//////////////////////////////////////////////////////////////////////////////////////

module walls(upper,lower) {	// the walls that hold the bearings
	if(lower) {
		difference() {	// lower bearing support wall
			color("cyan") cubeX([bearing_bracket_width,5,belt_height+f625z_d],2);
			bearscrews(upper);
		}
	} else {
		difference() {	// upper bearing support wall
			color("lightblue") translate([0,one_stack*2+5,0]) cubeX([bearing_bracket_width,5,belt_height+f625z_d],2);
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

///////////////////////////////////////////////////////////////////////////////////////////

module base() { // base mount
	color("white") cubeX([bearing_bracket_width,one_stack*2+10,thickness],2);
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
	for(i=[0:1]) {
		translate([i*110,0,0]) {
			single_lower_bracket();
		}
	}
	for(i=[0:1]) {
		translate([i*110,110,0]) {
			single_lower_bracket();
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_lower_bracket() {
	difference() {
		union() {
			difference() {
			cubeX([100,100,sq_w+10],2);
			translate([0,0,-1]) cylinder(h=sq_w+12,d=147,$fn=100);
			lower_screws();
			}
			difference() {
				translate([0,90-sq_w,100]) rotate([-90,0,0]) difference() {
					cubeX([100,100,sq_w+10],2);
					translate([0,0,-1]) cylinder(h=sq_w+12,d=147,$fn=100);
				}
				lower_screws();
			}
			translate([174,0,0]) rotate([0,0,90]) difference() {
				translate([0,90-sq_w,100]) rotate([-90,0,0]) difference() {
					cubeX([100,100,sq_w+10],2);
					translate([0,0,-1]) cylinder(h=sq_w+12,d=146,$fn=100);
				}
				lower_screws();
			}
		}
		al_sq_slots();
		translate([0,130,20]) rotate([90,0,0]) lower_screws2();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_sq_slots() { // square al slots
	color("Red") translate([6,104.5-sq_w,sq_d]) cube([150,sq_w,sq_d],true);		// horz
	color("Blue") translate([105-sq_w,4,sq_w-4.5]) cube([sq_w,150,sq_d],true);	// horz
	color("Green") translate([104.5-sq_w,105-sq_w,50]) cube([sq_d,sq_w,150],true); //vert
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_sq_slots2() { // square al slots
	color("Red") translate([5,103.5-sq_w,sq_d-1.2]) cube([150,sq_w,sq_d],true);		// horz
	color("Blue") translate([104.5-sq_w,3.5,sq_w-4.5]) cube([sq_w,150,sq_d],true);	// horz
	color("Green") translate([104.5-sq_w,105-sq_w,80.5]) cube([sq_d,sq_w,150],true); //vert
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module lower_screws() {	// mounting screw holes
	color("Red") translate([104-sq_w,20,-1]) cylinder(h=150,d=screw3);
	color("Red") translate([104-sq_w,20,28]) cylinder(h=50,d=screw3hd+1);
	color("Cyan") translate([104-sq_w,58,-1]) cylinder(h=150,d=screw3);
	color("Cyan") translate([102.5-sq_w,58,54]) cylinder(h=50,d=screw3hd+1);
	color("Purple") translate([20,102.5-sq_w,-1]) cylinder(h=150,d=screw3);
	color("Purple") translate([20,102.5-sq_w,28]) cylinder(h=50,d=screw3hd+1);
	color("Green") translate([60,102.5-sq_w,-1]) cylinder(h=150,d=screw3);
	color("Green") translate([60,102.5-sq_w,54]) cylinder(h=50,d=screw3hd+1);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module lower_screws2() {	// mounting screw holes
	color("Violet") translate([104-sq_w,20,-1]) cylinder(h=150,d=screw3);
	color("Violet") translate([104-sq_w,20,84]) cylinder(h=50,d=screw3hd+1);
	color("Olive") translate([104-sq_w,60,-1]) cylinder(h=150,d=screw3);
	color("Olive") translate([104-sq_w,60,58]) cylinder(h=50,d=screw3hd+1);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
shiftmgn = 0;

module motor_upper_brackets() {
	translate([0,0,12.5]) {
		difference() {
			single_upper_bracket();
			translate([73,-2,-4.3]) cube([mgn_rw+2*mgn_oh+1,120,10]);
		}
		translate([90,124.5,-(mgn_rh+shiftmgn+10)]) motor_mount();
		translate([98,79,9]) cubeX([21.5,20,20],2);
		diag_side3();
		translate([45,0,8]) diag_side3();
	}
	translate([0,0,22.5]) {
		difference() {
			translate([-10,0,0]) rotate([0,0,90]) single_upper_bracket();
			translate([-110.5,-2,-4.3]) cube([mgn_rw+2*mgn_oh+1,120,10]);
		}
		translate([-95.5,125.2,-(mgn_rh+shiftmgn+20)]) motor_mount();
		translate([-125,75.7,6]) cubeX([18,25,15],2);
		diag_side2();
		translate([-40,4,3]) diag_side2();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

module diag_side3() {
	difference() {
		translate([62,81.5,3]) rotate([-58,0,0]) color("blue") cubeX([10,27,10],2);
		translate([61,96.5,-43]) cube([12,15,50],2);
		translate([60,71.5,13]) rotate([0,90,0]) cube([12,50,15],2);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

module diag_side2() {
	difference() {
		translate([-82,70.5,12]) rotate([-58,0,0]) color("yellow") cubeX([10,50,10],2);
		translate([-83,96.5,-45]) cube([12,15,50],2);
		translate([-83,53.5,17]) rotate([0,90,0]) cube([12,50,15],2);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module idler_upper_brackets() {
	difference() {
		single_upper_bracket();
		translate([74,-2,-4.3]) cube([mgn_rw+2*mgn_oh+1,120,10]);
	}
	translate([100.8,126.7,35.8-mgn_fh]) rotate([180,0,0]) mirror() bearing_bracket(0,b_posY);
	translate([60,120,-mgn_fh+5.805]) bearspacer(idler_upper_spacer);
	difference() {
		translate([-10,-1.2,0]) rotate([0,0,90]) single_upper_bracket(0);
		translate([-110.5,-2,-4.3]) cube([mgn_rw+2*mgn_oh+1,120,10]);
	}
	translate([-110.01,126,35.8-mgn_fh]) rotate([180,0,0]) bearing_bracket(0,b_posY-1);
	translate([-60,120,-mgn_fh+5.805]) bearspacer(idler_upper_spacer);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module upper_brackets() { // for the horizontal al angles to vertical square
	for(i=[0:1]) {
		translate([i*110,0,0]) {
			single_upper_bracket();
		}
	}
//	translate([0,110,0]) for(i=[0:1]) {
//		translate([i*110,0,0]) {
//			single_upper_bracket();
//		}
//	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_upper_bracket() { // for the horizontal al angles to vertical square
	difference() {	
		union() {
			difference() {
			color("grey") cubeX([100,100,sq_w+10],2);
			translate([0,0,-1]) cylinder(h=sq_w+12,d=147,$fn=100);
			lower_screws();
			}
			difference() {
				translate([0,90.01-sq_w,100]) rotate([-90,0,0]) difference() {
					color("cornsilk") cubeX([100,100,sq_w+10],2);
					translate([0,0,-1]) cylinder(h=sq_w+12,d=146,$fn=100);
				}
				lower_screws();
			}
			translate([174,0,0]) rotate([0,0,90]) difference() {
				translate([0,90-sq_w,100]) rotate([-90,0,0]) difference() {
					color("white") cubeX([100,100,sq_w+10],2);
					translate([0,0,-1]) cylinder(h=sq_w+12,d=146,$fn=100);
				}
				lower_screws();
			}
		}
		translate([0,0,0]) al_sq_slots2();
		translate([0,130,20]) rotate([90,0,0]) lower_screws2();
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
			// mounting screw holes
			translate([20,30.5-sq_w,-1]) cylinder(h=150,d=screw3);
			translate([68,30.5-sq_w,-1]) cylinder(h=150,d=screw3);
			translate([135-ag_w,-20,ag_w+4.5]) rotate([0,180,45]) al_angle(150);
		}
	} else { //	if(Sq) {
		difference() {
			cubeX([100,30,ag_w+10],2);
			// al slots
			translate([90,sq_w-1.5,sq_d]) cube([100,sq_w,sq_d],true);
			// mounting screw holes
			translate([102.5-sq_w,15,-1]) cylinder(h=150,d=screw3);
			translate([55.5-sq_w,15,-1]) cylinder(h=150,d=screw3);
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
	translate([0,0,puck_w+thickness/2+4.5]) rotate([-90,0,180]) main_base();
	translate([-puck_l,-(thickness*2),0]) cubeX([puck_l,thickness*2,wall],2);
	translate([-5,-21,4]) cubeX([5,thickness*3,puck_w+4],2);
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
	translate([0,-30,0]) rotate([90,0,90]) titanmotor();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titan2() { // extruder platform for e3d titan to mount on a AL extruder plate
	difference() {
		translate([0,0,0]) cubeX([40,53,5],2); // extruder side
		translate([20,28,-10]) cylinder(h=20,d=20,$fn=100); // remove some plastic under the motor
		translate([10,10,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		translate([30,10,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		translate([10,45,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		translate([30,45,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
	}
	translate([0,1,0]) rotate([90,0,90]) titanmotor();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titan3() { // extruder platform for e3d titan to mount directly on the x-carraige
	difference() {
		translate([0,0,0]) cubeX([40,56,5],2); // extruder side
		translate([20,28,-10]) cylinder(h=20,d=20,$fn=100); // remove some plastic under the motor
	}
	translate([0,1,0]) rotate([90,0,90]) titanmotor(3);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titanmotor(WallMount) {
	difference() {	// motor mounting holes
		if(WallMount) {
			translate([-1,0,0]) cubeX([57,50,5],2);
		} else {
			translate([-1,0,0]) cubeX([54,50,5],2);
		}
		translate([25,25+shifttitanup,-1]) rotate([0,0,45])  NEMA17_x_holes(8, 2);
	}
	difference() { // front support
		translate([-1,0,0]) cubeX([4,50,50],2);
		translate([-3,50,4]) rotate([56,0,0]) cube([7,50,70]);
		translate([-4,-4,36]) cube([wall,wall,wall]);
	}
	if(WallMount) {
		difference() { // rear support
			translate([52,0,0]) cubeX([4,50,40],2);
			translate([40,15,15]) rotate([0,90,0]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
			translate([40,15+i3x_sep,15]) rotate([0,90,0])  cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		}
	} else {
		difference() { // rear support
			translate([49,0,0]) cubeX([4,50,50],2);
			translate([47,50,4]) rotate([56,0,0]) cube([7,50,70]);
			translate([47,-4,36]) cube([wall,wall,wall]);
		}
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
	rotate([0,0,270]) difference() {
		translate([-6,24.5,-7]) rotate([0,-33,0]) color("red") cubeX([50,5,10],2);
		translate([-20,23.5,-10]) cube([50,10,10],2);
		translate([27,23.5,40]) rotate([0,90,0]) cube([50,10,10],2);
	}
	rotate([0,0,270]) difference() {
		translate([-6,-29.5,-7]) rotate([0,-33,0]) color("cyan") cubeX([50,5,10],2);
		translate([-20,-30.5,-10]) cube([50,10,10],2);
		translate([27,-30.5,40]) rotate([0,90,0]) cube([50,10,10],2);
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
		cubeX([30,30,30],2);
		if(TapIt)
			translate([Ypos,b_posX,-2]) cylinder(h=50,r=screw5t/2);
		else
			translate([Ypos,b_posX,-2]) cylinder(h=50,r=screw5/2);
		if(!TapIt) translate([Ypos,b_posX,-b_height-20]) cylinder(h=50,d=nut5_d,$fn=6); // nut hole
	}
}

//////////////////////////////////////////////////////////////////////////////////////////

module bearing_support() {	// keep the bearing from tilting on the bracket
	difference() { // vertical
		translate([-1,-10,0]) cubeX([Vthickness,40,one_stack*2+b_height+43],2); // vertical
		translate([-3,0,10]) rotate([0,90,0]) cylinder(h=20,d=screw5); // screw mounting holes
		translate([-3,20,10]) rotate([0,90,0]) cylinder(h=20,d=screw5);
		translate([-3,0,30]) rotate([0,90,0]) cylinder(h=20,d=screw5);
		translate([-3,20,30]) rotate([0,90,0]) cylinder(h=20,d=screw5);
		if(NotchIt)	translate([Vthickness+3,-40,33]) rotate([0,0,90]) ms_notch(); // notch it?
	}
	difference() { // top
		translate([0,0,one_stack*2+b_height+38]) cubeX([50,20,Tthickness],2);
		translate([Vthickness+28,10,one_stack*2+b_height]) cylinder(h=50,d=screw5);
	}
	difference() { // angled support for top
		translate([-11,8,one_stack*2+b_height+30]) rotate([0,45,0]) cubeX([20,Tthickness,45],2);
		translate([-19,7,one_stack*2+b_height+10]) cube([20,7,40]);
		translate([-4,7,one_stack*2+b_height+42]) cube([40,7,25]);
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
	if(Type==0) ; // nothing
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

module bearing_hole() {	// holds the bearing
	translate([0,0,-6.5]) difference() {
		translate([0,0,thickness/3]) cylinder(h=h_608,d=dia_608+5,$fn=100);
		translate([0,0,0]) cylinder(h=15,d=dia_608,$fn=100);
	}
	translate([0,0,-10]) difference() {
		translate([0,0,thickness/3]) cylinder(h=h_608/2,d=dia_608+5,$fn=100);
		translate([0,0,0]) cylinder(h=15,d=nut_clearance,$fn=100);
	}
	bearing_hole_support();
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

module attached_idler(Spc=0,Spt=0) { // Spc = spacers, Spt = add support to attached idler plate
	if(Spt) {
		difference() { // needs to be a bit wider with Spt==1
			translate([-12,30,-2.5]) cubeX([39.5,40,thickness],2);
			translate([-2,60,-5]) cylinder(h=10,d=screw5);
			translate([dia_f625z-dia_f625z/2+2,60-dia_f625z,-5]) cylinder(h=10,d=screw5);
		}
	} else {
		difference() {
			translate([-12,30,-2.5]) cubeX([33,40,thickness],2);
			translate([-2,60,-5]) cylinder(h=10,d=screw5);
			translate([dia_f625z-dia_f625z/2+2,60-dia_f625z,-5]) cylinder(h=10,d=screw5);
		}
	}
	if(Spt) translate([22.5,26,-2.5]) cubeX([thickness,44,thickness*3],2);
	if(Spc) translate([-7.5,10,-2.5]) idler_spacers(1,idler_spacer_thickness);
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

module x_carriage_e3dv6_bowden() {
	difference() {
		main_base();
		translate([0,puck_w/2-e3dv6_total/2,1]) bowden_screws();
	}
	translate([0,puck_w/2-e3dv6_total/2,1]) bowden_mount();
	translate([0,35,0]) rotate([0,0,0]) bowden_clamp();
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
	translate([35,puck_w/2-e3dv6_total/2-0.5,-1.5]) color("red") cylinder(h=4,d=nut4,$fn=6);
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,-1.5]) color("blue") cylinder(h=4,d=nut4,$fn=6);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_nut_support() {
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,2.51]) color("red") cylinder(h=layer,d=nut4);
	translate([35,puck_w/2-e3dv6_total/2-0.5,2.51]) color("blue") cylinder(h=layer,d=nut4);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_clamp() {
	difference() {
		translate([e3dv6_od/2,0,0]) cubeX([e3dv6_od*2,e3dv6_total,15],2);
		translate([e3dv6_od+e3dv6_od/2,e3dv6_total,16]) rotate([90,0,0]) e3dv6();
		translate([0,0,-10]) bowden_screws();
	}
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
		translate([3,4,11.5]) cubeX([5,5,hole2x+8+shift_ir_bowden]);
		translate([0,6.5,hole2x+14.5+shift_ir_bowden]) rotate([0,90,0]) color("red") cylinder(h=10,d=screw3t);
		bowden_bottom_ir_mount_hole();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_bottom_ir_mount_hole() {
	translate([-1,6.5,14.5+shift_ir_bowden]) color("blue") rotate([0,90,0]) cylinder(h=15,d=screw3t);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_fan() {
	difference() {
		translate([40,4,10]) cubeX([5,5,fan_spacing+8]);
		translate([39,6.5,fan_spacing+14.5]) rotate([0,90,0]) color("red") cylinder(h=10,d=screw3t);
		bowden_bottom_fan_mount_hole();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_bottom_fan_mount_hole() {
	translate([37,6.5,14.5]) rotate([0,90,0]) color("blue") cylinder(h=15,d=screw3t);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_titan() { // mount for the Titan for a bowden setup
	titan2();
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
	ir_supports();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ir_supports() {
	difference() {
		translate([0,6,-12]) rotate([38,0,0]) cubeX([5,irmount_height,irmount_height+5],2);
		translate([-1.5,-5,-16]) cube([10,30,20],2);
		translate([-1.5,-5,23]) cube([10,30,20],2);
		translate([-1.5,-33,-1]) cube([10,30,20],2);
	}
	difference() {
		translate([irmount_width-5,6,-12]) rotate([38,0,0]) cubeX([5,irmount_height,irmount_height+5],2);
		translate([irmount_width-6,-5,-16]) cube([10,30,20],2);
		translate([irmount_width-6,-5,23]) cube([10,30,20],2);
		translate([irmount_width-6,-33,-1]) cube([10,30,20],2);
	}
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

///////////////// end of mgn12.scad //////////////////////////////////////////////////////////////////////////////////
