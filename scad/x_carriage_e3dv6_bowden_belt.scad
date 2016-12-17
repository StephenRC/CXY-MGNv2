///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// x_carriage_e3dv6_bowden_belt.scad - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 12/13/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Printer name: CXY-MGNv2
// Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-mgnv2-h.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

translate([40,40,0]) bowden_titan();
x_carriage_e3dv6_bowden_belt(1,0);
//x_carriage_e3dv6_bowden_belt(1,1,0);	// third arg moves second mount up/down, if down(-)
										// this hasn't been fully tested
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
	translate([PosX,PosY,PosZ])	belt_drive2(Dual);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module nut(Size,Length) {
	cylinder(h=Length,d=Size,$fn=6);
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_carriage_belt_mountscrews(PosX,PosY,PosZ) {
	translate([PosX+5,PosY+10,PosZ+4]) rotate([90,0,0]) color("blue") cylinder(h=40,d=screw3t);
	translate([PosX+fan_spacing+5,PosY+10,PosZ+4]) rotate([90,0,0]) color("red") cylinder(h=40,d=screw3t);
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
