module mount() {
    linear_extrude(height=5.5)
        difference() {
            circle(d=50);
            circle(d=13);
        }
}