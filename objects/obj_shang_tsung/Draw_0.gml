if (victory_hide_boss) {
    exit;
}

var _invert = ((hit_flash_age >= 2 && hit_flash_age < 4) || (hit_flash_age >= 6 && hit_flash_age < 8))
    && shader_is_compiled(shd_boss_hit_invert);
if (_invert) {
    shader_set(shd_boss_hit_invert);
}
draw_self();
if (_invert) {
    shader_reset();
}

if (easy_mode) {
    // G830 follows the current action point and G1089 wobbles the 20% bow.
    var _point = shang_tsung_pose_action_point();
    var _angle = -boss_facing * 45 + dsin(scene_steps * 4) * 10;
    draw_sprite_ext(spr_ryu_giant_bow, 0, x + _point[0] + boss_facing * 8,
        y + _point[1] - 8 * image_yscale, 0.2, 0.2, _angle, c_white, 1);
}
