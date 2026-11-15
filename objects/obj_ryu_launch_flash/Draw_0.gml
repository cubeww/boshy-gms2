var _invert = shader_is_compiled(shd_boss_hit_invert);
if (_invert) {
    shader_set(shd_boss_hit_invert);
}
draw_self();
if (_invert) {
    shader_reset();
}
