// http://www.thingiverse.com/thing:387301

$fn=100;

$fs=0.1;
module FanDuct() {
	tol=0.10;
	wallThickness=1;//0.8;

	module Shape(dia) {
		hull() {
			cube([15.2+dia*2,20+dia*2,3],center=true);
			translate([0,-5,25])cylinder(h=0.1,d=10+dia*2);
		}
		hull() {
			translate([0,-5,25])cylinder(h=0.1,d=10+dia*2);
			translate([0,-5,45])rotate([30,0,0])scale([1.0,0.5,1])cylinder(h=0.5-dia/12,d=7+dia*3);
		}
	}

	difference() {
		Shape(dia=wallThickness+tol);
		Shape(dia=tol);
	}
}


FanDuct();