if (image_alpha <= 0) {
    exit;
}
gpu_set_blendmode(bm_add);
draw_self();
gpu_set_blendmode(bm_normal);
