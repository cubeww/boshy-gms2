if (!laser_broken) {
    draw_self();
}

// G1349–1351 copy the current frame once per step, then expand and fade each copy.
for (var _index = 0; _index < array_length(laser_trail); ++_index) {
    var _sample = laser_trail[_index];
    var _age = laser_steps - _sample.step;
    var _alpha = 1 - (65 + 15 * _age) / 255;
    if (_alpha > 0) {
        var _scale = 3.1 + 0.1 * _age;
        draw_sprite_ext(spr_solgryn_late_laser, _sample.frame, _sample.x, _sample.y,
            _scale, _scale, 0, c_white, _alpha);
    }
}
