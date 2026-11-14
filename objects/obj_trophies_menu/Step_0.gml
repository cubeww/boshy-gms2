var _direction = keyboard_check(vk_down) - keyboard_check(vk_up);
var _advance = 0;
if (_direction != repeat_direction) {
    repeat_direction = _direction;
    held_steps = 0;
    _advance = _direction;
} else if (_direction != 0) {
    ++held_steps;
    if (held_steps >= 10 && (held_steps - 10) mod 4 == 0) {
        _advance = _direction;
    }
}

selected_row = clamp(selected_row + _advance, 0, array_length(rows) - 1);
marker_y = floor(lerp(marker_y, 171 + 49 * selected_row, 0.2) + 1);
title_scale = lerp(title_scale, 1, 0.2);
++age_steps;
