// G775–779 rotate both sets. Active 41 resets to 90 degrees when its entire canvas enters the view.
image_angle = (image_angle + rotation_per_step) mod 360;
if (!activate_in_view) {
    exit;
}

var _camera = view_camera[0];
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _right = _left + camera_get_view_width(_camera);
var _bottom = _top + camera_get_view_height(_camera);
var _width = sprite_get_width(sprite_index);
var _height = image_index < 1 ? 81 : 79;
var _origin_y = _height - 8;
var _sin = dsin(image_angle);
var _cos = dcos(image_angle);
var _center_offset_y = _height / 2 - _origin_y;
var _center_x = x + _center_offset_y * _sin;
var _center_y = y + _center_offset_y * _cos;
var _half_width = (abs(_cos) * _width + abs(_sin) * _height) / 2;
var _half_height = (abs(_sin) * _width + abs(_cos) * _height) / 2;
var _in_view = _center_x - _half_width > _left && _center_x + _half_width < _right
    && _center_y - _half_height > _top && _center_y + _half_height < _bottom;
if (_in_view && !was_in_view) {
    image_angle = 90;
}
was_in_view = _in_view;
