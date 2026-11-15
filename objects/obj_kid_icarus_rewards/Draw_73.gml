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
    draw_boshy_text(string_copy(trophy_title, 1, trophy_steps), _left + 477 * _scale, _top + 22 * _scale, _alpha, _scale);
});
