// G895 reads the previous displacement when the Down probe touches the platform.
var _player = instance_find(obj_player, 0);
if (_player != noone && !_player.jumped_this_step && _player.probe_overlaps(_player.down_probe, id)) {
    _player.x += rider_delta_x;
    _player.air_jump_available = true;
    _player.refresh_collision_probes();
}

// G865 culls the platform at the left side of the arena.
if (x < 4500) {
    instance_destroy();
    exit;
}
x += travel_x;
rider_delta_x = travel_x;
