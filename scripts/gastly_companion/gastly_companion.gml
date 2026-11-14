function gastly_companion_step(_player) {
    var _progress = game_current_progress();
    var _companion = instance_find(obj_gastly_companion, 0);
    var _call_pressed = keyboard_check_pressed(vk_f9) && !game_key_is_bound(global.settings.keys, vk_f9);
    if (_call_pressed && (_companion == noone || _companion.ball_age >= 40)) {
        _progress.gastly_dismissed = !_progress.gastly_dismissed;
        global.profile.dirty = true;
        game_profile_save();
        if (_progress.gastly_dismissed && _companion != noone) {
            instance_destroy(_companion);
            exit;
        }
    }

    if (!_progress.gastly_dismissed && _companion == noone) {
        instance_create_depth(_player.x - 1, _player.y - 16, _player.depth - 1, obj_gastly_companion);
    }
}
