var _invert = ((enemy_flash >= 2 && enemy_flash < 4) || (enemy_flash >= 6 && enemy_flash < 8))
    && shader_is_compiled(shd_boss_hit_invert);
if (_invert) {
    shader_set(shd_boss_hit_invert);
}
draw_self();
if (_invert) {
    shader_reset();
}
