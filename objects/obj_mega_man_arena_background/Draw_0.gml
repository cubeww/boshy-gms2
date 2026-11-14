// Fusion layer 1 stays fixed when the camera shakes.
var _camera = camera_get_active();
if (_camera != -1) {
    draw_sprite(sprite_index, 0, x + camera_get_view_x(_camera), y + camera_get_view_y(_camera));
}
