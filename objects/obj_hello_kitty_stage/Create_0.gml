game_controller = instance_find(obj_game, 0);
blur_strength = 0;
trophy_titles = [];
trophy_index = 0;
trophy_steps = 0;
new_record_sound = -1;
show_boss_health = game_has_item("Scouter");
show_boss_timer = game_has_item("Timer");

entrance_voice = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);

boss_defeated = function(_seconds) {
    var _progress = game_current_progress();
    if (_seconds < _progress.hello_kitty_best_time) {
        _progress.hello_kitty_best_time = _seconds;
        global.profile.dirty = true;
        new_record_sound = audio_play_sound(snd_hello_kitty_new_record, 1, false);
    }
    if (game_trophy_unlock("HelloKitty")) {
        array_push(trophy_titles, "Kawaii :3");
    }
    if (_seconds < 81 && game_trophy_unlock("HelloKittySpeed")) {
        array_push(trophy_titles, "Hello Kitty Speedrun!");
    }
    game_profile_save();
};

open_exit = function() {
    exit_controller.open_bridge();
};
