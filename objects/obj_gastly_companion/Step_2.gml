var _player = instance_find(obj_player, 0);
if (_player == noone) {
    instance_destroy();
    exit;
}

if (ball_age < 40) {
    ++ball_age;
    ball_x = _player.x - 1;
    ball_y += ball_speed_y;
    ball_speed_y += 0.1;
    if (ball_age <= 20) {
        ball_angle += 30;
    }
    if (ball_age == 20) {
        ball_speed_y = -3;
        ball_angle = 45;
        x = ball_x;
        y = ball_y;
        audio_play_sound(snd_gastly_ball_open, 1, false);
    } else if (ball_age == 40) {
        audio_play_sound(snd_gastly_cry, 1, false);
    }
    if (ball_age < 20) {
        exit;
    }
}

++animation_age;
shot_cooldown = max(0, shot_cooldown - 1);
var _delta_x = _player.x - 24 * _player.facing - x;
var _delta_y = _player.y - 24 + dsin(current_time) * 16 - y;
x += sign(_delta_x) * min(abs(_delta_x), abs(_delta_x) * 0.05 + 1);
y += sign(_delta_y) * min(abs(_delta_y), abs(_delta_y) * 0.05 + 1);
facing = x <= _player.x ? 1 : -1;
sprite_angle = point_direction(_player.x, _player.y - 16, x, y) + 90;

if (!_player.input_locked && shot_cooldown == 0 && keyboard_check_pressed(global.settings.keys.shoot)) {
    var _direction = 0;
    if (facing < 0) {
        _direction = 180;
    }
    instance_create_depth(x, y, depth, obj_gastly_companion_shot, {direction: _direction});
    shot_cooldown = 60;
}
