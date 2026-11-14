var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}

// Fusion layer 1 stays fixed to the viewport when the camera moves.
draw_sprite_stretched(sprite_index, 0, camera_get_view_x(_camera) + x, camera_get_view_y(_camera) + y,
    camera_get_view_width(_camera), camera_get_view_height(_camera));
