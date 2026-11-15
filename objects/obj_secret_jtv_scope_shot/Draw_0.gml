if (sprite_index != -1) {
    gpu_set_blendmode(bm_subtract);
    draw_self();
    gpu_set_blendmode(bm_normal);
}
