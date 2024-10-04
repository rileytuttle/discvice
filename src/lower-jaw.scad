include <../openscad-library-manager/BOSL2/std.scad>
use <screws.scad>

$fn=50;

module lower_jaw(
    lower_jaw_spec,
    joint_spec,
    linkage_spec,
    screw_spec,
    anchor=CENTER, spin=0, orient=UP) {
    lower_jaw_joint_displacement = struct_val(lower_jaw_spec, "joint_disp");
    linkage_arm_thickness = struct_val(linkage_spec, "thickness");
    linkage_arm_joint_diam = struct_val(linkage_spec, "joint diam");
    overall_thickness = struct_val(lower_jaw_spec, "overall_thickness");
    joint_outer_diam = struct_val(joint_spec, "outer_diam");
    linkage_arm_hole_diam = struct_val(linkage_spec, "hole diam");
    anchor_list = [
        named_anchor("screw1-center", [0, 0, 0]),
        named_anchor("screw2-center", lower_jaw_joint_displacement),
    ];
    attachable(anchor=anchor, spin=spin, orient=orient, anchors=anchor_list) {
        xrot(180)
        diff() {
            // linkage joint
            cyl(d=linkage_arm_joint_diam, l=linkage_arm_thickness) {
                // joint socket
                back(-lower_jaw_joint_displacement[1])
                right(lower_jaw_joint_displacement[0])
                // translate(joint_displacement)
                cyl(d=joint_outer_diam, l=overall_thickness)
                    force_tag("remove")
                    position(BOTTOM) machine_screw_pocket(joint_spec, screw_spec, anchor=TOP, orient=DOWN);
                // linkage arm
                cube([8, 8, linkage_arm_thickness], anchor=FRONT) {
                    position(BACK+RIGHT)
                    // main body
                    cuboid([30, 20, overall_thickness], anchor=FRONT+RIGHT, rounding=8, edges=BACK+LEFT)
                        tag("remove")
                        position(RIGHT+BACK)
                        fwd(11)
                        cube([50, 20, overall_thickness+1], anchor=RIGHT+FRONT, spin=-30);
                    position(BACK)
                    cube([8, 2, overall_thickness], anchor=BACK);
                    position(LEFT+BACK)
                    fillet(r=2, l=overall_thickness, spin=180);
                }
                // disc contour cutout
                tag("remove")
                left(30)
                fwd(5)
                cyl(d=50, l=overall_thickness+1);
                // linkage joint hole
                tag("remove")
                cyl(d=linkage_arm_hole_diam, overall_thickness+1);
            }
        }
        children();
    }
}

lower_jaw();
    // position("screw-peg-center")
    // screw_peg();
