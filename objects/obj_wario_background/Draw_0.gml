var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}

// Fusion scrolls the backdrop with the camera page before the viewport crops it for zoom.
var _stage = instance_find(obj_wario, 0);
var _left = _stage == noone ? camera_get_view_x(_camera) : _stage.page_left;
var _top = _stage == noone ? camera_get_view_y(_camera) : _stage.page_top;
draw_sprite(sprite_index, 0, _left - floor(_left * 0.1), _top);
