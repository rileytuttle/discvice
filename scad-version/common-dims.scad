
// material = "pla";
material = "petg";
static=true;


machine_screw = true;

// screw dims
ball_arc = 180;
small_ball_diam = 1;
big_ball_diam = small_ball_diam * 1.5;
pitch = small_ball_diam+big_ball_diam;
outer_diam_threads = 6.75;
inner_diam_threads = outer_diam_threads - (small_ball_diam+big_ball_diam);
// screw_tip_diam = inner_diam_threads;
screw_tip_diam = 4.75;
assert(screw_tip_diam >= inner_diam_threads);
echo("inner diam threads", inner_diam_threads);
// n = max(3,ceil(segs(ball_diam/2)*ball_arc/2/360));
n=10;
echo("n = ", n);
// cpy = ball_diam/2/pitch*cos(ball_arc/2);
// echo("y displacement", cpy);

big = big_ball_diam/pitch;
small = small_ball_diam/pitch;
snap_collar_length = 3;
screw_channel_len = 22;
screw_length = screw_channel_len - snap_collar_length;
neck_collar_len = 5;

snap_collar_diam = 6;
thumb_knob_size = [15,7.5, 10];
screw_tip_length = 3;

neck_diam = 4.75;
neck_length = neck_collar_len + 0.5;
assert(neck_diam < snap_collar_diam);
assert(snap_collar_diam > inner_diam_threads);

discvice_logo_diam = 15;

// linkage arm
linkage_arm_width = 5;
linkage_arm_hole_diam = machine_screw ? 3.5 : 4.75;
linkage_arm_length = static ? 13.5 : 15;
linkage_arm_length2 = 14;
linkage_arm_joint_diam = 8.5;


screw_peg_thread_major=7;

// screw flattening
// flat_dist_from_center = 1.92;
// flat_dist_from_center = 1.75;
flat_dist_from_center = 2.35;

// rotate screw so that it doesnt float
screw_rotation = 65;

joint_outer_diam = 10;
overall_thickness = 8;
joint_wall = 2.25;
joint_thickness = overall_thickness - joint_wall*2;
linkage_arm_thickness = overall_thickness-joint_wall*2 - 0.4;

// collar_fudge = 0.3;
collar_fudge=0.4;

carriage_slop = 0.32;

// need to make sure the neck and tip dont fall out of the flat
main_body_tip_hole_diam = screw_tip_diam+collar_fudge;
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

main_jaw_body_height = 20;
main_peg_displacement = [-7, -main_jaw_body_height, 0];

lower_jaw_joint_displacement = [1, -13, 0];

lever_arm_main_body_length = 15;

screw_channel_offset = 5;
main_jaw_neck_collar_center_displacement = [
    screw_channel_offset+screw_channel_len+neck_collar_len/2,
    -main_jaw_body_height+5,
    -overall_thickness/2 + flat_dist_from_center
];

carriage_size = [15, 10, 7];
carriage_collar_length = snap_collar_length + 0.1;
carriage_collar_center_displacement = [
    (carriage_size[0]-carriage_collar_length)/2,
    0,
    -carriage_size[2]/2 + flat_dist_from_center
];

carriage_screw_peg_center_displacement = [
    carriage_size[0]/2 - joint_outer_diam/2,
    -(carriage_size[1]/2 + 1 + joint_outer_diam/2),
    0
];

version_string = "V5.0";

carriage_joint_offset = 1;

right_side_main_body_len = static ? 22 : screw_channel_len+screw_channel_offset+neck_collar_len;
main_jaw_screw_peg_2_displacement = [right_side_main_body_len-joint_outer_diam/2, -(main_jaw_body_height+carriage_joint_offset+joint_outer_diam/2), 0];
lower_jaw_angle = -10;

socket_supports = false;
