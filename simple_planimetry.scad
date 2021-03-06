/*
Make simple extrusions from dxf

dxf layers: default values are true. Set false if you don't want to draw it.
Example: you can set ceiling=false if you want to se in the house.

INPUTS:
file
floor_thickness=0.3
internal_height=3
ceiling_thickness=0.3
doors_external_height=2.3
doors_internal_height=2
windows_height=1.5
windows_height_from_floor=1
windows_high_height=0.5
windows_high_height_from_floor=2.3
railings_height=1
walls=true
floor=true
ceiling=true
railings=true
doors_external=true
doors_internal=true
windows=true
windows_high=true
*/
module build_dxf(file, floor_thickness=0.3, internal_height=3, ceiling_thickness=0.3, doors_external_height=2.3, doors_internal_height=2, windows_height=1.5, windows_height_from_floor=1, windows_high_height=0.5, windows_high_height_from_floor=2.3, railings_height=1, walls=true, floor=true, ceiling=true, railings=true, doors_external=true, doors_internal=true, windows=true, windows_high=true){
  render(convexity=10){
    difference(){
      union(){
        if(floor) _extrude_layer(file, "floor", floor_thickness, -floor_thickness);
        if(walls) _extrude_layer(file, "walls", internal_height);
        if(ceiling) _extrude_layer(file, "ceiling", ceiling_thickness, internal_height);
        if(railings) _extrude_layer(file, "railings", railings_height);
        _extrude_layer(file, "doors_external", internal_height);
        _extrude_layer(file, "doors_internal", internal_height);
        _extrude_layer(file, "windows", internal_height);
        _extrude_layer(file, "windows_heigh", internal_height);
      }
      union(){
        if(doors_external) _extrude_layer(file, "doors_external", doors_external_height);
        if(doors_internal) _extrude_layer(file, "doors_internal", doors_internal_height);
        if(windows) _extrude_layer(file, "windows", windows_height, windows_height_from_floor);
        if(windows_high) _extrude_layer(file, "windows_high", windows_high_height, windows_high_height_from_floor);
      }
    }
  }
}

/*
Extrude custom layer.

INPUTS:
file: dxf file
layer: layer name from dxf file
height: extrusion
lift=0: move the object up
*/
module _extrude_layer(file, layer, height, lift=0){
  translate([0,0,lift])
  linear_extrude(height)
  import (file, layer);
}

/*
Build wall frame for doors and windows

INPUTS:
hole_width: the width of the wall hole
hole_depth: the depth of the wall hole
hole_height: the height of the wall hole
frame_thickness: the thickness of the frame
frame_overhang: the overhang of the frame
erase_bottom: true to erase the frame at the bottom
*/
module wall_frame(hole_width, hole_depth, hole_height, frame_thickness, frame_overhang, erase_bottom=false){
  render(convexity=10){
    difference(){
      // Frame Bounding
      if (frame_overhang == 0){
        cube([hole_width, hole_depth, hole_height], center=false);
      }
      else {
        translate([-frame_overhang, -frame_thickness, -frame_overhang])
        cube([hole_width+frame_overhang*2, hole_depth+frame_thickness*2, hole_height+frame_overhang*2], center=false);
      }
      
      // Frame hole
      translate([frame_thickness, -frame_thickness, frame_thickness])
      cube([hole_width-frame_thickness*2, hole_depth+frame_thickness*2, hole_height-frame_thickness*2], center=false);
      
      // The wall
      difference(){
        translate([-frame_overhang, 0, -frame_overhang])
        cube([hole_width+frame_overhang*2, hole_depth, hole_height+frame_overhang*2], center=false);
        cube([hole_width, hole_depth, hole_height], center=false);
      }
      
      // Erase the frame at the bottom?
      if (erase_bottom){
        translate([-frame_overhang, -frame_thickness, -frame_overhang])
        cube([hole_width+frame_overhang*2, hole_depth+frame_thickness*2, frame_overhang], center=false);
        translate([frame_thickness, -frame_thickness, 0])
        cube([hole_width-frame_thickness*2, hole_depth+frame_thickness*2, frame_thickness], center=false);
      }
    }
  }
}
