//      This disc vice library is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This may not be used for commericial purposes without consulting the original writer.

//     This disc vice library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

//     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

include <../openscad-library-manager/BOSL2/std.scad>

$fn = 50;

module d_positive(d, l, anchor=CENTER, spin=0, orient=UP) {
    r = d*0.825/2;
    box_height = r * sin(60)*2;
    box_move = r * cos(60);
    attachable(spin=spin, anchor=anchor, orient=orient, size=[r*2, r*2, l]) {
        difference() {
            cyl(r=r, l=l, rounding=l/7, teardrop=true);
            left(box_move)
            cuboid([d/2 - box_move, box_height, l], anchor=RIGHT, rounding=-l*1.5/7, edges=[TOP+RIGHT, BOTTOM+RIGHT]);
        }
        children();
    }
}

module d_negative(d, l, anchor=CENTER, spin=0, orient=UP) {
    r = d*0.825/2;
    box_height = r * sin(60)*2;
    box_move = r * cos(60);
    attachable(spin=spin, anchor=anchor, orient=orient, size=[r*2, r*2, l]) {
        difference() {
            cyl(r=r, l=l, rounding=-l/7, teardrop=true);
            left(box_move)
            cuboid([d/2 - box_move, box_height, l], anchor=RIGHT, rounding=l*1.5/7, edges=[TOP+RIGHT, BOTTOM+RIGHT], teardrop=true);
        }
        children();
    }
}

module logo_negative(d,l, anchor=CENTER, spin=0, orient=UP) {
    attachable(spin=spin, anchor=anchor, orient=orient, size=[d, d, l]) {
        difference() {
            cyl(d=d, l=l);
            d_positive(d=d, l=l);
        }
        children();
    }
}

// right(20)
// d_negative(d=10, l=2);
// logo_positive(d=10, l=2);
