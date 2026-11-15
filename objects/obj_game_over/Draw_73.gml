if (!game_view_mirrored()) {
    var _camera = camera_get_active();
    var _left = _camera == -1 ? 0 : camera_get_view_x(_camera);
    var _top = _camera == -1 ? 0 : camera_get_view_y(_camera);
    var _scale = _camera == -1 ? 1 : camera_get_view_width(_camera) / 640;
    draw_death_panel(_left, _top, _scale);
}
