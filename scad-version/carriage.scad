include <BOSL2/std.scad>
include <common-dims.scad>
use <tightening-screw.scad>
use <screw-peg.scad>

joint_offset = 1;

$fn=30;


internal_screw_rotation = 205;

module make_carriage(anchor=CENTER, spin=0, orient=UP) {
    anchor_list = [
        named_anchor("screw-center", [0, 0, -carriage_size[2]/2 + flat_dist_from_center]),
        named_anchor("collar-center", carriage_collar_center_displacement),
        named_anchor("screw-peg-center", carriage_screw_peg_center_displacement),
    ];
    attachable(anchor=anchor, spin=spin, orient=orient, size=carriage_size, anchors=anchor_list) {
        diff() {
            // main body
            cube(carriage_size, anchor=CENTER) {
                // connector piece
                position(RIGHT+FRONT)
                cube([joint_outer_diam, (joint_outer_diam/2+joint_offset) - (linkage_arm_width/2), carriage_size[2]], anchor=BACK+RIGHT);
                // joint outer meat
                position(RIGHT+FRONT)
                fwd(joint_offset+joint_outer_diam/2)
                cyl(d=joint_outer_diam, l=carriage_size[2], anchor=RIGHT) {
                    position(CENTER)
                    cube([joint_outer_diam/2, joint_outer_diam/2, carriage_size[2]], anchor=FRONT+LEFT);
                    // remove joint socket
                    force_tag("remove")
                    position(CENTER)
                    screw_peg_pocket();
                }
                // remove collar pocket
                tag("remove")
                position(RIGHT+BOTTOM)
                up(flat_dist_from_center) {
                    teardrop(d=snap_collar_diam+collar_fudge, l=carriage_collar_length, anchor=FRONT, spin=90, ang=60, cap_h=4.5);
                }
                // remove threads
                force_tag("remove")
                position(LEFT+BOTTOM)
                up(flat_dist_from_center)
                left(pitch)
                make_internal_threads(l=carriage_size[0]-snap_collar_length+10, spin=internal_screw_rotation, anchor=TOP, orient=LEFT, $slop=carriage_slop);
                // remove a smidge on top for clearance
                tag("remove")
                position(BACK)
                cube([carriage_size[0], 0.15, overall_thickness+1], anchor=BACK);
                
                // version number
                tag("remove")
                position(TOP+LEFT)
                fwd(2.5)
                right(0.2)
                text3d(version_string, h=0.5, size=5, anchor=TOP+LEFT);
            }
            
        }
        children();
    }
}

make_carriage(){
// position("collar-center")
// make_screw(orient=LEFT, spin=-90, anchor="collar-center");
}
