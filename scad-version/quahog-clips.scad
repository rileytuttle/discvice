include <BOSL2/std.scad>
use <main-jaw.scad>
include <assem-utils.scad>
use <lower-jaw.scad>
use <lever-arm.scad>
use <linkage.scad>
use <screw-peg.scad>

$fn=50;

name = "Wheels";
name_placement = [34.5, 0.0];
name_rotation = 0;
name_size = 4.01;
name_info = [name, name_placement, name_size, name_rotation];

boolbrother=false;

everything_else = false;

module plain_vice() {
    main_jaw(static=true, logo=false, overall_thickness=overall_thickness, spare_linkage=false) {
        position("screw-peg-center")
        lower_jaw(spin=lower_jaw_angle, overall_thickness=overall_thickness) {
            position("screw-peg-center")
            lever_arm(anchor="arm-hole-center", spin=lever_arm_angle, overall_thickness=overall_thickness);
        }
        translate(abs_lever_arm_joint_displacement) {
        linkage_arm(
            linkage_arm_length,
            linkage_arm_hole_diam,
            linkage_arm_joint_diam,
            linkage_arm_thickness,
            linkage_arm_width,
            anchor="left-hole", spin=abs_angle_of_linkage_arm
            );
        }
    }
}

module quahog_vice()
{
    main_jaw(static=true, logo=true, logo_text=false, overall_thickness=overall_thickness, spare_linkage=false, name_info=name_info, quahog_logo=true) {
        if (everything_else) {
            position("screw-peg-center")
            lower_jaw(spin=lower_jaw_angle, overall_thickness=overall_thickness, boolbrother=boolbrother) {
                position("screw-peg-center")
                lever_arm(anchor="arm-hole-center", spin=lever_arm_angle, overall_thickness=overall_thickness);
            }
            translate(abs_lever_arm_joint_displacement)
            linkage_arm(
                linkage_arm_length,
                linkage_arm_hole_diam,
                linkage_arm_joint_diam,
                linkage_arm_thickness,
                linkage_arm_width,
                anchor="left-hole", spin=abs_angle_of_linkage_arm
                );
        }
    }
}

quahog_vice();
