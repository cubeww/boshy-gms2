if (trigger_finger_age < 0 && portal_steps < 0) {
    exit;
}

var _camera = camera_get_active();
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);

if (trigger_finger_age >= 0) {
    // The source holds for 200 steps before the banner fades over 26 steps.
    var _alpha = 1 - max(0, trigger_finger_age - 200) / 26;
    var _bounce = 0;
    if (trigger_finger_age >= 2 && trigger_finger_age < 15) {
        var _direction = (trigger_finger_age div 2) mod 2 == 1 ? 1 : -1;
        _bounce = (15 - trigger_finger_age) * _direction;
    }

    draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434, _top + 7, 1, 1, 0, c_white, _alpha);
    draw_sprite_ext(spr_tutorial_trigger_finger, 0, _left + 440, _top + 12 + _bounce, 1, 1, 0, c_white, _alpha);

    var _label = "TRIGGER FINGER!!";
    var _visible_letters = min(trigger_finger_age, string_length(_label));
    draw_boshy_text(string_copy(_label, 1, _visible_letters), _left + 486, _top + 22 + _bounce, _alpha);
}

if (portal_steps < 0) {
    exit;
}

draw_sprite(spr_tutorial_portal_transition, portal_frame, _left, _top);
