if (!departure) {
    exit;
}

var _player = instance_find(obj_player, 0);
if (_player == noone) {
    exit;
}
if (departure_steps == 0) {
    if (_player.input_locked || !_player.boshy_mask_meeting(id)) {
        exit;
    }
    _player.input_locked = true;
}

// Groups 1046–1048 carry the player as the ship accelerates upward and tilts.
y = floor(y - departure_steps);
++departure_steps;
image_angle += 1;
++x;
_player.x = x;
_player.y = y;
if (departure_steps >= 45) {
    // Group 1047 targets storyboard handle 43, the Gradius midway frame.
    room_goto(rm_gradius);
    exit;
}
_player.refresh_collision_probes();
