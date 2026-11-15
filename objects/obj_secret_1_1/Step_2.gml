if (trophy_steps >= 0 && ++trophy_steps >= 226) {
    trophy_steps = -1;
}

var _player = instance_find(obj_player, 0);
prehistorik_pickups_step(_player);
if (_player == noone || _player.dead) {
    game_controller.fade_stage_music();
    chest_view_update(game_controller, noone, -1);
    exit;
}

update_view(_player);
if (_player.input_locked) {
    exit;
}

if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
    show_trophy("TRIGGER FINGER!!");
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
}

// G882 enters the Teleporter Room without the timed departure animation.
if (_player.boshy_mask_meeting(inst_secret_1_1_exit)) {
    game_travel_by_teleporter(rm_teleporter, 320, 240, false);
}
