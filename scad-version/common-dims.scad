// screw dims

ball_arc = 180;
small_ball_diam = 1;
big_ball_diam = small_ball_diam * 1.5;
pitch = small_ball_diam+big_ball_diam;
outer_diam_threads = 7;
inner_diam_threads = outer_diam_threads - (small_ball_diam+big_ball_diam);
echo("inner diam threads", inner_diam_threads);
// n = max(3,ceil(segs(ball_diam/2)*ball_arc/2/360));
n=10;
echo("n = ", n);
// cpy = ball_diam/2/pitch*cos(ball_arc/2);
// echo("y displacement", cpy);

big = big_ball_diam/pitch;
small = small_ball_diam/pitch;
snap_collar_length = 3;
screw_length = 30 - snap_collar_length;

snap_collar_diam = 7.5;
thumb_knob_size = [15,7.5, 10];
screw_tip_length = 3;

neck_diam = 4.5;
neck_length = 10.5;


// linkage arm
linkage_arm_width = 5;
linkage_arm_thickness = 2.6;
linkage_arm_hole_diam = 4.75;
linkage_arm_joint_diam = 8.5;

// screw flattening
// flat_dist_from_center = 1.92;
// flat_dist_from_center = 1.75;
flat_dist_from_center = 2.2;

// rotate screw so that it doesnt float
screw_rotation = 65;

joint_outer_diam = 10;

overall_thickness = 7;

// collar_fudge = 0.3;
collar_fudge=0.3;

carriage_slop = 0.3;

// need to make sure the neck and tip dont fall out of the flat
main_body_tip_hole_diam = inner_diam_threads+collar_fudge;
main_body_tip_hole_r = main_body_tip_hole_diam/2;
main_body_collar_hole_diam = neck_diam+collar_fudge;
// tip calculations
tip_hole_chord_length = 2 * sqrt(main_body_tip_hole_r^2 - flat_dist_from_center^2);
tip_skinniest_dist = inner_diam_threads/2 + flat_dist_from_center;
if (tip_hole_chord_length < tip_skinniest_dist)
{
    echo(str("tip hole chord is small enough ", tip_hole_chord_length, " < ", tip_skinniest_dist));
}
else
{
    echo(str("tip hole chord is too big ", tip_hole_chord_length, " >= ", tip_skinniest_dist)); 
}

// neck calculations
main_body_collar_hole_r = main_body_collar_hole_diam/2;
neck_hole_chord_length = 2 * sqrt(main_body_collar_hole_r^2 - flat_dist_from_center^2);
neck_skinniest_dist = neck_diam/2 + flat_dist_from_center;
if (neck_hole_chord_length < neck_skinniest_dist)
{
    echo(str("neck hole chord is small enough ", neck_hole_chord_length, " < ", neck_skinniest_dist));
}
else
{
    echo(str("neck hole chord is too big ", neck_hole_chord_length, " >= ", neck_skinniest_dist)); 
}

// // thread calculations not including slip
// internal_thread_minor_diam = major_d

