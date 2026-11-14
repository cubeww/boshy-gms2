// G1110 stores this sound cue once per save slot.
var _progress = game_current_progress();
var _player = instance_find(obj_player, 0);
if (!_progress.mega_man_world_cue_played && _player != noone && _player.boshy_mask_meeting(id)) {
    _progress.mega_man_world_cue_played = true;
    global.profile.dirty = true;
    game_profile_save();
    audio_play_sound(snd_mega_man_world_voice_cue, 1, false);
    instance_destroy();
}
