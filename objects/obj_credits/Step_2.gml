var _cloud = instance_find(obj_credits_cloud, 0);
var _probe = instance_find(obj_credits_rider_probe, 0);
var _player = instance_find(obj_player, 0);

// G855–859 carry a rider using the Active 13 mask from the previous event pass.
if (_player != noone) {
    with (_probe) {
        if (place_meeting(x, y, _cloud)) {
            ++_player.y;
        }
    }
}
++_cloud.y;
if (_player != noone) {
    _cloud.x = _player.x - 32;
}
if (_cloud.y > 1800) {
    ++_cloud.y;
    if (_player != noone) {
        ++_player.y;
    }
}

if (_player != noone) {
    _probe.x = _player.x;
    _probe.y = _player.y;
    _player.refresh_collision_probes();
    if (_player.boshy_mask_meeting(obj_credits_finish)) {
        // G1109 advances to the Prize Room when the player reaches Active 119.
        room_goto(rm_prize_room);
    }
} else {
    // G601 lowers both the channel volume and sample frequency after a death.
    with (obj_game) {
        fade_stage_music();
    }
}
