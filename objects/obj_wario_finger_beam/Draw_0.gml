if (sprite_index != -1) {
    gpu_set_blendmode(bm_add);
    draw_self();
    gpu_set_blendmode(bm_normal);
}
