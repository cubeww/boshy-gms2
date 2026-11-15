var _player = instance_find(obj_player, 0);
if (trigger_finger_age >= 0 && ++trigger_finger_age >= 226) {
    trigger_finger_age = -1;
}
prehistorik_pickups_step(_player);
if (_player == noone || _player.dead) {
    chest_view_update(game_controller, noone, -1);
    game_controller.fade_stage_music();
    exit;
}

// G743–744 reposition the player in the active room.
if (!_player.input_locked) {
    for (var _i = 0; _i < array_length(room_warps); ++_i) {
        var _warp = room_warps[_i];
        if (_player.boshy_mask_meeting(_warp)) {
            _player.x = _warp.target_x;
            _player.y = _warp.target_y;
            break;
        }
    }

    // G768 uses direct storyboard handle 21, which maps to Castlevania.
    var _exit = inst_pokemon_puzzle_exit;
    if (_player.boshy_mask_meeting(_exit)) {
        game_travel_by_teleporter(rm_castlevania, _exit.target_x, _exit.target_y, false);
        exit;
    }
}

if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
    trigger_finger_age = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
}

update_view(_player);
