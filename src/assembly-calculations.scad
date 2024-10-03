//     This disc vice library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

//     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

include <rosetta-stone/std.scad>

// this is probably definitely a long stupid way of calculating but I don't feel like re-figuring it out/simplifying
// this part really makes me miss having a constraint solver from more traditional 3d modellers
function calculate_spins(
    lower_jaw_angle,
    lower_jaw_spec,
    joint_spec,
    carriage_spec,
    linkage_spec,
    lever_arm_spec) = 

    let (
        // local aliases
        joint_outer_diam = struct_val(joint_spec, "outer_diam"),
        carriage_joint_offset = struct_val(carriage_spec, "joint_offset"),
        lower_jaw_joint_displacement = struct_val(lower_jaw_spec, "joint_disp"),
        main_screw_disp = struct_val(main_body_spec, "screw1_disp"),
        main_body_right_side_len = struct_val(main_body_spec, "right_side_len"),
        main_body_height = struct_val(main_body_spec, "height"),
        abs_carriage_screw_disp = struct_val(main_body_spec, "screw2_disp"),
        print2 = echo(str("carriage joint displacement in abs coord", abs_carriage_screw_disp)),
        linkage_arm_length = struct_val(linkage_spec, "length"),
        lever_arm_main_body_length = struct_val(lever_arm_spec, "main body length"),
        // getting remapped screw joint displacements
        remapped_lower_jaw_joint_displacement = rotate_coords(lower_jaw_joint_displacement, lower_jaw_angle),
        abs_lower_jaw_joint_displacement = [
            main_screw_disp[0]+remapped_lower_jaw_joint_displacement[0],
            main_screw_disp[1]+remapped_lower_jaw_joint_displacement[1]],
        print1 = echo(str("lower jaw joint displacement in abs coord", abs_lower_jaw_joint_displacement)),
        angle_from_main_body_screw_to_lower_jaw_screw = angle_between_points2d(main_screw_disp, abs_lower_jaw_joint_displacement),
        print6=echo(str("angle between main peg and lower jaw peg", angle_from_main_body_screw_to_lower_jaw_screw)),
        main_jaw_screw_peg_2_displacement = [
            main_body_right_side_len-joint_outer_diam/2, -(main_body_height+carriage_joint_offset+joint_outer_diam/2), 0],
        dist_main_screw_to_carriage_screw = dist_between_points2d(main_screw_disp, abs_carriage_screw_disp),
        dist_main_screw_to_lower_jaw_screw = dist_between_points2d(main_screw_disp, abs_lower_jaw_joint_displacement),
        dist_lower_jaw_screw_to_carriage_screw = dist_between_points2d(abs_lower_jaw_joint_displacement, abs_carriage_screw_disp),
        theta1 = acos((dist_main_screw_to_carriage_screw^2 - dist_main_screw_to_lower_jaw_screw^2 - dist_lower_jaw_screw_to_carriage_screw^2) / (-2*dist_main_screw_to_lower_jaw_screw*dist_lower_jaw_screw_to_carriage_screw)),
        theta2 = acos((linkage_arm_length^2 - dist_lower_jaw_screw_to_carriage_screw^2 - lever_arm_main_body_length^2)/ (-2 * dist_lower_jaw_screw_to_carriage_screw * lever_arm_main_body_length)),
        print3=echo(str("theta1 " , theta1)),
        print4=echo(str("theta2 ", theta2)),
        print5=echo(str("relative angle ", theta1+theta2 - 90)),
        lever_arm_rotation = theta1+theta2-90-(90+angle_from_main_body_screw_to_lower_jaw_screw) +lower_jaw_angle,
        print7=echo(str("thing I want", lever_arm_rotation)),

        // starting calculation of linkage arm spin
        lever_arm_abs_angle = -lever_arm_rotation + lower_jaw_angle,
        remapped_lever_arm_joint_displacement = rotate_coords([lever_arm_main_body_length, 0], lever_arm_abs_angle),
        abs_lever_arm_joint_displacement = [
            abs_lower_jaw_joint_displacement[0] + remapped_lever_arm_joint_displacement[0],
            abs_lower_jaw_joint_displacement[1] + remapped_lever_arm_joint_displacement[1]
        ],
        print8=echo(str("lever arm joint displacement in abs coord", abs_lever_arm_joint_displacement)),
        abs_angle_of_linkage_arm = angle_between_points2d(abs_lever_arm_joint_displacement, abs_carriage_screw_disp),
        print9=echo(str("dist, angle between lever arm and carriage joints", dist_between_points2d(abs_carriage_screw_disp, abs_lever_arm_joint_displacement), ", ", abs_angle_of_linkage_arm)),
        print10=echo(str("angle of linkage arm relative to lever arm = ", lever_arm_abs_angle - abs_angle_of_linkage_arm))
    )
    [-lever_arm_rotation, -(lever_arm_abs_angle-abs_angle_of_linkage_arm)];
