draw_sprite(spr_hello_kitty_vignette, 0, 0, 0);

var _scenery = instance_find(obj_hello_kitty_scenery, 0);
if (_scenery == noone || _scenery.combat_steps < 0 || _scenery.combat_steps >= 13) {
    exit;
}

var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}

var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _right = _left + camera_get_view_width(_camera);
var _bottom = _top + camera_get_view_height(_camera);
var _alpha = draw_get_alpha();
draw_set_alpha(1 - _scenery.combat_steps * 10 / 128);
draw_rectangle_color(_left, _top, _right, _bottom, c_white, c_white, c_white, c_white, false);
draw_set_alpha(_alpha);
