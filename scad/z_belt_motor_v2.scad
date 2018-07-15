///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// z_belt_motor_v2.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/13/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

z_belt_motor_v2(1,1,0);

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
	if(idler) attached_idler(Iplate,1,1);	// add idler to the motor mount
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module al_sq_slots_m() { // square al slots
	color("Red") translate([50,104.5-sq_w,sq_d]) cube([150,sq_w,sq_d],true);		// horz
}

////////////////////////////////////////////////////////////////////////////

module nema_plate(makerslide=0) {
	difference() {
		translate([0,-(shaft_offset-base_offset),0]) color("pink") cubeX([b_width,b_length,thickness],2,center=true);
		translate([0,-shaft_offset,-4]) rotate([0,0,45]) NEMA17_x_holes(7, 2);
		if(makerslide) notchit();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////

module side_support_v2() {
	translate([b_width/2-thickness,-(b_length-28.5),-(sq_d+6)]) color("cyan") cubeX([thickness,b_width,sq_d+8],2);
	translate([-(b_width/2),-(b_length-28.5),-(sq_d+6)]) color("blue") cubeX([thickness,b_width,sq_d+8],2);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module attached_idler(Spc=0,Spt=0,QtySpc=1) { // Spc = spacers, Spt = add support to attached idler plate
	if(Spt) {
		difference() { // needs to be a bit wider with Spt==1
			translate([-27.5,30,-2.5]) color("Red") cubeX([55,20,thickness],2);
			translate([-dia_f625z+dia_f625z/2-8,60-dia_f625z,-5]) color("purple") cylinder(h=10,d=screw5);
			translate([dia_f625z-dia_f625z/2+8,60-dia_f625z,-5]) color("gray") cylinder(h=10,d=screw5);
		}
	} else {
		difference() {
			translate([-12,30,-2.5]) color("Red") cubeX([33,40,thickness],2);
			translate([-2,60,-5]) color("purple") cylinder(h=10,d=screw5);
			translate([dia_f625z-dia_f625z/2+2,60-dia_f625z,-5]) color("gray") cylinder(h=10,d=screw5);
		}
	}
	if(Spt) {
		translate([22.5,26,-2.5]) color("yellow") cubeX([thickness,24,thickness*4.36],2);
		translate([-27.5,26,-2.5]) color("green") cubeX([thickness,24,thickness*4.36],2);
	}
	if(Spc) translate([-7.5,10,-2.5]) idler_spacers(QtySpc,idler_spacer_thickness);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module idler_spacers(Two=0,Thk=idler_spacer_thickness,Spt=0) {
	difference() {
		color("Red") cylinder(h=Thk,d=screw5+5);
		translate([0,0,-1]) color("pink") cylinder(h=idler_spacer_thickness*2,d=screw5);
	}
	if(Two) {
		translate([15,0,0]) difference() {
			color("blue") cylinder(h=Thk,d=screw5+5);
			translate([0,0,-1]) color("cyan") cylinder(h=idler_spacer_thickness*2,d=screw5);
		}
	}
}

