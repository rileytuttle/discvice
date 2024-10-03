//      This disc vice library is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This may not be used for commericial purposes without consulting the original writer.

//     This disc vice library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

//     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

include <../openscad-library-manager/BOSL2/std.scad>
use <linkage.scad>
use <screws.scad>
use <main-body.scad>
use <lower-jaw.scad>
use <lever-arm.scad>
include <assembly-calculations.scad>

$fn=50;

/* [screw settings] */
// If this works you should be able to set to whatever type of screw you have lying around (that's close in size) but I have only tested M3x0.5x8mm flat (or countersink) head
screw_type = "M3x0.5";
screw_head = "flat"; // ["flat", "socket"];
screw_length = 8;
screw_spec = struct_set([], [
    "type", screw_type,
    "head", screw_head,
    "length", screw_length]);

overall_thickness = screw_length;

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
    "overall_thickness", overall_thickness,
    "joint_disp", lower_jaw_joint_displacement]);
    
/* [lever arm settings] */
lever_arm_main_body_length = 15;
lever_arm_spec = struct_set([], [
    "main body length", lever_arm_main_body_length]);
    
/* [assembly specific settings] */
lower_jaw_angle = -10;
spins = calculate_spins(
    lower_jaw_angle,
    lower_jaw_spec,
    joint_spec,
    carriage_spec,
    linkage_arm_spec,
    lever_arm_spec);
echo(str("lever arm abs spin: ", spins[0]));
echo(str("linkage arm abs spin: ", spins[1])); 

module assem()
{
    main_body(main_body_spec=main_body_spec,
              carriage_spec=carriage_spec,
              joint_spec=joint_spec,
              linkage_arm_spec=linkage_arm_spec,
              logo_spec=logo_spec,
              screw_spec=screw_spec)
        position("screw1-center")
        lower_jaw(
            lower_jaw_spec,
            joint_spec,
            linkage_arm_spec,
            screw_spec,
            anchor="screw1-center",
            spin=lower_jaw_angle)
            position("screw2-center")
            lever_arm(
                lever_arm_spec=lever_arm_spec,
                linkage_spec=linkage_arm_spec,
                joint_spec=joint_spec,
                screw_spec=screw_spec,
                spin=spins[0],
                anchor="arm-hole-center")
                    position("screw-center")
                    linkage_arm(
                        linkage_arm_spec,
                        spin=spins[1],
                        anchor="left-hole");
}

assem();
