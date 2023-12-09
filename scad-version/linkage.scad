include <BOSL2/std.scad>
include <common-dims.scad>

$fn=30;

module linkage_arm(anchor=CENTER, spin=0, orient=UP) {
    anchor_list=[
        named_anchor("left-hole", [-linkage_arm_length/2, 0, 0]),
        named_anchor("right-hole", [linkage_arm_length/2, 0, 0]),
    ];
    attachable(spin=spin, anchor=anchor, orient=orient, size=[linkage_arm_length+linkage_arm_joint_diam, linkage_arm_joint_diam, linkage_arm_thickness], anchors=anchor_list) {
        union() {
            xcopies(n=2, spacing=linkage_arm_length)
            tube(id=linkage_arm_hole_diam, od=linkage_arm_joint_diam, l=linkage_arm_thickness);
            cube([linkage_arm_length-linkage_arm_hole_diam, linkage_arm_width, linkage_arm_thickness], anchor=CENTER);
        }
        children();
    }
}

linkage_arm();
