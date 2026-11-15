camera_set_view_pos(view_camera[0], -1, -2);

// G704 starts channel 2 only when the battle cue is not already playing.
var _music = -1;
if (struct_exists(global.run, "missingno_music_handoff")) {
    _music = global.run.missingno_music_handoff;
    struct_remove(global.run, "missingno_music_handoff");
}
if (_music != -1 && audio_is_playing(_music)) {
    game_controller.stage_music_instance = _music;
    game_controller.stage_music_can_resume = true;
    audio_sound_loop(_music, true);
} else {
    game_controller.start_stage_music(snd_ninja_gaiden_boss_exit_music);
}
