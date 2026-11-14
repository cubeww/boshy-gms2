// Fusion groups 881–884 advance each strip before applying its own wrap threshold.
x += scroll_speed;
var _left = camera_anchored ? 0 : camera_get_view_x(view_camera[0]);
if (x <= _left + wrap_x) {
    x = 640;
}
