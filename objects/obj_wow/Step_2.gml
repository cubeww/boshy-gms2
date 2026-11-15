if (trigger_finger_age >= 0 && ++trigger_finger_age >= 226) {
    trigger_finger_age = -1;
}

var _player = instance_find(obj_player, 0);
inst_wow_login_account_144.update_account(_player);
inst_wow_login_progress_151.update_loading(_player);
if (_player != noone) {
    update_music(_player, 1);
}
wow_mulgore_hazards_step(_player);

_player = instance_find(obj_player, 0);
inst_wow_login_rift_162.check_rift(_player);
if (_player != noone) {
    update_music(_player, 2);
}
wow_stormwind_hazards_step(_player);

_player = instance_find(obj_player, 0);
inst_wow_quest.update_quest(_player);
_player = instance_find(obj_player, 0);
if (_player == noone) {
    game_controller.fade_stage_music();
    exit;
}

update_music(_player, 0);
update_view(_player);

// G484 unlocks the achievement for having five simultaneous shots.
if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
    trigger_finger_age = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
}
