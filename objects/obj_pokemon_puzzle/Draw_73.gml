prehistorik_pickups_draw_hud();
if (trigger_finger_age >= 0) {
    chest_draw_overlay(function(_view) {
        var _left = _view.left;
        var _top = _view.top;
        var _scale = _view.scale_x;
        var _alpha = 1 - max(0, trigger_finger_age - 200) / 26;
        draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434 * _scale, _top + 7 * _scale,
            _scale, _scale, 0, c_white, _alpha);
        draw_sprite_ext(spr_tutorial_trigger_finger, 0, _left + 440 * _scale, _top + 12 * _scale,
            _scale, _scale, 0, c_white, _alpha);
        draw_boshy_text(string_copy("TRIGGER FINGER!!", 1, trigger_finger_age),
            _left + 486 * _scale, _top + 22 * _scale, _alpha, _scale);
    });
}
