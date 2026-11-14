// G858 removes stars at the edges of the current window plus a 16-pixel margin.
var _camera = view_camera[0];
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
if (bbox_left <= _left - 16 || bbox_right + 1 >= _left + camera_get_view_width(_camera) + 16
    || bbox_top <= _top - 16 || bbox_bottom + 1 >= _top + camera_get_view_height(_camera) + 16) {
    instance_destroy();
    exit;
}

// G883–884 hold fractional coordinates while exposing integer positions.
x = floor(motion_x);
y = floor(motion_y);
motion_x += lengthdir_x(travel_speed, image_angle);
motion_y += lengthdir_y(travel_speed, image_angle);
