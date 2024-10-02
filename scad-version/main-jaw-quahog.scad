include <BOSL2/std.scad>
include <common-dims.scad>
use <screw-peg.scad>
use <logo.scad>
use <linkage.scad>

$fn=30;

module main_jaw(anchor=CENTER, spin=0, orient=UP, static=false, spare_linkage=false, machine_screw=true, jaw_strength_screw=false) {

    anchor_list = [
        if(!static) named_anchor("neck-collar", main_jaw_neck_collar_center_displacement),
        named_anchor("screw-peg-center", main_peg_displacement),
        if(static) named_anchor("screw-peg-2-center", main_jaw_screw_peg_2_displacement), 
    ];
    attachable(spin=spin, anchor=anchor, orient=orient, anchors=anchor_list) {
        diff("remove") {
            // right side main
            cuboid([right_side_main_body_len, main_jaw_body_height, overall_thickness], anchor=BACK+LEFT, rounding=5, edges=BACK+RIGHT) {
                if (!static) {
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
                        teardrop(d=main_body_tip_hole_diam, l=screw_tip_length+0.5, anchor=FRONT, spin=90, ang=55);
                        // collar pocket
                        position(RIGHT+FRONT+BOTTOM)
                        back(5)
                        up(flat_dist_from_center)
                        teardrop(d=main_body_collar_hole_diam, l=neck_length, anchor=FRONT, spin=-90, ang=50);
                    }
                }
                else
                {
                    // add the carriage joint at a certain distance
                    position(FRONT+RIGHT)
                    fwd(carriage_joint_offset+joint_outer_diam/2)
                    cyl(d=joint_outer_diam, l=carriage_size[2], anchor=RIGHT) {
                        cube([joint_outer_diam, carriage_joint_offset+joint_outer_diam/2, overall_thickness], anchor=FRONT){
                            tag("remove")
                            position(FRONT)
                            cube([joint_outer_diam+0.1, linkage_arm_width/2, joint_thickness+0.1], anchor=CENTER);
                        }
                        force_tag("remove")
                        if (machine_screw)
                        {
                            machine_screw_pocket(add_supports=socket_supports);
                        }
                        else
                        {
                            screw_peg_pocket();
                        }
                    }
                    // // version string
                    // position(FRONT+LEFT+TOP)
                    // tag("remove")
                    // back(5)
                    // right(1)
                    // text3d(version_string, h=0.5, size=4, anchor=TOP+LEFT);
                }
                // joint outer meat
                position(LEFT+FRONT)
                left(7)
                cyl(d=joint_outer_diam, l=overall_thickness) {
                    force_tag("remove")
                    if (machine_screw)
                    {
                        machine_screw_pocket(add_supports=socket_supports);
                    }
                    else
                    {
                        screw_peg_pocket();
                    }
                }
                // left side main
                position(LEFT)
                cuboid([30, main_jaw_body_height, overall_thickness], anchor=RIGHT, rounding=5, edges=LEFT+BACK) {
                // remove throat circle
                    move_fwd_dist=13;
                    tag("remove")
                    position(RIGHT+BACK)
                    left(18)
                    fwd(move_fwd_dist)
                    cyl(d=7, l=overall_thickness+1)
                        // remove throat middle
                        xrot(-90)
                        cuboid([7, overall_thickness+1, 20-move_fwd_dist], anchor=TOP, chamfer=-2.5, edges=BOTTOM+RIGHT);
                    // add more throat
                    position(LEFT+FRONT)
                    cuboid([30 - 18 - 7/2, 9, overall_thickness], anchor=BACK+LEFT, rounding=4, edges=FRONT+RIGHT);

                    // flame string
                    tag("remove")
                    position(LEFT+BACK+TOP) {
                        fwd(2.5)
                        right(1.5)
                        text3d("FLAME", h=0.5, size=5.5, anchor=FRONT+LEFT+TOP, spin=-90);
                    }
                    // add screw for jaw strength
                    if (jaw_strength_screw)
                    {
                        position(LEFT+BACK)
                        force_tag("remove")
                        fwd(5)
                        right(1.5)
                        screw_hole("M3x0.5", head="socket", thread=true, l=13, anchor=TOP, orient=LEFT)
                        position(TOP)
                        cyl(d=5.5, l=3, anchor=BOTTOM);
                    }
                }

                // logo
                force_tag("remove") {
                volcano_depth = 0.5;
                position(LEFT+BACK+TOP)
                left(6.75)
                fwd(8.25)
                cyl(anchor=TOP, d=discvice_logo_diam*0.80, l=overall_thickness, rounding2=-1, rounding1=-1);
                
                }
                // logo text
                // tag("remove")
                // position(TOP+LEFT)
                // right(0.8)
                // back(1.75)
                // up(0.01)
                // text3d(static ? "iscv" : "iscvice", h=0.5, size=7, anchor=TOP+LEFT);

                // // clip hole
                // position(BACK+RIGHT)
                // left(18/2)
                // cyl(d=18, l=overall_thickness)
                //     tag("remove")
                //     cyl(d=12, l=overall_thickness+0.1, rounding=-3, teardrop=true);
                
                // extra_linkage_cutouts
                if (spare_linkage) {
                    position(BOTTOM)
                    left(1.5)
                    fwd(1.5)
                    rotate(45)
                    {
                        // the pocket
                        // down(0.1) 
                        force_tag("remove")
                        linkage_arm(linkage_arm_length2, linkage_arm_hole_diam-0.5, linkage_arm_joint_diam+0.3, linkage_arm_thickness+0.4, linkage_arm_width+0.3, anchor=BOTTOM);
                        // the linkage arm
                        tag("keep")
                        // up(0.1)
                        linkage_arm(linkage_arm_length2, linkage_arm_hole_diam, linkage_arm_joint_diam, linkage_arm_thickness, linkage_arm_width, anchor=BOTTOM) {
                            position(BOTTOM)
                            cyl(d=2.5, l=overall_thickness/2, anchor=BOTTOM);
                        }
                    }
                }
                fwd(1) position(TOP) tag("remove") up(0.1) volcano_badge(d=14, l=0.6, anchor=TOP);
            }
        }
        children();
    }
}

module volcano_badge(d=10, l=1, anchor=CENTER, orient=UP, spin=0)
{
    outer_teardrop = d;
    inner_teardrop = outer_teardrop * 0.45;
    thickness = l;
    attachable(anchor=anchor, orient=orient, spin=spin, size=[0, 0, thickness])
    {
        difference() {
            union() {
                teardrop(d=outer_teardrop, l=thickness, orient=BACK);
                back(1.5)
                difference() {
                    back_half()
                    back(2) cyl(d=outer_teardrop, l=thickness);
                    back(2) teardrop(d=outer_teardrop * 0.9, l=thickness+1, anchor=TOP, orient=FRONT, ang=60);
                }
            }
            fwd(0.5) teardrop(d=inner_teardrop, l=thickness+1, orient=BACK);
        }
        children();
    }
}

// bottom_half()
main_jaw(static=true, spare_linkage=true);
// volcano_badge();
