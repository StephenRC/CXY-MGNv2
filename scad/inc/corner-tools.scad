// fillet and chamfer tools
// for straight and round edges
// for corners
// for filling inside edges and corners

az=0.001; //anti z fight

//==========================================================================
// chamfer_e edge

// l = length
// a = ammount of chamfer
// c = center (boolean)

module chamfer_e(l,a,c){
	translate([0,0,-c*l/2]){
		difference(){
			union(){
    linear_extrude(height=l){
				 polygon(points = [[0-az,0-az],[a+az,0-az],[0-az,a+az]], paths = [[0,1,2]],convexity=10);				 
				} //end extrude	
			} //end union		
		} //end difference
	} //end translate	
} //end module

//==========================================================================

// chamfer_c corner

// a = ammount of chamfer

module chamfer_c(a){
	translate([0,0,0]){
		difference(){
			union(){
			 polyhedron(
				 points = [[0,0,0],[a*2,0,0],[0,a*2,0],[0,0,-a*2] ],
				 faces  = [[0,2,1],[0,1,3],[0,3,2],[1,2,3]],
					convexity = 100
				);					
			} //end union								
		} //end difference
	} //end translate	
} //end module

//==========================================================================

// chamfer_r round edge

// a  = ammount of chamfer
// re = radius of edge
// i= insideout 1 = outside, -1 = inside
// fn for $fn

module chamfer_r(a,re,i,fn){
	translate([0,0,0]){
		difference(){
			union(){
    rotate_extrude(angle=360,$fn=fn){
				 translate([re*i,0,0]) rotate ([0,0,180]) polygon(points = [[0-az,0-az],[a+az,0-az],[0-az,a+az]], paths = [[0,1,2]],convexity=10);				 
				} //end extrude	
			 
			} //end union		
		} //end difference
	} //end translate	
} //end module

//==========================================================================

// fillet edge

// l = length
// r = radius
// c = center (boolean)
// fn for $fn

module fillet_e(l,r,c,fn){
	translate([r-az,r-az,-c*l/2]){
		difference(){
			union(){
    linear_extrude(height=l){
     difference(){
					 translate([-r,-r,0]) square([r+az,r+az]);
						circle(r,$fn=fn);
					} //end difference
				} //end extrude	
			} //end union		
		} //end difference
	} //end translate	
} //end module

//==========================================================================

// fillet_c corner

// r = radius
// fn for $fn

module fillet_c(r,fn){
	translate([r-az,r-az,-r+az]){
		difference(){
			union(){
			 translate([-r,-r,0]) cube([r+az,r+az,r+az]);
			} //end union		
			sphere(r,$fn=fn);
		} //end difference
	} //end translate	
} //end module

//==========================================================================

// fillet_r round edge

// rf = radius of fillet
// re = radius of edge
// i= insideout 1 = outside, -1 = inside
// fn for $fn

module fillet_r(rf,re,i,fn){
	translate([0,0,-rf+az]){
		difference(){
			union(){
			echo(rf);
    rotate_extrude(angle=360,$fn=fn){
     translate([re*i-rf,0,0]){ 
				 	difference(){
				 	 rotate ([0,0,180]) translate([-rf-az,-rf-az,0]) square([rf+az,rf+az]);
				 		circle(rf,$fn=fn);
					 } //end difference	
					} //end translate
			 } //end extrude	
			} //end union
		} //end difference
	} //end translate	
} //end module
