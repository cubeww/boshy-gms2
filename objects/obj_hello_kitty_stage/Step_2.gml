if (blur_strength > 0) {
    blur_strength *= 0.9;
    // At this radius the farthest tap rounds back to the source pixel.
    if (blur_strength < 0.05) {
        blur_strength = 0;
    }
    var _angle = irandom(359);
    var _radius = blur_strength * 0.01;
    game_controller.directional_blur_x = dcos(_angle) * _radius;
    game_controller.directional_blur_y = dsin(_angle) * _radius;
}

if (trophy_index < array_length(trophy_titles)) {
    if (trophy_steps == 0) {
        audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
        audio_play_sound(snd_tutorial_achievement_success, 1, false);
    }
    if (++trophy_steps >= 226) {
        ++trophy_index;
        trophy_steps = 0;
    }
}

var _player = instance_find(obj_player, 0);
if (_player == noone || _player.dead) {
    game_controller.fade_stage_music();
    exit;
}

// The source arena snaps to two 640-pixel screens and offsets the camera during attacks.
var _page_left = _player.x < 640 ? 0 : 640;
var _shake = instance_exists(boss) ? max(0, boss.shake_steps - 1) : 0;
var _offset_x = 0;
var _offset_y = 0;
if (_shake > 0) {
    _offset_x = irandom_range(-_shake, _shake - 1);
    _offset_y = irandom_range(-_shake, _shake - 1);
}
camera_set_view_pos(view_camera[0], _page_left + _offset_x, _offset_y);
