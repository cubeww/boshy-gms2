// Sweep the shot's path as gravity increases its vertical speed.
var _samples = max(1, ceil(max(abs(velocity_x), abs(velocity_y))));
var _dx = velocity_x / _samples;
var _dy = velocity_y / _samples;

repeat (_samples) {
    x += _dx;
    y += _dy;

    if (terrain_meeting(x, y)) {
        instance_destroy();
        exit;
    }

    var _player = instance_place(x, y, obj_player);
    if (_player != noone && !_player.input_locked) {
        _player.die();
        instance_destroy();
        exit;
    }
}

velocity_y += 0.25;
if (bbox_right < 0 || bbox_left >= room_width || bbox_top >= room_height) {
    instance_destroy();
}
