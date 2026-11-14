if (additive) {
    gpu_set_blendmode(bm_add);
}
draw_self();
if (additive) {
    gpu_set_blendmode(bm_normal);
}
