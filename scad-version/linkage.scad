include <BOSL2/std.scad>
include <common-dims.scad>

$fn=30;

module linkage_arm(
    hole_to_hole_dist,
    id,
    od,
    thickness,
    width,
    anchor=CENTER, spin=0, orient=UP) {
    anchor_list=[
        named_anchor("left-hole", [-hole_to_hole_dist/2, 0, 0]),
        named_anchor("right-hole", [hole_to_hole_dist/2, 0, 0]),
    ];
    attachable(spin=spin, anchor=anchor, orient=orient, size=[hole_to_hole_dist+od, od, thickness], anchors=anchor_list) {
        union() {
            xcopies(n=2, spacing=hole_to_hole_dist)
            tube(id=id, od=od, l=thickness);
            cube([hole_to_hole_dist-id, width, thickness], anchor=CENTER);
        }
        children();
    }
}

linkage_arm(linkage_arm_length, linkage_arm_hole_diam, linkage_arm_joint_diam, linkage_arm_thickness, linkage_arm_width);
