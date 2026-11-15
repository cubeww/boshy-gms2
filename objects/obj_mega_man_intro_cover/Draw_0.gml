with (obj_mega_man) {
    if (intro_cover > 0) {
        var _previous_alpha = draw_get_alpha();
        draw_set_alpha(intro_cover / 128);
        draw_rectangle_color(0, 0, 639, 479, c_white, c_white, c_white, c_white, false);
        draw_set_alpha(_previous_alpha);
    }

    if (hit_points > 0) {
        var _width = floor(639 * hit_points / max_health);
        draw_rectangle_color(0, 0, _width, 9, c_white, c_white, c_white, c_white, false);
    }
    var _text_y = 14;
    if (show_boss_health) {
        var _health = string(hit_points) + " / " + string(max_health);
        draw_boshy_text(_health, 634 - string_length(_health) * 8, _text_y);
        _text_y += 12;
    }
    if (show_boss_timer) {
        var _time = string(game_controller.frame_seconds - timer_reset_second) + " seconds";
        draw_boshy_text(_time, 634 - string_length(_time) * 8, _text_y);
    }
    mega_man_victory_draw();
}
