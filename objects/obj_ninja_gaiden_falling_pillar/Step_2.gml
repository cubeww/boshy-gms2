var _player = instance_find(obj_player, 0);
if (_player != noone && _player.hsp > 3 && _player.probe_overlaps(_player.right_probe, id)) {
    // G900 limits only positive horizontal speed.
    _player.hsp = 3;
}
if (place_meeting(x, y, obj_player_backdrop) || ninja_pillar_flyer_overlaps(id)) {
    exit;
}
y += 3;
if (_player != noone) {
    // G901 uses the lower Superdown probe on the moved pillar.
    if (_player.probe_overlaps(superdown_probe, id)
        && !place_meeting(x, y, obj_player_backdrop) && !ninja_pillar_flyer_overlaps(id)) {
        _player.y += 3;
        _player.refresh_collision_probes();
    }
}
if (y >= room_height) {
    instance_destroy();
}
