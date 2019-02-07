///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// z_axis_brackets_bearing.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/16/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 12/16/16 - Added more colors for preview
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

z_axis_brackets_bearing(); // 0 - one bracket; no arg defaults to two

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_axis_brackets_bearing(Qty_of_2=1) {
	single_z_axis_bracket();
	translate([34,0,8.4]) rotate([0,180,-90]) bearing_mount_v2(1);
	translate([37,37,-10.9]) lockring();
	if(Qty_of_2) {
		translate([-40,0,0]) {
			mirror([0,0,0]) single_z_axis_bracket();
			translate([-34,0,8.4]) rotate([0,180,90]) bearing_mount_v2(0);
			translate([-37,37,-10.9]) lockring();
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_z_axis_bracket() {
	difference() {
		color("teal") cubeX([sq_w+10,125,sq_w+5],2,center=true);
		translate([0,0,sq_w]) z_al_sq_slots();
	}
	difference() {
		translate([0,0,30]) color("cyan") cubeX([sq_w+10,sq_w+10,60],2,center=true);
		translate([20,0,59]) cube([sq_w+10,mgn_rw+mgn_oh*2,100],true);
		translate([0,0,sq_w]) z_al_sq_slots();
	}
	z_axis_support();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_mount_v2(Spc=0,SpcThk=idler_spacer_thickness) { // bearing holder at bottom of z-axis
	rotate([180,0,0]) {
		side_support_v2();
		difference() {
			translate([0,-(shaft_offset-base_offset),0]) color("peru") cubeX([b_width,b_length,thickness],2,center=true);
			translate([0,-shaft_offset,-6]) cylinder(h=10,d=dia_608,$fn=100);
		}
		translate([0,-shaft_offset,0]) bearing_hole(0);
	}
	one_attached_idler_v2(1);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module one_attached_idler_v2(Spc=0) { // Spc = spacers, Spt = add support to attached idler plate
	difference() { // needs to be a bit wider with Spt==1
		translate([-27.5,30,-2.5]) color("salmon") cubeX([54.5,25,thickness],2);
		translate([dia_f625z-dia_f625z/2+2,60-dia_f625z,-5]) cylinder(h=10,d=screw5);
		translate([-dia_f625z+5,60-dia_f625z,-5]) cylinder(h=10,d=screw5);
	}
	translate([22.5,26,-2.5]) color("darkorange") cubeX([thickness,29,sq_d+8.5],2);
	translate([-27.5,26,-2.5]) color("orangered") cubeX([thickness,29,sq_d+8.5],2);
	if(Spc) translate([35,20,12.3]) idler_spacers(0,idler_spacer_thickness);
}

/////////////////////////////////////////////////////////////////////////////////////////

module side_support_v2() {
	translate([b_width/2-thickness,-(b_length-28.5),-(sq_d+6)]) color("coral") cubeX([thickness,b_width,sq_d+8],2);
	translate([-(b_width/2),-(b_length-28.5),-(sq_d+6)]) color("tomato") cubeX([thickness,b_width,sq_d+8],2);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_axis_support() {
	difference() {
		translate([-2.5,53,3]) rotate([45,0,0]) color("blue") cubeX([5,10,70],2);
		translate([-3.5,-41,-15]) cube([7,50,90]);
		translate([-3.5,-20,-45]) cube([7,90,50]);
	}
	difference() {
		translate([-2.5,-53,3]) color("red") rotate([45,0,0]) cubeX([5,70,10]);
		translate([-3.5,-10,-15]) cube([7,80,90]);
		translate([-3.5,-70,-45]) cube([7,90,50]);
	}

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_al_sq_slots() { // square al slots
	color("Blue") translate([0,0,sq_w-37.3]) cube([sq_w,300,sq_d+2],true);	// horz
	color("Green") translate([0,0,64]) cube([sq_d,sq_w,150],true); //vert
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_hole(Support=1) {	// holds the bearing
	translate([0,0,-6.5]) difference() {
		translate([0,0,thickness/3]) color("plum") cylinder(h=h_608,d=dia_608+8,$fn=100);
		translate([0,0,0]) cylinder(h=15,d=dia_608,$fn=100);
	}
	translate([0,0,-10]) difference() {
		translate([-25,-16,thickness/3-2]) color("navy") cubeX([dia_608+27,dia_608+10,h_608/2+2]);
		//cylinder(h=h_608/2,d=dia_608+12,$fn=100);
		translate([0,0,-5]) cylinder(h=15,d=nut_clearance,$fn=100);
	}
	if(Support) bearing_hole_support();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_hole_support() { // print support for bearing hole
	translate([0,0,-5]) cylinder(h=layer,d=dia_608+5,$fn=100);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module idler_spacers(Two=0,Thk=idler_spacer_thickness,Spt=0) {
	difference() {
		color("dimgray") cylinder(h=Thk,d=screw5+5);
		translate([0,0,-1]) cylinder(h=idler_spacer_thickness*2,d=screw5);
	}
	if(Two) {
		translate([15,0,0]) difference() {
			color("gray") cylinder(h=Thk,d=screw5+5);
			translate([0,0,-1]) cylinder(h=idler_spacer_thickness*2,d=screw5);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module lockring() { // lock ring to hold TR8 leadscrew in bearing, may not be necessary since gravity will hold it
	difference() {
		color("black") cylinder(h=h_608+1,d=nut_clearance-2,$fn=100);
		translate([0,0,-1]) cylinder(h=15,d=TR8_d,$fn=100);
		translate([0,0,2.5]) rotate([90,0,0]) cylinder(h=10,d=screw3t);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

