include <BOSL2/std.scad>
include <common-dims.scad>
use <screw-peg.scad>

$fn=30;

module lever_arm(anchor=CENTER, spin=0, orient=UP) {
    arm_hole_displacement = [-lever_arm_main_body_length, 0, 0];
    peg_displacement = [0, 0, 0];
    fill_length = joint_outer_diam + 1 - linkage_arm_joint_diam + 1.5;
    anchor_list = [
        named_anchor("arm-hole-center", arm_hole_displacement),
        named_anchor("screw-peg-center", peg_displacement),
    ];
    attachable(spin=spin, anchor=anchor, orient=orient, anchors=anchor_list) {
        difference() {
            // joint socket thing
            cyl(d=joint_outer_diam, l=overall_thickness) {
                // inner joint
                translate(arm_hole_displacement)
                tube(id=linkage_arm_hole_diam, od=linkage_arm_joint_diam, l=linkage_arm_thickness) {
                    // fill between inner joint and main body
                    position(RIGHT)
                    right(linkage_arm_hole_diam/2)
                    cube([fill_length, linkage_arm_width, linkage_arm_thickness], anchor=RIGHT) {
                        // main body
                        position(RIGHT+BACK)
                        cube([lever_arm_main_body_length-fill_length/2 - linkage_arm_joint_diam/2 - screw_peg_thread_major/2, 9, overall_thickness], anchor=LEFT+BACK) {
                            // lever arm
                            position(LEFT+FRONT)
                            zrot(-25)
                            cube([30, 5, overall_thickness], anchor=LEFT+FRONT);
                            // little fill between outer joint and arm
                            position(RIGHT+FRONT)
                            zrot(-25)
                            cube([2, 3, overall_thickness], anchor=RIGHT+FRONT) {
                                fillet_r = 0.3;
                                back(0.19)
                                position(RIGHT)
                                fillet(l=overall_thickness, r=fillet_r, anchor=CENTER)
                                    position(BACK)
                                    fillet(l=overall_thickness, r=fillet_r, anchor=RIGHT, spin=-90);
                            }
                        }
                        position(FRONT+RIGHT)
                        fillet(l=linkage_arm_thickness, r=4, spin=180);
                    }
                }
            }
            screw_peg_pocket();
        }
        children();
    }
}

lever_arm();
