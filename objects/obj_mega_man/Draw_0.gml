if (victory_age < 260) {
    var _invert = (hit_flash_age >= 2 && hit_flash_age < 4) || (hit_flash_age >= 6 && hit_flash_age < 8);
    _invert = _invert && shader_is_compiled(shd_boss_hit_invert);
    if (_invert) {
        shader_set(shd_boss_hit_invert);
    }
    draw_self();
    if (_invert) {
        shader_reset();
    }
    if (easy_mode) {
        var _bow_x = x - facing * 8 - (pose_animation == 3);
        var _bow_y = y - image_yscale * (pose_animation == 3 ? 8 : 9);
        var _bow_angle = facing * 45 + dsin(scene_steps * 4) * 10;
        draw_sprite_ext(spr_ryu_giant_bow, 0, _bow_x, _bow_y, image_xscale * 0.1,
            image_yscale * 0.1, _bow_angle, c_white, 1);
    }
}

if (mega_man_secondary_meter_visible()) {
    draw_sprite(spr_mega_man_secondary_meter, 0, 4, 50);
}
var _secondary_health = min(25, floor(clamp(mega_man_secondary_hp(), 0, 25) * 26 / 25));
draw_sprite(spr_mega_man_secondary_health, _secondary_health, 5, 51);
mega_man_victory_effects_draw();
