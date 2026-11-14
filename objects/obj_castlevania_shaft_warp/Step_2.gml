var _player = instance_find(obj_player, 0);
if (_player == noone || _player.input_locked || sign(_player.hsp) != warp_direction) {
    exit;
}

// Groups 816–817 wrap across the shaft and shift the player one ledge vertically.
if (_player.boshy_mask_meeting(id)) {
    _player.x -= warp_direction * 362;
    _player.y += warp_direction * 100;
    _player.refresh_collision_probes();
}
