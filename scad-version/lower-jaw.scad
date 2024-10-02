include <BOSL2/std.scad>
include <common-dims.scad>
use <screw-peg.scad>

$fn=50;


module lower_jaw(machine_screw=true, anchor=CENTER, spin=0, orient=UP, overall_thickness=7, boolbrother=false) {
    anchor_list = [
        named_anchor("screw-peg-center", lower_jaw_joint_displacement),
    ];
    attachable(anchor=anchor, spin=spin, orient=orient, anchors=anchor_list) {
        xrot(180)
        tag_scope("jaw-scope")
        diff() {
            // linkage joint
            cyl(d=linkage_arm_joint_diam, l=linkage_arm_thickness) {
                // joint socket
                back(-lower_jaw_joint_displacement[1])
                right(lower_jaw_joint_displacement[0])
                // translate(joint_displacement)
                cyl(d=joint_outer_diam, l=overall_thickness)
                    force_tag("remove")
                    machine_screw_pocket(orient=DOWN, add_supports=socket_supports, overall_thickness=overall_thickness);
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
                if(boolbrother)
                {
                    back(21)
                    left(10)
                    down(0.01)
                    down(overall_thickness/2) tag("remove") text3d("BOOL", h=0.5, size=5, anchor=TOP, orient=DOWN, spin=180+30);
                }
            }
        }
        children();
    }
}

module lower_jaw_tosy(machine_screw=true, anchor=CENTER, spin=0, orient=UP) {
    anchor_list = [
        named_anchor("screw-peg-center", lower_jaw_joint_displacement),
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
                    if (machine_screw)
                    {
                        machine_screw_pocket(orient=DOWN, add_supports=socket_supports);
                    }
                    else
                    {
                        screw_peg_pocket(orient=DOWN);
                    }
                // linkage arm
                linkage_arm_length = 8;
                cube([8, linkage_arm_length, linkage_arm_thickness], anchor=FRONT) {
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
                // tosy disc contour cutout
                tag("remove")
                zrot(-2)
                fwd(1)
                intersection() {
                    fwd(29)
                    left(35)
                    cyl(d=100, l=overall_thickness+1);
                    left(5)
                    cube([100, 100, overall_thickness+1], anchor=RIGHT);
                }
            }
        }
        children();
    }
}

lower_jaw_tosy();
    // position("screw-peg-center")
    // screw_peg();
