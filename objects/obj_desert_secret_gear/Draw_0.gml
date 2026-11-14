var _camera = camera_get_active();
var _scale = camera_get_view_width(_camera) / 640;
draw_sprite_ext(sprite_index, image_index, camera_get_view_x(_camera) + x * _scale,
    camera_get_view_y(_camera) + screen_y * _scale, _scale, _scale, image_angle, c_white, 1);
