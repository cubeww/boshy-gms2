var _camera = camera_get_active();
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _scale = camera_get_view_width(_camera) / 640;
var _right = _left + 636 * _scale;
var _line_top = _top + 17 * _scale;

// G689–692 display the shared Timer and the original counter's values.
if (show_boss_health) {
    var _health = "0 / " + string(hud_max_health);
    draw_boshy_text(_health, _right - string_length(_health) * 8 * _scale, _line_top, 0.25, _scale);
    _line_top += 12 * _scale;
}
if (show_boss_timer) {
    var _clock = string(global.run.wow_timer_seconds) + " seconds";
    draw_boshy_text(_clock, _right - string_length(_clock) * 8 * _scale, _line_top, 0.25, _scale);
}

if (trigger_finger_age >= 0) {
    var _alpha = 1 - max(0, trigger_finger_age - 200) / 26;
    draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434 * _scale, _top + 7 * _scale,
        _scale, _scale, 0, c_white, _alpha);
    draw_sprite_ext(spr_tutorial_trigger_finger, 0, _left + 440 * _scale, _top + 12 * _scale,
        _scale, _scale, 0, c_white, _alpha);
    draw_boshy_text(string_copy("TRIGGER FINGER!!", 1, trigger_finger_age),
        _left + 486 * _scale, _top + 22 * _scale, _alpha, _scale);
}
