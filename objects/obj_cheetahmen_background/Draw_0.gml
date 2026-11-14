var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}

var _stage = instance_find(obj_cheetahmen, 0);
var _left = _stage == noone ? camera_get_view_x(_camera) : _stage.page_left;
var _top = _stage == noone ? camera_get_view_y(_camera) : _stage.page_top;
draw_sprite(spr_cheetahmen_background, 0, _left, _top);
draw_sprite_ext(spr_cheetahmen_distant_terrain, 0, _left, _top - 80,
    1, 1, 0, c_white, 0.64843750);

for (var _row = 0; _row < 213; ++_row) {
    var _source_x = cloud_rows[_row][0];
    var _width = cloud_rows[_row][1];
    var _offset = ((639 - _width) div 2) + floor(-cloud_scroll * _width / 150);
    var _dest_x = _offset - ceil(_offset / _width) * _width;
    while (_dest_x < 639) {
        var _clip_left = max(0, -_dest_x);
        var _clip_right = min(_width, 639 - _dest_x);
        draw_sprite_part(spr_cheetahmen_clouds, 0, _source_x + _clip_left, _row,
            _clip_right - _clip_left, 1, _left + _dest_x + _clip_left, _top + _row);
        _dest_x += _width;
    }
}
