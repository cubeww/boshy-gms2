game_controller = instance_find(obj_game, 0);
prehistorik_pickup_slot = -1;
trophy_title = "";
trophy_steps = -1;

show_trophy = function(_title) {
    trophy_title = _title;
    trophy_steps = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
};
