// The Fusion OR ink effect keeps the stronger color bits of both layers.
gpu_set_blendmode(bm_max);
draw_self();
gpu_set_blendmode(bm_normal);
