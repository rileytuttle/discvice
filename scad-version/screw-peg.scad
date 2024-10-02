include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <common-dims.scad>
include <BOSL2/screws.scad>

$fn=30;

base_thickness=2;
base_diam = 10;
thread_length = 1.75;
post_crown_height = 2.25;
post_split_width = 1.75;
shaft_length = overall_thickness - thread_length+0.5;
slot_width=1.25;
flat_move=3.5;
thread_rotate = 50;
screw_peg_thread_pitch=1.75/2;

// function my_thread_profile() =
//     [
//         each arc(n=n, d=big, cp=[-(big + small)/2, -small/2], start=270, angle=ball_arc/2),
//         each arc(n=n, d=small, cp=[0, -small/2], start=180, angle=-ball_arc),
//         each arc(n=n, d=big, cp=[(big + small)/2, -small/2], start=180, angle=ball_arc/2),
//     ];

function screw_peg_thread_profile() =
    [
        [-0.5, -1],
        [-0.4, -1],
        [-0.1, 0],
        [0.1, 0],
        [0.4, -1],
        [0.5, -1],
    ];


module screw_peg(anchor=CENTER, spin=0, orient=UP) {
    attachable(anchor=anchor, spin=spin, orient=orient, size=[base_diam, base_diam, post_crown_height+shaft_length+base_thickness+thread_length]) {
        down((post_crown_height+shaft_length+thread_length)/2)
        diff() {
            // base
            cyl(d=base_diam, l=base_thickness) {
                // threads
                position(TOP)
                // threaded_rod(d=screw_peg_thread_major, pitch=screw_peg_thread_pitch, l=thread_length, anchor=BOTTOM, spin=thread_rotate)
                generic_threaded_rod(d=screw_peg_thread_major, l=thread_length, anchor=BOTTOM, spin=thread_rotate, pitch=screw_peg_thread_pitch, profile=screw_peg_thread_profile())
                    // shaft
                    zrot(-thread_rotate)
                    position(TOP)
                    cyl(d=4.5, l=shaft_length, anchor=BOTTOM)
                        // crown
                        position(TOP)
                        cyl(d2=3, d1=6, l=post_crown_height, anchor=BOTTOM)
                            tag("remove")
                            position(TOP) {
                                cuboid([post_split_width, 10, (overall_thickness + post_crown_height - thread_length) * 0.7], anchor=TOP, rounding=post_split_width/2, edges=[BOTTOM+RIGHT, BOTTOM+LEFT]);
                            }
                tag("remove")
                position(BOTTOM)
                cube([slot_width, 20, slot_width], anchor=BOTTOM);
                tag("remove")
                position(FRONT)
                translate([0, flat_move, 0])
                cube([30, 30, 30], anchor=BACK);
            }
        }
        children();
    }
}

module screw_peg_pocket(major_d, pitch, anchor=CENTER, spin=0, orient=UP) {
    $slop=0;
    attachable(anchor=anchor, spin=spin, orient=orient) {
        cyl(d=joint_outer_diam+0.1, l=joint_thickness) {
            up(joint_thickness/2)
                generic_threaded_rod(d=screw_peg_thread_major, l=2, anchor=BOTTOM, spin=thread_rotate, pitch=screw_peg_thread_pitch, profile=screw_peg_thread_profile(), internal=true);
            cyl(d=4.75, l=overall_thickness+1);
        }
        children();
    }
}

module machine_screw_pocket(anchor=CENTER, spin=0, orient=UP, add_supports=false, overall_thickness=7)
{
    default_tag("remove")
    attachable(anchor=anchor, spin=spin, orient=orient) {
        // tag_scope("screw-pocket")
        // diff() {
            cyl(d=joint_outer_diam+0.1, l=joint_thickness+0.1) {
                screw_hole("M3x0.5", head="flat", thread=true, l=overall_thickness);
                position(TOP)
                cyl(d=3.5, l=1, anchor=BOTTOM);
            // }
            // if (add_supports) {
            //     zrot_copies(n=9)
            //     difference() {
            //         pie_slice(ang=7, r=joint_outer_diam/2, l=joint_thickness+0.1, anchor=CENTER);
            //         cyl(d=3.5, l=carriage_size[2]);
            //     }
            // }
        }
        children();
    }
}

// stroke(screw_peg_thread_profile(), width =0.01);
// screw_peg();
// screw_peg_pocket();
machine_screw_pocket();
