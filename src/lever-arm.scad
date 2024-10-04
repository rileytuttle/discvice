include <../openscad-library-manager/BOSL2/std.scad>
use <screws.scad>

$fn=50;

module lever_arm(
    lever_arm_spec,
    linkage_spec,
    joint_spec,
    screw_spec,
    anchor=CENTER, spin=0, orient=UP) {
    lever_arm_main_body_length = struct_val(lever_arm_spec, "main body length");
    linkage_arm_joint_diam = struct_val(linkage_spec, "joint diam");
    joint_outer_diam = struct_val(joint_spec, "outer_diam");
    linkage_arm_thickness = struct_val(linkage_spec, "thickness");
    linkage_arm_hole_diam = struct_val(linkage_spec, "hole diam");
    linkage_arm_width = struct_val(linkage_spec, "width");
    arm_hole_displacement = [-lever_arm_main_body_length, 0, 0];
    peg_displacement = [0, 0, 0];
    fill_length = joint_outer_diam + 1 - linkage_arm_joint_diam + 1.5;
    overall_thickness = struct_val(screw_spec, "length");
    anchor_list = [
        named_anchor("arm-hole-center", arm_hole_displacement),
        named_anchor("screw-center", peg_displacement),
    ];
    attachable(spin=spin, anchor=anchor, orient=orient, anchors=anchor_list) {
        diff() {
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
                        cube([lever_arm_main_body_length-fill_length/2 - linkage_arm_joint_diam/2 - 7/2, 9, overall_thickness], anchor=LEFT+BACK) {
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
                force_tag("remove") position(TOP) machine_screw_pocket(joint_spec, screw_spec, anchor=TOP);
            }
        }
        children();
    }
}

lever_arm();
