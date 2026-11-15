if (portal_age < 0) {
    exit;
}

var _camera = camera_get_active();
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _scale = camera_get_view_width(_camera) / 640;
draw_sprite_ext(spr_tutorial_portal_transition, portal_frame, _left, _top, _scale, _scale, 0, c_white, 1);
