var _camera = camera_get_active();
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);

if (instance_exists(boss) && boss.hit_points > 0) {
    // Fusion's BossHealth counter is a 639 by 9 horizontal solid fill.
    var _bar_width = floor(639 * boss.hit_points / boss.max_health);
    draw_set_color(c_white);
    draw_rectangle(_left, _top, _left + _bar_width, _top + 9, false);

    var _status = "";
    if (show_boss_health) {
        _status = string(boss.hit_points) + " / " + string(boss.max_health);
    }
    if (show_boss_timer) {
        if (show_boss_health) {
            _status += "\n";
        }
        var _seconds = boss.attempt_start_second < 0 ? 0 : game_controller.frame_seconds - boss.attempt_start_second;
        _status += string(_seconds) + " seconds";
    }
    if (_status != "") {
        draw_boshy_text(_status, _left + 316, _top + 12);
    }
}

if (trophy_index < array_length(trophy_titles)) {
    var _alpha = 1 - max(0, trophy_steps - 200) / 26;
    draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434, _top + 7, 1, 1, 0, c_white, _alpha);
    draw_sprite_ext(spr_trophy_icon, 1, _left + 438, _top + 12, 0.5, 0.5, 0, c_white, _alpha);
    draw_boshy_text(string_copy(trophy_titles[trophy_index], 1, trophy_steps), _left + 458, _top + 22, _alpha);
}

