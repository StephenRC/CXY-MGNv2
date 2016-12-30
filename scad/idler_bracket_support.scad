///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// idler_bracket_support.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/13/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

idler_bracket_support();
translate([40,0,0]) idler_bracket_support();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
nozzle = 0.5;

module idler_bracket_support() {
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////