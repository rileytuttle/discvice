//      This frisbee vice library is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This may not be used for commericial purposes without consulting the original writer.

//     This frisbee vice library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

//     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

include <../openscad-library-manager/BOSL2/std.scad>
use <linkage.scad>
use <screws.scad>
use <main-body.scad>
use <lower-jaw.scad>

$fn=50;
overall_thickness = 8;

/* [joint settings] */
joint_wall = 2.25;
joint_outer_diam = 10;
joint_thickness = overall_thickness - joint_wall*2;
joint_spec = struct_set([], [
    "outer_diam", joint_outer_diam,
    "thickness", joint_thickness]);

/* [linkage arm settings] */
// arm width
linkage_arm_width = 5;
// arm hole diam
linkage_arm_hole_diam = 3.5;
// arm length
linkage_arm_length = 13.5;
// joint diam
linkage_arm_joint_diam = 8.5; 
linkage_arm_thickness = overall_thickness-joint_wall*2 - 0.4;
linkage_arm_spec = struct_set([], [
    "width", linkage_arm_width,
    "hole diam", linkage_arm_hole_diam,
    "length", linkage_arm_length,
    "joint diam", linkage_arm_joint_diam,
    "thickness", linkage_arm_thickness]);

/* [carriage settings] */
carriage_size = [15, 10, 7];
carriage_joint_offset = 1;
carriage_spec = struct_set([], [
    "size", carriage_size,
    "joint_offset", carriage_joint_offset]);

/* [main body settings] */
main_body_height = 20;
main_body_right_side_len = 22;
main_body_spec = struct_set([], [
    "thickness", overall_thickness,
    "height", main_body_height,
    "right_side_len", main_body_right_side_len,
    "screw1_disp", [-7, -main_body_height, 0],
    "screw2_disp", [main_body_right_side_len-joint_outer_diam/2, -(main_body_height+carriage_joint_offset+joint_outer_diam/2), 0]]);

/* [logo settings] */
discvice_logo_diam = 15;
logo_spec = struct_set([], [
    "logo_diam", discvice_logo_diam]);
/* [lower jaw settings] */    
lower_jaw_joint_displacement = [1, -13, 0];
lower_jaw_spec = struct_set([], [
    "joint_disp", lower_jaw_joint_displacement]);

module assem()
{
    main_body(main_body_spec=main_body_spec,
              carriage_spec=carriage_spec,
              joint_spec=joint_spec,
              linkage_arm_spec=linkage_arm_spec,
              logo_spec=logo_spec)
        position("screw1-center") lower_jaw(anchor="screw1-center");
    // linkage_arm(linkage_arm_spec);
}

assem();
