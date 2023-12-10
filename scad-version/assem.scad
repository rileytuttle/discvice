include <BOSL2/std.scad>
use <tightening-screw.scad>
use <main-jaw.scad>
use <carriage.scad>
use <lever-arm.scad>
include <common-dims.scad>
use <screw-peg.scad>
use <lower-jaw.scad>
use <linkage.scad>
include <rosetta-stone/std.scad>

$fn=30;

lower_jaw_angle = -15;
// calculate abs lower jaw peg
remapped_lower_jaw_joint_displacement = rotate_coords(lower_jaw_joint_displacement, lower_jaw_angle);
abs_lower_jaw_joint_displacement = [
    main_peg_displacement[0]+remapped_lower_jaw_joint_displacement[0],
    main_peg_displacement[1]+remapped_lower_jaw_joint_displacement[1]];
echo(str("lower jaw joint displacement in abs coord", abs_lower_jaw_joint_displacement));
// calculate abs lever arm peg
// calculate abs carriage peg
// carriage_fudge_x = pitch*0.7;
carriage_fudge_x = pitch * 0.89;
abs_carriage_peg_displacement = [
    // main_jaw_neck_collar_center_displacement[0] - neck_length/2 - carriage_fudge_x - carriage_collar_center_displacement[0]/2,
    main_jaw_neck_collar_center_displacement[0] - neck_length/2 - carriage_fudge_x - carriage_collar_length/2 - carriage_collar_center_displacement[0] + carriage_screw_peg_center_displacement[0],
    main_jaw_neck_collar_center_displacement[1] + carriage_screw_peg_center_displacement[1]
];
echo(str("carriage joint displacement in abs coord", abs_carriage_peg_displacement));

dist_main_peg_to_carriage_peg = dist_between_points2d(main_peg_displacement, abs_carriage_peg_displacement);
dist_main_peg_to_lower_jaw_peg = dist_between_points2d(main_peg_displacement, abs_lower_jaw_joint_displacement);
dist_lower_jaw_peg_to_carriage_peg = dist_between_points2d(abs_lower_jaw_joint_displacement, abs_carriage_peg_displacement);

theta1 = acos((dist_main_peg_to_carriage_peg^2 - dist_main_peg_to_lower_jaw_peg^2 - dist_lower_jaw_peg_to_carriage_peg^2) / (-2*dist_main_peg_to_lower_jaw_peg*dist_lower_jaw_peg_to_carriage_peg));
theta2 = acos((linkage_arm_length^2 - dist_lower_jaw_peg_to_carriage_peg^2 - lever_arm_main_body_length^2)/ (-2 * dist_lower_jaw_peg_to_carriage_peg * lever_arm_main_body_length));
lever_arm_angle2 = 90-theta1+theta2;

echo(str("theta1 " , theta1));
echo(str("theta2 ", theta2));
echo(str("relative angle ", theta1+theta2 - 90));

angle_from_main_peg_to_lower_jaw_peg = angle_between_points2d(main_peg_displacement, abs_lower_jaw_joint_displacement);
echo(str("angle between main peg and lower jaw peg", angle_from_main_peg_to_lower_jaw_peg));

rotation_we_should_use = theta1+theta2-90-(90+angle_from_main_peg_to_lower_jaw_peg) +lower_jaw_angle;

echo(str("thing I want", rotation_we_should_use));

// lever_arm_angle = -12.5;
lever_arm_angle = -rotation_we_should_use;
lever_arm_abs_angle = lever_arm_angle + lower_jaw_angle;
remapped_lever_arm_joint_displacement = rotate_coords([lever_arm_main_body_length, 0], lever_arm_abs_angle);
abs_lever_arm_joint_displacement = [
    abs_lower_jaw_joint_displacement[0] + remapped_lever_arm_joint_displacement[0],
    abs_lower_jaw_joint_displacement[1] + remapped_lever_arm_joint_displacement[1]
];
echo(str("lever arm joint displacement in abs coord", abs_lever_arm_joint_displacement));

abs_angle_of_linkage_arm = angle_between_points2d(abs_lever_arm_joint_displacement, abs_carriage_peg_displacement);
echo(str("dist, angle between lever arm and carriage joints", dist_between_points2d(abs_carriage_peg_displacement, abs_lever_arm_joint_displacement), ", ", abs_angle_of_linkage_arm))
echo(str("angle of linkage arm relative to lever arm = ", lever_arm_abs_angle - abs_angle_of_linkage_arm));

main_jaw() {
    position("neck-collar")
    make_screw(anchor="neck-center", spin=-90, orient=LEFT)
        up(carriage_fudge_x)
        position("collar-center")
        make_carriage(anchor="collar-center", orient=BACK, spin=90);
    position("screw-peg-center")
    lower_jaw(spin=lower_jaw_angle) {
        position("screw-peg-center")
        lever_arm(anchor="arm-hole-center", spin=lever_arm_angle);
    }
}
translate(abs_lever_arm_joint_displacement)
linkage_arm(anchor="left-hole", spin=abs_angle_of_linkage_arm);
