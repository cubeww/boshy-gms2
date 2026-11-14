if (ball_age < 40) {
    var _frame = ball_age >= 20 ? 1 : 0;
    draw_sprite_ext(spr_gastly_companion_ball, _frame, ball_x, ball_y, 1, 1, ball_angle, c_white, 1);
    if (ball_age < 20) {
        exit;
    }
}

var _sprite = facing < 0 ? spr_gastly_companion_left : spr_gastly_companion;
var _scale = 1 + shot_cooldown * 0.01;
var _alpha = 1 - clamp((100 + dsin(current_time / 3) * 60) / 255, 0, 1);
var _tint = shot_cooldown > 30 ? c_yellow : c_white;
draw_sprite_ext(_sprite, (animation_age div 10) mod 2, x, y, _scale, _scale, sprite_angle, _tint, _alpha);
