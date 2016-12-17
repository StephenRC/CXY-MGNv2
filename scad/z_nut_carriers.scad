///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// z_nut_carriers.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/13/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

z_nut_carriers(); // add arg of 1 for just one; defaults to two carriers

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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
