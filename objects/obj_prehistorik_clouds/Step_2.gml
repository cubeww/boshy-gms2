for (var _i = 0; _i < array_length(background_elements); ++_i) {
    var _cloud = background_elements[_i];
    if (_cloud.drift == 0) {
        continue;
    }
    _cloud.offset_x += _cloud.drift;
    var _screen_x = _cloud.offset_x - page_left * _cloud.camera_factor;
    if (_screen_x <= -_cloud.left_margin) {
        _cloud.offset_x += _cloud.wrap_distance;
    } else if (_screen_x > 740) {
        _cloud.offset_x -= _cloud.wrap_distance;
    }
}
