var _camera = view_camera[0];
var _stage = instance_find(obj_green_greens, 0);
var _left = _stage == noone ? camera_get_view_x(_camera) : _stage.view_base_x;
for (var _i = 0; _i < array_length(clouds); ++_i) {
    var _cloud = clouds[_i];
    _cloud.offset_x += _cloud.drift;
    var _screen_x = _cloud.offset_x - _left * _cloud.camera_factor;
    if (_screen_x <= -_cloud.left_margin) {
        _cloud.offset_x += _cloud.wrap_distance;
    } else if (_screen_x > 740) {
        _cloud.offset_x -= _cloud.wrap_distance;
    }
}
