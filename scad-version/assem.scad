include <BOSL2/std.scad>
use <tightening-screw.scad>
use <main-jaw.scad>
use <carriage.scad>
use <lever-arm.scad>
include <common-dims.scad>
use <screw-peg.scad>
use <lower-jaw.scad>
use <linkage.scad>

$fn=30;

main_jaw() {
    position("neck-collar")
    make_screw(anchor="neck-center", spin=-90, orient=LEFT)
        up(pitch*0.66)
        position("collar-center")
        make_carriage(anchor="collar-center", orient=BACK, spin=90);
    // position("screw-peg-center")
    // lower_jaw()
        // position("screw-peg-center")
        // rotate(25)
        // lever_arm(anchor="arm-hole-center");
            // position("screw-peg-center")
            // linkage_arm(anchor="left-hole", spin=-25);
}

// projection(cut=true)
// down(0.1)
// yrot(90)
// make_carriage() {
//     position("screw-center")
//     yrot(-90)
//     up(1.9)
//     make_screw(spin=-90);
// }
