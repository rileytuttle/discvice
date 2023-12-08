include <BOSL2/std.scad>
include <BOSL2/threading.scad>

$fn=20;
pitch = 3;
ball_arc = 180;
big_ball_diam = 2;
small_ball_diam = 1;
outer_diam_threads = 7;
inner_diam_threads = outer_diam_threads - (small_ball_diam+big_ball_diam);
echo("inner diam threads", inner_diam_threads);
flat_length = 3.5;
move_box = sqrt((inner_diam_threads/2)^2-(flat_length/2)^2);
// n = max(3,ceil(segs(ball_diam/2)*ball_arc/2/360));
echo("n = ", n);
n=10;
// cpy = ball_diam/2/pitch*cos(ball_arc/2);
// echo("y displacement", cpy);

big = big_ball_diam/pitch;
small = small_ball_diam/pitch;
screw_length = 30;
// rotations for screw 1 is 1 rotation
rotate_screw=0; // [0: 0.1 :10]

function my_thread_profile() =
    [
        each arc(n=n, d=big, cp=[-(big + small)/2, -small/2], start=270, angle=ball_arc/2),
        each arc(n=n, d=small, cp=[0, -small/2], start=180, angle=-ball_arc),
        each arc(n=n, d=big, cp=[(big + small)/2, -small/2], start=180, angle=ball_arc/2),
    ];

module make_screw(anchor=CENTER, spin=0, orient=UP) {
    // when doing internal threads set the $slop factor to something so that we have a bit of space. look up slop factor for printer (maybe that exists)
    
    attachable(anchor,spin, orient, size=[outer_diam_threads,outer_diam_threads, screw_length]) {

        diff("half_thread")
        generic_threaded_rod(d=outer_diam_threads, l=screw_length, pitch=pitch, profile=my_thread_profile()){
            tag("half_thread") {
                position(CENTER)
                translate([0, -move_box, 0])
                    cube([outer_diam_threads, outer_diam_threads, 40], anchor=BACK);
            }
        }
        children();
    }
}

$slop=0.2;
module make_test_internal_threads(anchor=CENTER, spin=0, orient=UP) {
    attachable(anchor, spin, orient, size=[outer_diam_threads, outer_diam_threads, screw_length]) {
        render(convexity=2) diff("threads flat")
        cube([outer_diam_threads+5, outer_diam_threads+5, screw_length], anchor=CENTER) {
            tag("threads") {
                position(CENTER)
                generic_threaded_rod(d=outer_diam_threads, l=screw_length, pitch=pitch, profile=my_thread_profile(), internal=true, spin=180);
            }
            tag("flat") {
                position(CENTER)
                translate([0, -move_box, 0])
                    cube([outer_diam_threads+10, outer_diam_threads, 40], anchor=BACK);
            }
        }
        children();
    }
}

translate([0, 0, $t*pitch])
zrot($t*360)
make_screw();
make_test_internal_threads();
