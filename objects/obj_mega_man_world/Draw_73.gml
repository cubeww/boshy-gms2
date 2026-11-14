var _camera = camera_get_active();
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _scale = camera_get_view_width(_camera) / 640;
if (portal_age >= 0) {
    draw_sprite_ext(spr_tutorial_portal_transition, portal_frame, _left, _top, _scale, _scale, 0, c_white, 1);
} else if (exit_notice_steps > 0) {
    var _x = _left + (320 - string_length(exit_notice) * 4) * _scale;
    draw_boshy_text(exit_notice, _x, _top + 26 * _scale, min(1, exit_notice_steps / 20), _scale);
}
