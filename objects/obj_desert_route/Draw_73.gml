var _camera = camera_get_active();
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _scale_x = camera_get_view_width(_camera) / 640;
var _scale_y = camera_get_view_height(_camera) / 480;
if (exit_door != noone) {
    // Source #3380 is a flat RGB (8, 0, 0) overlay whose transparency decreases by five each step.
    var _color = draw_get_color();
    var _alpha = draw_get_alpha();
    draw_set_color(make_color_rgb(8, 0, 0));
    draw_set_alpha(min(exit_age * 5 / 128, 1));
    draw_rectangle(_left, _top, _left + 640 * _scale_x, _top + 480 * _scale_y, false);
    draw_set_alpha(_alpha);
    draw_set_color(_color);
    exit;
} else if (hub != noone) {
    var _frame = min(floor(hub_age * 0.6), sprite_get_number(spr_tutorial_portal_transition) - 1);
    draw_sprite_ext(spr_tutorial_portal_transition, _frame, _left, _top, _scale_x, _scale_y, 0, c_white, 1);
}

prehistorik_pickups_draw_hud();
if (trophy_steps < 0) {
    exit;
}

chest_draw_overlay(function(_view) {
    var _left = _view.left;
    var _top = _view.top;
    var _scale_x = _view.scale_x;
    var _scale_y = _view.scale_y;
    var _alpha = 1 - max(0, trophy_steps - 200) / 26;
    var _bounce = 0;
    if (trophy_steps < 15) {
        var _beat = trophy_steps div 2;
        _bounce = (15 - 2 * _beat) * (_beat mod 2 == 0 ? -1 : 1);
    }
    draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434 * _scale_x, _top + 7 * _scale_y,
        _scale_x, _scale_y, 0, c_white, _alpha);
    draw_sprite_part_ext(spr_trophy_icon, 1, 0, 6, 32, 32, _left + 440 * _scale_x,
        _top + (13 + _bounce) * _scale_y, _scale_x, _scale_y, c_white, _alpha);
    var _lines = string_split(trophy_title, "\n");
    var _letters = trophy_steps;
    for (var _i = 0; _i < array_length(_lines) && _letters > 0; ++_i) {
        var _line = _lines[_i];
        var _length = string_length(_line);
        draw_boshy_text(string_copy(_line, 1, _letters), _left + (628 - _length * 8) * _scale_x,
            _top + (17 + _bounce + 12 * _i) * _scale_y, _alpha, _scale_x);
        _letters -= _length;
    }
});
