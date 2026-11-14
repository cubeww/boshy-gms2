// Fusion's effect advances three frames per ten game steps and plays once.
image_index = (++animation_age * 3) div 10;
if (image_index >= image_number) {
    instance_destroy();
    exit;
}
// The 50 ms timer rounds up to three Fusion ticks.
if (++drift_clock == 3) {
    drift_clock = 0;
    if (drift == 3) {
        ++y;
    } else {
        x += drift == 1 ? 1 : -1;
    }
    image_angle += drift == 1 ? 5 : -5;
}
