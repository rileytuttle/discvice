include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <common-dims.scad>
use <logo.scad>

$fn=30;

function my_thread_profile() =
    [
        each arc(n=n, d=big, cp=[-(big + small)/2, -small/2], start=270, angle=ball_arc/2),
        each arc(n=n, d=small, cp=[0, -small/2], start=180, angle=-ball_arc),
        each arc(n=n, d=big, cp=[(big + small)/2, -small/2], start=180, angle=ball_arc/2),
    ];

module make_internal_threads(l, anchor=CENTER, spin=0, orient=UP) {
    generic_threaded_rod(d=outer_diam_threads, l=l, pitch=pitch, profile=my_thread_profile(), internal=true, spin=spin, anchor=anchor, orient=orient, left_handed=true);
}

module make_screw(anchor=CENTER, spin=0, orient=UP) {
    // when doing internal threads set the $slop factor to something so that we have a bit of space. look up slop factor for printer (maybe that exists)
    
    anchor_list = [
        named_anchor("collar-center", [0, 0, -screw_length/2 - snap_collar_length/2]),
        named_anchor("neck-center", [0, 0, -screw_length/2 - snap_collar_length - neck_length / 2]),
    ];
    attachable(anchor,spin, orient, size=[outer_diam_threads,outer_diam_threads, screw_length], anchors=anchor_list) {
        difference() {
            union() {
                generic_threaded_rod(d=outer_diam_threads, l=screw_length, pitch=pitch, profile=my_thread_profile(), spin=screw_rotation, left_handed=true)
                    // tip
                    position(TOP)
                    cyl(d=inner_diam_threads, l=screw_tip_length, rounding2=1.45, anchor=BOTTOM);
                
                // collar
                down(screw_length/2)
                cyl(d=snap_collar_diam, l=snap_collar_length, anchor=TOP)
                    // neck
                    position(BOTTOM)
                    // cyl(d=neck_diam, l=neck_length, anchor=TOP, rounding1=-0.4, rounding2=-1)
                    cyl(d=neck_diam, l=neck_length, anchor=TOP)
                        // knob
                        position(BOTTOM)
                        diff() {
                            cuboid(thumb_knob_size, anchor=TOP, rounding=1) {
                                position(BACK)
                                force_tag("remove")
                                back(0.01)
                                logo_negative(d=7.5, l=0.5, anchor=TOP, orient=BACK, $fn=50, spin=90);
                            }
                        }
            }
            fwd(flat_dist_from_center)
                cube([30, 10, 100], anchor=BACK);
        }
        children();
    }
}

// make_screw();
stroke(my_thread_profile(), width=0.1);
