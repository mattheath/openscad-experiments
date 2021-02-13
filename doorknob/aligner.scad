use <threadlib/threadlib.scad>

threadedAlignmentPlug();

$fn=360;

module threadedAlignmentPlug(h=10) {
    difference() {
        linear_extrude(height=h) {
            circle(d=13);
        }

        tap("M6", turns=h);
    }
}