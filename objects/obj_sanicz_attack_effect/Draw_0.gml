if (sprite_index == spr_sanicz_explosion) {
    gpu_set_blendmode(bm_add);
    draw_self();
    gpu_set_blendmode(bm_normal);
} else {
    // The source's background layer has zero scroll coefficients on both axes.
    var _camera = view_camera[0];
    draw_sprite_ext(sprite_index, image_index, x + camera_get_view_x(_camera), y + camera_get_view_y(_camera),
        image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}
