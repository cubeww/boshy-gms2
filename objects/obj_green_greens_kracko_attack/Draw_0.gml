if (attack_kind == GreenGreensKrackoAttack.Lightning) {
    gpu_set_blendmode(bm_add);
    draw_self();
    gpu_set_blendmode(bm_normal);
} else {
    draw_self();
}
