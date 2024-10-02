//      This frisbee vice library is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This may not be used for commericial purposes without consulting the original writer.

//     This frisbee vice library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

//     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

include <../openscad-library-manager/BOSL2/std.scad>
include <../openscad-library-manager/BOSL2/screws.scad>

$fn=50;

module machine_screw_pocket(
    joint_outer_diam,
    joint_thickness,
    overall_thickness,
    anchor=CENTER, spin=0, orient=UP)
{
    attachable(anchor=anchor, spin=spin, orient=orient) {
            cyl(d=joint_outer_diam+0.1, l=joint_thickness+0.1) {
                screw_hole("M3x0.5", head="flat", thread=true, l=overall_thickness);
                position(TOP)
                cyl(d=3.5, l=1, anchor=BOTTOM);
        }
        children();
    }
}
