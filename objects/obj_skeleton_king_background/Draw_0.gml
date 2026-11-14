var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}

var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
if (!brick_panorama_ready) {
    draw_sprite_tiled(sprite_index, 0, _left - 44 - brick_scroll, _top);
    exit;
}

shader_set(shd_skeleton_king_panorama);
shader_set_uniform_f(brick_bounds_uniform, brick_uvs[0], brick_uvs[1], brick_uvs[2], brick_uvs[3]);
shader_set_uniform_f(brick_scroll_uniform, brick_scroll);
draw_sprite_stretched(sprite_index, 0, _left, _top, camera_get_view_width(_camera), camera_get_view_height(_camera));
shader_reset();
