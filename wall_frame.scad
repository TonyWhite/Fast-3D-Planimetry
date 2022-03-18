use <simple_planimetry.scad>;

// Wall with the holes
wall_width=7;
wall_height=3;
wall_depth=0.2;

// Hole for door
wall_hole1_width=1.0;
wall_hole1_height=2.2;

// Hole for window
wall_hole2_width=1.0;
wall_hole2_height=0.7;
wall_hole2_lift=1.5;

// Draw wall with holes
render(convexity=10){
  difference(){
    translate([-1.5, 0, 0]) cube([wall_width, wall_depth, 3]);
    cube([wall_hole1_width, wall_depth, wall_hole1_height]);
    translate([2.5, 0, wall_hole2_lift]) cube([wall_hole2_width, wall_depth, wall_hole2_height]);
  }
}

// Draw the door's frame
color("brown")
wall_frame(hole_width=wall_hole1_width, hole_depth=wall_depth, hole_height=wall_hole1_height, frame_thickness=0.01, frame_overhang=0.04, erase_bottom=true);

// Draw the window's frame
color("brown")
translate([2.5, 0, wall_hole2_lift])
wall_frame(hole_width=wall_hole2_width, hole_depth=wall_depth, hole_height=wall_hole2_height, frame_thickness=0.01, frame_overhang=0.04, erase_bottom=false);