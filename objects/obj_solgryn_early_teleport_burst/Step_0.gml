++burst_steps;

// G761–762 rotate the marker and emit a splash while its 45/100 animation plays.
var _frame = (45 * burst_steps - 1) div 100;
if (_frame >= image_number) {
    instance_destroy();
    exit;
}
image_index = _frame;
image_angle = (image_angle + 15) mod 360;
solgryn_early_teleport_burst_splash();
