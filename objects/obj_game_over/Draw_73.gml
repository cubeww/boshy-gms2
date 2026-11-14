var _camera = camera_get_active();
var _left = _camera == -1 ? 0 : camera_get_view_x(_camera);
var _top = _camera == -1 ? 0 : camera_get_view_y(_camera);
var _view_scale = _camera == -1 ? 1 : camera_get_view_width(_camera) / 640;
var _center_x = _left + 320 * _view_scale;
var _center_y = _top + 240 * _view_scale;
var _scale = overlay_scale * _view_scale;
if (room == rm_shang_tsung) {
    // G663–669 pulse the frame-specific defeat title.
    draw_sprite_ext(spr_shang_tsung_death_title, 0, _center_x + _view_scale,
        _center_y, _scale, _scale, 0, c_white, 1);
    exit;
}
if (elapsed_steps < 25) {
    exit;
}

var _alpha = min(1, (elapsed_steps - 24) * 15 / 255);

var _restart = global.settings.keys.restart;
if (_restart == ord("R")) {
    draw_sprite_ext(spr_game_over, 0, _center_x, _center_y, _scale, _scale, 0, c_white, _alpha);
    exit;
}

// Keep the original heading and replace the baked restart instruction.
var _panel_left = _center_x - 240 * _scale;
var _panel_top = _center_y - 90 * _scale;
draw_sprite_part_ext(spr_game_over, 0, 80, 150, 470, 76, _panel_left, _panel_top,
    _scale, _scale, c_white, _alpha);
draw_set_alpha(_alpha);
draw_set_color(c_black);
draw_rectangle(_panel_left, _panel_top + 76 * _scale,
    _panel_left + 470 * _scale - 1, _panel_top + 122 * _scale - 1, false);
draw_set_alpha(1);
draw_set_color(c_white);

var _hint = "Press " + game_key_name(_restart) + " to restart";
var _hint_scale = 2 * _scale;
draw_boshy_text(_hint, _panel_left + 235 * _scale - string_length(_hint) * 4 * _hint_scale,
    _panel_top + 87 * _scale, _alpha, _hint_scale);
