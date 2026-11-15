prehistorik_pickups_draw_hud();
if (trophy_steps < 0) {
    exit;
}

chest_draw_overlay(function(_view) {
    var _left = _view.left;
    var _top = _view.top;
    var _scale = _view.scale_x;
    var _alpha = 1 - max(0, trophy_steps - 200) / 26;
    draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434 * _scale, _top + 7 * _scale,
        _scale, _scale, 0, c_white, _alpha);
    draw_sprite_ext(spr_trophy_icon, 1, _left + 438 * _scale, _top + 12 * _scale,
        0.5 * _scale, 0.5 * _scale, 0, c_white, _alpha);
    var _lines = string_split(trophy_title, "\n");
    var _letters = trophy_steps;
    for (var _line = 0; _line < array_length(_lines) && _letters > 0; ++_line) {
        var _text = _lines[_line];
        var _length = string_length(_text);
        draw_boshy_text(string_copy(_text, 1, _letters), _left + (628 - _length * 8) * _scale,
            _top + (17 + 12 * _line) * _scale, _alpha, _scale);
        _letters -= _length;
    }
});
