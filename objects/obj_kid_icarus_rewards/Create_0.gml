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
    if (_player != noone && prehistorik_pickup_slot >= 0) {
        // G597 holds the player under the chest during the reveal.
        _player.visible = true;
        _player.pose = PlayerPose.Idle;
        _player.pose_frame = 0;
    }

    if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
        show_trophy("TRIGGER FINGER!!");
    }
    if (_player == noone || _player.dead || _player.input_locked) {
        return;
    }

    // G497 and G523 use separate, half-open player hotspot zones.
    if (_player.x >= 3532 && _player.x < 3730 && _player.y >= 6399 && _player.y < 6433
        && game_has_item("LIVE CD") && game_trophy_unlock("World9clear")) {
        show_trophy("World 9 CLEAR!");
    }
    if (_player.x >= 3384 && _player.x < 3423 && _player.y >= 6230 && _player.y < 6367
        && global.run.world_deaths <= 30 && game_trophy_unlock("World9PROMODE")) {
        show_trophy("World 9 PRO MODE!");
    }
};
