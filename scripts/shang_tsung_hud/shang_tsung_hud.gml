function shang_tsung_draw_hud() {
    var _top = camera_get_view_y(view_camera[0]);
    draw_sprite(spr_shang_tsung_health_frame, 0, 467, _top + 5);
    var _fill = floor(166 * hit_points / max_health);
    if (_fill > 0) {
        draw_rectangle_color(634 - _fill, _top + 6, 633, _top + 13, c_blue, c_blue, c_blue, c_blue, false);
    }
    var _text_y = _top + 14;
    if (show_boss_health) {
        var _health = string(hit_points) + " / " + string(max_health);
        draw_boshy_text(_health, 635 - string_length(_health) * 8, _text_y);
        _text_y += 12;
    }
    if (show_boss_timer) {
        var _time = string(timer_base_seconds + game_controller.frame_seconds) + " seconds";
        draw_boshy_text(_time, 635 - string_length(_time) * 8, _text_y);
    }

    for (var _i = 0; _i < array_length(dialogue_lines); ++_i) {
        var _line = dialogue_lines[_i];
        var _remaining = _line.shown;
        for (var _j = 0; _j < array_length(_line.lines) && _remaining > 0; ++_j) {
            var _text = _line.lines[_j];
            var _length = string_length(_text);
            var _x = _line.x - _length * 8;
            var _y = _line.y + _line.bob + _j * 12;
            draw_boshy_text(string_copy(_text, 1, _remaining), _x, _y);
            _remaining -= _length + 1;
        }
    }
    shang_tsung_victory_draw();
}
