gpu_set_blendmode(bm_add);
if (fading) {
    draw_sprite_ext(spr_biollante_beam_fade, max(0, fade_age - 1), x, y, 1, 1, image_angle, c_white, 1);
} else if (sprite_index == -1) {
    // Fusion group 785 keeps the Appear animation on a separate collision layer.
    draw_sprite_ext(spr_biollante_beam, appear_frame, x, y, 1, 1, image_angle, c_white, 1);
} else {
    draw_self();
}
gpu_set_blendmode(bm_normal);
