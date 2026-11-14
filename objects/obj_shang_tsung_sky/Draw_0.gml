// Fusion Layer 1 has zero scroll coefficients, so the same sky extends behind both pages.
var _camera = camera_get_active();
if (_camera != -1) {
    draw_sprite(sprite_index, 0, x + camera_get_view_x(_camera), y + camera_get_view_y(_camera));
}
