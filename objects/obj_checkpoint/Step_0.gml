if (image_index == 0) {
    exit;
}

var _next_frame = image_index + 0.25;
if (_next_frame >= image_number) {
    image_index = 0;
    exit;
}
image_index = _next_frame;

// The original launches once upon reaching activation frame 5 (sprite frame 6).
if (_next_frame != 6) {
    exit;
}

var _player = instance_find(obj_player, 0);
if (_player == noone) {
    exit;
}

// Aim from the original top-left hotspot and spawn at its (7, 10) action point.
var _dx = x - 8 - _player.x;
var _dy = y - 8 - _player.y;
var _angle = darctan2(_dx, _dy) + (_dx > 0 ? 60 : 130);
instance_create_depth(x - 1, y + 2, _player.depth - 1, obj_checkpoint_bullet, {
    flight_direction: sign(_angle) * floor(abs(_angle)),
    flight_speed: 5
});
