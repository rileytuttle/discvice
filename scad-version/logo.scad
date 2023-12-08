include <BOSL2/std.scad>

module d_positive(d, l, anchor=CENTER, spin=0, orient=UP) {
    r = d*0.825/2;
    box_height = r * sin(60)*2;
    box_move = r * cos(60);
    attachable(spin=spin, anchor=anchor, orient=orient, size=[r*2, r*2, l]) {
        difference() {
            cyl(r=r, l=l);
            left(box_move)
            cube([d/2 - box_move, box_height, l+1], anchor=RIGHT);
        }
        children();
    }
}

module logo_positive(d,l, anchor=CENTER, spin=0, orient=UP) {
    attachable(spin=spin, anchor=anchor, orient=orient, size=[d, d, l]) {
        difference() {
            cyl(d=d, l=l);
            d_positive(d=d, l=l+1);
        }
        children();
    }
}

right(20)
d_positive(d=10, l=2);
logo_positive(d=10, l=2);
