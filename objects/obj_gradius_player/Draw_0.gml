if (!dead) {
    var _idle = character.poses[PlayerPose.Idle];
    var _frame = rider_frame;
    if (character.sprite_right != spr_boshy_right) {
        var _count = array_length(_idle.frames);
        _frame = floor(max(0, scene_steps - 1) * _idle.rate);
        if (_frame >= _count) {
            var _loop_start = struct_exists(_idle, "loop_start") ? _idle.loop_start : 0;
            _frame = _idle.loop ? _loop_start + (_frame - _loop_start) mod (_count - _loop_start) : _count - 1;
        }
    }
    draw_sprite(character.sprite_right, _idle.frames[_frame], x, y);
}
draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale,
    image_angle, image_blend, image_alpha);

for (var _i = 0; _i < array_length(options); ++_i) {
    var _option = options[_i];
    draw_sprite_ext(spr_gradius_option, _option.animation_steps div 10, _option.x, _option.y,
        2, 2, 0, c_white, 1);
}
