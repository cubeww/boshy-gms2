if (!camera_anchored) {
    draw_self();
    exit;
}

var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}
var _scale_x = camera_get_view_width(_camera) / 640;
var _scale_y = camera_get_view_height(_camera) / 480;
draw_sprite_ext(sprite_index, 0, camera_get_view_x(_camera) + x * _scale_x,
    camera_get_view_y(_camera) + y * _scale_y, _scale_x, _scale_y, 0, image_blend, image_alpha);
