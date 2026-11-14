var _camera = camera_get_active();
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _scale = camera_get_view_width(_camera) / 640;

if (arena_flash > 0) {
    draw_sprite_ext(spr_ryu_arena_reveal, 0, 1280, 0, 1, 1, 0, c_white, arena_flash);
}
if (fight_age >= 0 && !defeated) {
    var _bar_width = floor(639 * hit_points / max_health);
    draw_set_color(c_white);
    draw_rectangle(_left, _top, _left + _bar_width, _top + 9, false);

    var _status = "";
    if (show_boss_health) {
        _status = string(hit_points) + " / " + string(max_health);
    }
    if (show_boss_timer) {
        if (show_boss_health) {
            _status += "\n";
        }
        _status += string(attempt_steps div 50) + " seconds";
    }
    if (_status != "") {
        draw_boshy_text(_status, _left + 316, _top + 12);
    }
    var _remaining = dialogue_letters;
    var _wiggle = 0;
    if (dialogue_steps >= 2 && dialogue_steps < 15) {
        _wiggle = (15 - dialogue_steps) * ((dialogue_steps div 2) mod 2 == 0 ? -1 : 1);
    }
    for (var _i = 0; _i < array_length(dialogue_lines) && _remaining > 0; ++_i) {
        var _line = dialogue_lines[_i];
        var _length = string_length(_line);
        var _shown = min(_length, _remaining);
        draw_boshy_text(string_copy(_line, 1, _shown), x - 29 - _shown * 8, y - 32 + _i * 12 + _wiggle);
        _remaining -= _length + 1;
    }
}

if (trophy_index < array_length(trophy_titles)) {
    var _alpha = 1 - max(0, trophy_steps - 200) / 26;
    draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434 * _scale, _top + 7 * _scale,
        _scale, _scale, 0, c_white, _alpha);
    draw_sprite_ext(spr_trophy_icon, 1, _left + 438 * _scale, _top + 12 * _scale,
        0.5 * _scale, 0.5 * _scale, 0, c_white, _alpha);
    draw_boshy_text(string_copy(trophy_titles[trophy_index], 1, trophy_steps),
        _left + 458 * _scale, _top + 22 * _scale, _alpha, _scale);
}
prehistorik_pickups_draw_hud();
