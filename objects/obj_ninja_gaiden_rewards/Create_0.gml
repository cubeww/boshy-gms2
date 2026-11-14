game_controller = instance_find(obj_game, 0);
prehistorik_pickup_slot = -1;
prehistorik_pickup_age = 0;
prehistorik_pickup_cue = -1;
trophy_title = "";
trophy_steps = -1;

show_trophy = function(_title) {
    trophy_title = _title;
    trophy_steps = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
};

advance_rewards = function(_player) {
    if (trophy_steps >= 0 && ++trophy_steps >= 226) {
        trophy_steps = -1;
    }
    prehistorik_pickups_step(_player);
    if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
        show_trophy("TRIGGER FINGER!!");
    }
    if (_player == noone || _player.dead || _player.input_locked) {
        return;
    }
    // G498 and G524 each use their own half-open zone.
    if (_player.x >= 9515 && _player.x < 9549 && _player.y >= 997 && _player.y < 1225
        && game_has_item("Sax CD") && game_trophy_unlock("World10clear")) {
        show_trophy("World 10 CLEAR!");
    }
    if (_player.x >= 9420 && _player.x < 9451 && _player.y >= 1134 && _player.y < 1198
        && global.run.world_deaths <= 30 && game_trophy_unlock("World10PROMODE")) {
        show_trophy("World 10 PRO\nMODE!");
    }
};
