// G821/G938/G941/G944 fire left, independently of the forced visual frame.
if (fire_steps >= fire_period) {
    var _offset = action_points[floor(image_index)];
    instance_create_layer(x + _offset[0], y + _offset[1], "Hazards", obj_ninja_gaiden_turret_shot);
    fire_steps = 0;
}

var _camera = view_camera[0];
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
// Fusion compares the full current subimage, before we pad the frames to one shared canvas.
var _bounds = source_bounds[floor(image_index)];
if (x + _bounds[0] > _left && x + _bounds[2] < _left + camera_get_view_width(_camera)
    && y + _bounds[1] > _top && y + 17 < _top + camera_get_view_height(_camera)) {
    ++fire_steps;
    // Fusion clamps a forced index to the end of the active six-frame clip.
    image_index = min(image_number - 1, floor(fire_steps / spin_per_step));
}
