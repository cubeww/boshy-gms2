ending_age = 0;
explosion_audio = [];
explosion_clock = 0;
blur_strength = 10;
flash_ink = 0;
game_controller = instance_find(obj_game, 0);
dark_cloud_rows = solgryn_parallax_rows(spr_solgryn_arena_cloud_lower);
blue_cloud_rows = solgryn_ending_cloud_rows();

play_explosion = function(_sound) {
    // The cue can repeat during the explosion, so discard handles that have already finished.
    for (var _i = array_length(explosion_audio) - 1; _i >= 0; --_i) {
        if (!audio_is_playing(explosion_audio[_i])) {
            array_delete(explosion_audio, _i, 1);
        }
    }
    array_push(explosion_audio, audio_play_sound(_sound, 1, false));
};
