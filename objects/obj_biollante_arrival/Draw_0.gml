var _camera = camera_get_active();
var _frame = sprite_get_number(spr_tutorial_portal_transition) - 1 - arrival_frame;
draw_sprite(spr_tutorial_portal_transition, _frame, camera_get_view_x(_camera), camera_get_view_y(_camera));
