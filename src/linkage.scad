include <../openscad-library-manager/BOSL2/std.scad>

$fn=30;
module linkage_arm(
    spec,
    anchor=CENTER, spin=0, orient=UP) {
    hole_to_hole_dist = struct_val(spec, "length");
    id = struct_val(spec, "hole diam");
    od = struct_val(spec, "joint diam");
    width = struct_val(spec, "width");
    thickness = struct_val(spec, "thickness");
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
