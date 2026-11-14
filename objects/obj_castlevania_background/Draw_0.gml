var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}

// The Fusion layer scrolls horizontally at 7 percent and holds its vertical position on each page.
var _stage = instance_find(obj_castlevania, 0);
var _left = _stage == noone ? camera_get_view_x(_camera) : _stage.page_left;
var _top = _stage == noone ? camera_get_view_y(_camera) : _stage.page_top;
draw_sprite(sprite_index, 0, x + _left - floor(_left * 0.07), y + _top);
