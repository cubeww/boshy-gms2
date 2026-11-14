if (battle_age >= 75 || capturing || caught) {
    draw_sprite(spr_gastly_hp_box, 0, 225, 164);
    gastly_draw_text("GASTLY", 226, 155);
    var _hp_green = make_color_rgb(48, 164, 71);
    draw_rectangle_color(246, 174, 245 + gastly_hp * 2, 175,
        _hp_green, _hp_green, _hp_green, _hp_green, false);
}
gastly_draw_text("BOSHY", 370, 233);
gastly_draw_text(string_copy(dialogue, 1, dialogue_letters), 228, 280);

var _camera = camera_get_active();
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _scale = camera_get_view_width(_camera) / 640;
var _transition_frame = transition_age div 5;
if (_transition_frame < sprite_get_number(spr_gastly_transition)) {
    draw_sprite_ext(spr_gastly_transition, _transition_frame, _left, _top, _scale, _scale, 0, c_white, 1);
}

if (reward_notice_age >= 0 && reward_notice_age < 227) {
    var _alpha = 1 - max(0, reward_notice_age - 200) / 26;
    draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434 * _scale, _top + 7 * _scale,
        _scale, _scale, 0, c_white, _alpha);
    draw_sprite_ext(spr_trophy_icon, 1, _left + 438 * _scale, _top + 12 * _scale,
        0.5 * _scale, 0.5 * _scale, 0, c_white, _alpha);
    draw_boshy_text(string_copy("I CHOOSE YOU!", 1, reward_notice_age), _left + 498 * _scale,
        _top + 22 * _scale, _alpha, _scale);
}
if (reward_notice_age >= 20 && reward_notice_age < 220) {
    draw_sprite_ext(spr_prehistorik_pickup_message, 0, _left + 5 * _scale, _top + 5 * _scale,
        _scale, _scale, 0, c_white, 1);
    draw_boshy_text("SECRET ITEM!\nGASTLY ACQUIRED!", _left + 106 * _scale, _top + 10 * _scale, 1, _scale);
}
