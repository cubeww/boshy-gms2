if (trigger_finger_age < 0) {
    exit;
}

var _camera = camera_get_active();
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _alpha = 1 - max(0, trigger_finger_age - 200) / 26;
draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434, _top + 7, 1, 1, 0, c_white, _alpha);
draw_sprite_ext(spr_tutorial_trigger_finger, 0, _left + 440, _top + 12, 1, 1, 0, c_white, _alpha);
draw_boshy_text(string_copy("TRIGGER FINGER!!", 1, trigger_finger_age), _left + 486, _top + 22, _alpha);
