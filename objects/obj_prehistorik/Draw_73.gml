var _camera = camera_get_active();
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _scale = camera_get_view_width(_camera) / 640;

if (page_left == 0 && page_top == 0) {
    draw_boshy_text("Press F5 to view your TROPHIES!", 301, 390);
}
if (page_left == 3840 && page_top == 480) {
    draw_boshy_text("Sleeping, do not disturb...", 3842, 888);
}
prehistorik_pickups_draw_hud();

if (trophy_steps >= 0) {
    chest_draw_overlay(function(_view) {
        var _left = _view.left;
        var _top = _view.top;
        var _scale = _view.scale_x;
        var _alpha = 1 - max(0, trophy_steps - 200) / 26;
        draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434 * _scale, _top + 7 * _scale,
            _scale, _scale, 0, c_white, _alpha);
        draw_sprite_ext(spr_trophy_icon, 1, _left + 438 * _scale, _top + 12 * _scale,
            0.5 * _scale, 0.5 * _scale, 0, c_white, _alpha);
        var _text = string_copy(trophy_title, 1, trophy_steps);
        if (string_length(trophy_title) <= 22) {
            draw_boshy_text(_text, _left + 458 * _scale, _top + 22 * _scale, _alpha, _scale);
        } else {
            draw_boshy_text(string_copy(_text, 1, 22), _left + 458 * _scale, _top + 16 * _scale, _alpha, _scale);
            draw_boshy_text(string_copy(_text, 23, string_length(_text)), _left + 458 * _scale, _top + 28 * _scale,
                _alpha, _scale);
        }
    });
}

if (arrival_steps >= 0) {
    var _frame = sprite_get_number(spr_tutorial_portal_transition) - 1 - arrival_frame;
    draw_sprite_ext(spr_tutorial_portal_transition, _frame, _left, _top, _scale, _scale, 0, c_white, 1);
}
