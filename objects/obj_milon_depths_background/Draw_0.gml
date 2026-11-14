// Fusion layer 1 uses zero scrolling coefficients on both axes.
var _camera = camera_get_active();
if (_camera != -1) {
    var _stage = instance_find(obj_milon, 0);
    var _left = _stage == noone ? camera_get_view_x(_camera) : _stage.page_left;
    var _top = _stage == noone ? camera_get_view_y(_camera) : _stage.page_top;
    draw_sprite(sprite_index, 0, _left, _top);
}
