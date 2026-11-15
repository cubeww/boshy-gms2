if (visible) {
    exit;
}

var _player = instance_find(obj_player, 0);
// G766–767 use the separate 24 by 26 pixel Active 21 contact probe.
if (_player != noone && collision_rectangle(_player.x - 11, _player.y - 23,
    _player.x + 12, _player.y + 2, id, true, false) != noone) {
    visible = true;
    audio_play_sound(snd_wario_ice_reveal, 1, false);
}
