prehistorik_pickups_draw_hud();

var _camera = camera_get_active();
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _scale = camera_get_view_width(_camera) / 640;
if (trophy_steps >= 0) {
    var _alpha = 1 - max(0, trophy_steps - 200) / 26;
    draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434 * _scale, _top + 7 * _scale,
        _scale, _scale, 0, c_white, _alpha);
    draw_sprite_ext(spr_trophy_icon, 1, _left + 438 * _scale, _top + 12 * _scale,
        0.5 * _scale, 0.5 * _scale, 0, c_white, _alpha);
    var _title = string_copy(trophy_title, 1, trophy_steps);
    draw_boshy_text(_title, _left + 477 * _scale, _top + 22 * _scale, _alpha, _scale);
}

if (portal_steps >= 0) {
    draw_sprite_ext(spr_tutorial_portal_transition, portal_frame, _left, _top, _scale, _scale, 0, c_white, 1);
}
