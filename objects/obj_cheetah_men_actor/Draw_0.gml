if (!actor_active) {
    exit;
}

if (invert_colors && shader_is_compiled(shd_boss_hit_invert)) {
    shader_set(shd_boss_hit_invert);
    draw_self();
    shader_reset();
} else {
    draw_self();
}
