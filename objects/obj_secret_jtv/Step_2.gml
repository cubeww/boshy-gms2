var _player = instance_find(obj_player, 0);
var _pickup_age = -1;
if (_player == noone || _player.dead) {
    game_controller.fade_stage_music();
} else {
    var _pickups = inst_secret_jtv_pickups;
    _pickup_age = _pickups.prehistorik_pickup_slot >= 0 ? _pickups.prehistorik_pickup_age : -1;
    update_view(_player);
}

if (trigger_finger_age >= 0 && ++trigger_finger_age >= 226) {
    trigger_finger_age = -1;
}
if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
    trigger_finger_age = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
}

// G803 decrements the counter before choosing each offset. G635 only applies shake to the normal crop.
shake_steps = max(0, shake_steps - 1);
var _shaking = shake_steps > 0 && _pickup_age < 0;
game_controller.scene_shake_x = _shaking ? irandom_range(-shake_steps, shake_steps - 1) : 0;
game_controller.scene_shake_y = _shaking ? irandom_range(-shake_steps, shake_steps - 1) : 0;
