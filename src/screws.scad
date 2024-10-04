include <../openscad-library-manager/BOSL2/std.scad>
include <../openscad-library-manager/BOSL2/screws.scad>

$fn=50;

module machine_screw_pocket(
    joint_spec,
    screw_spec,
    anchor=CENTER, spin=0, orient=UP)
{
    joint_outer_diam = struct_val(joint_spec, "outer_diam");
    joint_thickness = struct_val(joint_spec, "thickness");
    overall_thickness = struct_val(screw_spec, "length");
    screw_type = struct_val(screw_spec, "type");
    screw_head = struct_val(screw_spec, "head");
    attachable(size=[joint_outer_diam, joint_outer_diam, overall_thickness], anchor=anchor, spin=spin, orient=orient) {
            cyl(d=joint_outer_diam+0.1, l=joint_thickness+0.1) {
                screw_hole(screw_type, head=screw_head, thread=true, l=overall_thickness+0.1);
                position(TOP)
                cyl(d=3.5, l=1, anchor=BOTTOM);
        }
        children();
    }
}
