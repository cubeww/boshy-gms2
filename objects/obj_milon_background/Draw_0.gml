var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}

// Fusion's castle layer has X scroll coefficient 0.03 and Y coefficient 0.
// Crop the original page composition when the viewport zooms for a pickup.
var _stage = instance_find(obj_milon, 0);
var _left = _stage == noone ? camera_get_view_x(_camera) : _stage.page_left;
var _top = _stage == noone ? camera_get_view_y(_camera) : _stage.page_top;
draw_sprite(sprite_index, 0, _left - floor(_left * 0.03), _top);
