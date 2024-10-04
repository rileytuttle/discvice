include <../openscad-library-manager/BOSL2/std.scad>
use <screws.scad>
use <logo.scad>

$fn=50;

module main_body(
    main_body_spec,
    carriage_spec,
    joint_spec,
    linkage_arm_spec,
    logo_spec,
    screw_spec,
    anchor=CENTER, spin=0, orient=UP)
{
    joint_outer_diam = struct_val(joint_spec, "outer_diam");
    carriage_joint_offset = struct_val(carriage_spec, "joint_offset");
    linkage_arm_witdh = struct_val(linkage_arm_spec, "width");
    main_body_right_side_len = struct_val(main_body_spec, "right_side_len");
    main_body_height = struct_val(main_body_spec, "height");
    overall_thickness = struct_val(main_body_spec, "thickness");
    linkage_arm_width = struct_val(linkage_arm_spec, "width");
    joint_thickness = struct_val(joint_spec, "thickness");
    discvice_logo_diam = struct_val(logo_spec, "logo_diam");
    screw1_disp = struct_val(main_body_spec, "screw1_disp");
    screw2_disp = struct_val(main_body_spec, "screw2_disp");
    anchor_list = [
        named_anchor("screw1-center", screw1_disp),
        named_anchor("screw2-center", screw2_disp), 
    ];
    attachable(spin=spin, anchor=anchor, orient=orient, anchors=anchor_list) {
        diff("remove")
        {
            // right side main
            cuboid([main_body_right_side_len, main_body_height, overall_thickness], anchor=BACK+LEFT, rounding=5, edges=BACK+RIGHT) {
                // add the carriage joint at a certain distance
                position(FRONT+RIGHT)
                fwd(carriage_joint_offset+joint_outer_diam/2)
                cyl(d=joint_outer_diam, l=overall_thickness, anchor=RIGHT) {
                    cube([joint_outer_diam, carriage_joint_offset+joint_outer_diam/2, overall_thickness], anchor=FRONT){
                        tag("remove")
                        position(FRONT)
                        cube([joint_outer_diam+0.1, linkage_arm_width/2, joint_thickness+0.1], anchor=CENTER);
                    }
                    force_tag("remove")
                    position(TOP) machine_screw_pocket(joint_spec, screw_spec, anchor=TOP);
                }
                // left side main
                position(LEFT)
                cuboid([30, main_body_height, overall_thickness], anchor=RIGHT, rounding=5, edges=LEFT+BACK) {
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
                }
                // joint outer meat
                position(LEFT+FRONT)
                right(screw1_disp[0])
                cyl(d=joint_outer_diam, l=overall_thickness) {
                    force_tag("remove")
                    position(TOP) machine_screw_pocket(joint_spec, screw_spec, anchor=TOP);
                }

                // logo
                force_tag("remove")
                position(LEFT+BACK+TOP)
                left(6.75)
                fwd(8.25)
                cyl(d=discvice_logo_diam, l=0.5)
                position(BOTTOM)
                d_negative(d=discvice_logo_diam, l=overall_thickness, anchor=TOP);

                // logo text
                tag("remove")
                position(TOP+LEFT)
                right(0.8)
                back(1)
                up(0.01) {
                    size = 8;
                    anchor = TOP+LEFT;
                    h = 0.5;
                    right(0.75) text3d("isc", h=h, size=size, anchor=anchor, spacing=1);
                    fwd(9) text3d("vice", h=h, size=size, anchor=anchor, spacing=1);
                }
            }
        }
        children();
    }
}
