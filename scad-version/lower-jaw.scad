include <BOSL2/std.scad>
include <common-dims.scad>
use <screw-peg.scad>

$fn=50;


module lower_jaw(anchor=CENTER, spin=0, orient=UP) {
    joint_displacement = [1, -13, 0];
    anchor_list = [
        named_anchor("screw-peg-center", joint_displacement),
    ];
    attachable(anchor=anchor, spin=spin, orient=orient, anchors=anchor_list) {
        xrot(180)
        diff() {
            // linkage joint
            cyl(d=linkage_arm_joint_diam, l=linkage_arm_thickness) {
                // joint socket
                back(-joint_displacement[1])
                right(joint_displacement[0])
                // translate(joint_displacement)
                cyl(d=joint_outer_diam, l=overall_thickness)
                    force_tag("remove")
                    screw_peg_pocket(orient=DOWN);
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
