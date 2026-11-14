if (portal_age >= 0) {
    var _frame = min(floor(portal_age * 0.6), sprite_get_number(spr_tutorial_portal_transition) - 1);
    draw_sprite(spr_tutorial_portal_transition, _frame, view_left, view_top);
}
var _exit = instance_find(obj_final_path_exit, 0);
if (_exit != noone && _exit.teleport_age >= 0 && !_exit.display_shader) {
    var _camera = view_camera[0];
    draw_sprite(spr_tutorial_portal_transition, _exit.teleport_mask_frame(),
        camera_get_view_x(_camera), camera_get_view_y(_camera));
}
