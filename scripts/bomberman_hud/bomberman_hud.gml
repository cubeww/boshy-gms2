function bomberman_draw_hud() {
    var _camera = view_camera[0];
    var _left = camera_get_view_x(_camera);
    var _top = camera_get_view_y(_camera);
    var _fill = floor(639 * hit_points / max_health);
    if (_fill > 0) {
        draw_rectangle_color(_left, _top, _left + _fill - 1, _top + 8, c_white, c_white, c_white, c_white, false);
    }
    // The Layer 2 readouts shake with the arena. The Layer 4 counter stays fixed.
    var _text_top = 16;
    if (show_boss_health) {
        var _health = string(hit_points) + " / " + string(max_health);
        draw_boshy_text(_health, 632 - string_length(_health) * 8, _text_top);
        _text_top += 12;
    }
    if (show_boss_timer) {
        var _time = string(scene_steps div 50) + " seconds";
        draw_boshy_text(_time, 632 - string_length(_time) * 8, _text_top);
    }
    bomberman_victory_draw();

    if (arrival_age >= 0) {
        var _frames = sprite_get_number(spr_tutorial_portal_transition);
        var _frame = max(0, _frames - 1 - floor(arrival_age * 0.6));
        draw_sprite(spr_tutorial_portal_transition, _frame, _left, _top);
    }
}
