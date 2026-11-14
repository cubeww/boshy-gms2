game_controller = instance_find(obj_game, 0);
bridge_released = false;
orbit_angle = 0;
orbit_center_x = x;
orbit_center_y = y;
teleport_age = -1;
teleport_angle = 90;
teleport_sounds = [];

display_shader = shader_is_compiled(shd_final_path_panorama);
if (display_shader) {
    display_size_uniform = shader_get_uniform(shd_final_path_panorama, "u_surface_size");
    display_blur_uniform = shader_get_uniform(shd_final_path_panorama, "u_blur");
    display_mosaic_uniform = shader_get_uniform(shd_final_path_panorama, "u_grid_size");
    display_mask_uniform = shader_get_uniform(shd_final_path_panorama, "u_mask_enabled");
    display_mask_trim_uniform = shader_get_uniform(shd_final_path_panorama, "u_mask_trim");
    display_mask_uv_uniform = shader_get_uniform(shd_final_path_panorama, "u_mask_uv");
    display_mask_stage = shader_get_sampler_index(shd_final_path_panorama, "s_mask");
}

teleport_mask_frame = function() {
    // Fusion advances the animation when the accumulator exceeds 100.
    return (teleport_age * 60 - 1) div 100;
};

finish_solgryn_exit = function(_from_portal) {
    // G901 and G907 both jump to storyboard handle 41, the Solgryn room.
    if (_from_portal) {
        global.run.solgryn_portal_arrival = true;
    }
    room_goto(rm_solgryn);
};

draw_final_path_scene = function(_surface, _dest_x, _dest_y, _dest_width, _dest_height) {
    if (!display_shader) {
        return false;
    }

    var _blur = teleport_age > 0 ? (teleport_age - 1) * 0.01 : 0;
    var _columns = teleport_age < 0 ? game_controller.teleport_mosaic_columns : 0;
    var _rows = teleport_age < 0 ? game_controller.teleport_mosaic_rows : 0;
    shader_set(shd_final_path_panorama);
    shader_set_uniform_f(display_size_uniform, game_controller.render_width, game_controller.render_height);
    shader_set_uniform_f(display_blur_uniform, dcos(teleport_angle) * _blur, dsin(teleport_angle) * _blur);
    shader_set_uniform_f(display_mosaic_uniform, _columns, _rows);
    shader_set_uniform_f(display_mask_uniform, teleport_age >= 0 ? 1 : 0);
    if (teleport_age >= 0) {
        var _sprite = spr_tutorial_portal_transition;
        var _frame = teleport_mask_frame();
        var _uv = sprite_get_uvs(_sprite, _frame);
        texture_set_stage(display_mask_stage, sprite_get_texture(_sprite, _frame));
        shader_set_uniform_f(display_mask_uv_uniform, _uv[0], _uv[1], _uv[2], _uv[3]);
        shader_set_uniform_f(display_mask_trim_uniform, _uv[4], _uv[5],
            _uv[6] * sprite_get_width(_sprite), _uv[7] * sprite_get_height(_sprite));
    }
    draw_surface_stretched(_surface, _dest_x, _dest_y, _dest_width, _dest_height);
    shader_reset();
    return true;
};
