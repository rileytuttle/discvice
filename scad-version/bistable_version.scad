include <BOSL2/std.scad>
use <assem.scad>
use <main-jaw.scad>
use <lower-jaw.scad>

module bistable_shape2d() {
    difference() {
        right(100)
        mirror([1, 0, 0])
        projection()
        import("Bistable_Switch.STL", convexity=3);
        left(10)
        rect([45, 40], anchor=FRONT+LEFT);
    }
}

module main_jaw_shape() {
    difference() {
        intersection() {
            projection()
            mirror([0, 1, 0])
            main_jaw(static=true);
            left(12)
            rect([30, 40], anchor=FRONT+RIGHT);
        }
        back(17)
        left(7)
        rect([10, 10], anchor=FRONT+RIGHT);
    }
             
}

module lower_jaw_shape() {
    mirror([0, 1, 0])
    difference() {
        projection()
        lower_jaw();
        fwd(25)
        left(5)
        rect([20,50], anchor=FRONT+LEFT);
    }
}

linear_extrude(7) {
    difference() {
        union()
        {
            right(25)
            {
                right(20)
                main_jaw_shape();
                back(18)
                right(11.5)
                zrot(10)
                lower_jaw_shape();
            }
            bistable_shape2d();
            right(31)
            rect([7, 17], anchor=FRONT+LEFT);

            back(24)
            right(26.5)
            zrot(6)
            rect([15, 20], anchor=FRONT+LEFT);
        }
        back(34.5)
        right(40.75)
        left(0.27)
        back(0.02)
        zrot(-19)
        rect([40, 10], anchor=FRONT+RIGHT);
    }
}
