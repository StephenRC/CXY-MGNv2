///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// cxy-mgn.h - variable file for the CXY-MGNv2, a corexy with mgn12 rails
// created: 10/31/2016
// last modified: 1/2/2017
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
use <inc/Nema17.scad>	// https://github.com/mtu-most/most-scad-libraries
$fn=50;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/2/17 - X & Y endstops are held by a M3 screw in the hole at the end of the MGN rail.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
puck_l = 45.4;	// length of mgn12h
puck_w = 27;	// width of mgn12h
hole_sep = 20;	// distance between mouning holes on mgn12h
mgn_fh = 13;	// full height of mgn12h & rail assembly
mgn_rh = 8;		// height of mgn12 rail
mgn_rw = 12;	// width of mgn12 rail
mgn_oh = 7.5;	// overhange of mgn12h on the rail
// next two must change by the same amount
idler_upper_spacer_height = 15; // raise/lower idler height
adjust_motor_height = -3; // raise/lower motor x&y mounts
psensord = 19;	// diameter of proximity sensor
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
fan_offset = 10;	// adjust to align fan with extruder
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
belt_adjust = 25;	// belt clamp hole position (increase to move rearward)
belt_adjustUD = 2;	// move belt clamp up/down
nut3 = 6.2;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
