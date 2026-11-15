var _player = instance_find(obj_player, 0);
if (_player != noone && _player.boshy_mask_meeting(id)) {
    audio_play_sound(snd_kid_icarus_coin, 1, false);
    instance_destroy();
}
