var _stage = instance_find(obj_desert, 0);
if (_stage == noone) {
    exit;
}

// The original foreground layer scrolls with world X and holds Y at the viewport.
var _page_left = _stage.page_left;
var _draw_x = x;
if (_draw_x < _page_left + left_limit || _draw_x > _page_left) {
    _draw_x = _page_left + 640 + right_offset;
}
draw_sprite(sprite_index, 0, _draw_x, _stage.page_top + y - 2);
