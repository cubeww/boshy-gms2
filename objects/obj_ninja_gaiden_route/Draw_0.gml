if (boss_exit_age < 0 && portal == noone) {
    exit;
}

var _camera = camera_get_active();
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _scale_x = camera_get_view_width(_camera) / 640;
var _scale_y = camera_get_view_height(_camera) / 480;
if (boss_exit_age >= 0) {
    // The departure grid fades in at the viewport origin.
    draw_sprite_ext(spr_ninja_gaiden_boss_exit_grid, 0, _left, _top, _scale_x, _scale_y,
        0, c_white, min(1, boss_exit_age / 64));
} else {
    var _frame = min(floor(portal_age * 0.6), sprite_get_number(spr_tutorial_portal_transition) - 1);
    draw_sprite_ext(spr_tutorial_portal_transition, _frame, _left, _top, _scale_x, _scale_y, 0, c_white, 1);
}
