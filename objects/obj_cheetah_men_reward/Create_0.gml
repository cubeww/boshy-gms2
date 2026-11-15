image_speed = 0;
reward_taken = struct_exists(global.profile.character_unlocks, "Orc");
reward_dropping = false;
pickup_age = -1;
pickup_player = noone;
pickup_cue = -1;
paused_music = -1;
prehistorik_pickup_message_age = -1;
prehistorik_pickup_message = {
    top: 39, lines: ["CHARACTER UNLOCKED!!", "ORC"]
};

update_reward = function(_player, _fight_age, _game) {
    if (prehistorik_pickup_message_age >= 0 && ++prehistorik_pickup_message_age >= 300) {
        prehistorik_pickup_message_age = -1;
    }
    if (pickup_age >= 0) {
        // G592–600 freeze the player, zoom in, and resume control after the reveal.
        if (_player == noone) {
            if (instance_exists(pickup_player)) {
                prehistorik_chest_pose_step(pickup_player, -1);
            }
            pickup_age = -1;
            pickup_player = noone;
            return;
        }
        ++pickup_age;
        prehistorik_chest_pose_step(_player, pickup_age < 360 ? pickup_age : -1);
        switch (pickup_age) {
            case 100:
                image_index = 1;
                break;
            case 250:
                image_index = 2;
                prehistorik_pickup_message_age = 0;
                break;
            case 315:
                // G1294 writes the costume to the shared Unlockables profile.
                game_character_unlock("Orc");
                reward_taken = true;
                break;
            case 330:
                if (paused_music != -1 && audio_is_paused(paused_music)) {
                    audio_resume_sound(paused_music);
                }
                paused_music = -1;
                break;
            case 360:
                _player.visible = true;
                _player.input_locked = false;
                pickup_age = -1;
                pickup_player = noone;
                break;
        }
        return;
    }
    if (_player == noone || reward_taken || _fight_age < 6850) {
        return;
    }

    // G1244 drops the chest through the room at one pixel per step.
    reward_dropping = true;
    if (_fight_age <= 8000) {
        ++y;
    }
    if (_player.input_locked || !_player.boshy_mask_meeting(id)) {
        return;
    }

    pickup_age = 0;
    pickup_player = _player;
    prehistorik_chest_pose_step(_player, 0);
    _player.visible = false;
    _player.input_locked = true;
    _player.hsp = 0;
    _player.vsp = 0;
    var _track = _game.stage_music_instance;
    if (_track != -1 && audio_is_playing(_track)) {
        audio_pause_sound(_track);
        paused_music = _track;
    }
    pickup_cue = audio_play_sound(snd_prehistorik_pickup, 1, false);
};
