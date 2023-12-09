include <BOSL2/std.scad>
include <common-dims.scad>
use <screw-peg.scad>
use <logo.scad>

$fn=30;

right_side_main_body_len = screw_channel_len+screw_channel_offset+neck_collar_len;

module main_jaw(anchor=CENTER, spin=0, orient=UP) {
    anchor_list = [
        named_anchor("neck-collar", main_jaw_neck_collar_center_displacement),
        named_anchor("screw-peg-center", main_peg_displacement),
    ];
    attachable(spin=spin, anchor=anchor, orient=orient, anchors=anchor_list) {
        diff("remove") {
            // right side main
            cuboid([right_side_main_body_len, main_jaw_body_height, overall_thickness], anchor=BACK+LEFT, rounding=5, edges=BACK+RIGHT) {
                // remove screw channel
                tag("remove")
                position(FRONT+RIGHT)
                left(neck_collar_len)
                cube([screw_channel_len, 10, overall_thickness], anchor=FRONT+RIGHT) {
                    // screw tip pocket
                    position(LEFT+FRONT+BOTTOM)
                    back(5)
                    up(flat_dist_from_center)
                    // cyl(d=5, l=5, rounding2=1.5, anchor=BOTTOM, orient=LEFT)
                    teardrop(d=main_body_tip_hole_diam, l=screw_tip_length+0.5, anchor=FRONT, spin=90, ang=50);
                    // collar pocket
                    position(RIGHT+FRONT+BOTTOM)
                    back(5)
                    up(flat_dist_from_center)
                    teardrop(d=main_body_collar_hole_diam, l=neck_length, anchor=FRONT, spin=-90, ang=50);
                }
                // joint outer meat
                position(LEFT+FRONT)
                left(7)
                cyl(d=joint_outer_diam, l=overall_thickness) {
                    force_tag("remove")
                    screw_peg_pocket();
                }
                // left side main
                position(LEFT)
                cuboid([30, main_jaw_body_height, overall_thickness], anchor=RIGHT, rounding=5, edges=LEFT+BACK) {
                    // remove throat circle
                    tag("remove")
                    position(RIGHT+BACK)
                    left(18)
                    fwd(12.5)
                    cyl(d=7, l=overall_thickness+1)
                        // remove throat middle
                        xrot(-90)
                        cuboid([7, overall_thickness+1, 20-12.5], anchor=TOP, chamfer=-2.5, edges=BOTTOM+RIGHT);
                    // add more throat
                    position(LEFT+FRONT)
                    cuboid([30 - 18 - 7/2, 9, overall_thickness], anchor=BACK+LEFT, rounding=4, edges=FRONT+RIGHT);
                }
                // logo
                force_tag("remove")
                position(LEFT+BACK+TOP)
                left(7)
                fwd(8)
                cyl(d=discvice_logo_diam, l=0.5)
                position(BOTTOM)
                d_negative(d=discvice_logo_diam, l=overall_thickness+1, anchor=TOP);
                // logo text
                tag("remove")
                position(TOP+LEFT)
                right(1)
                back(1.75)
                up(0.01)
                text3d("iscvice", h=0.5, size=7, anchor=TOP+LEFT);

                // // clip hole
                // position(BACK+RIGHT)
                // left(18/2)
                // cyl(d=18, l=overall_thickness)
                //     tag("remove")
                //     cyl(d=12, l=overall_thickness+0.1, rounding=-3, teardrop=true);
            }
        }
        children();
    }
}

main_jaw();
