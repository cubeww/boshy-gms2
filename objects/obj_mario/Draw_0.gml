for (var _i = 0; _i < array_length(mario_trails); ++_i) {
    var _trail = mario_trails[_i];
    // Fusion sets semi-transparency to 40, then adds 10 on every step, including creation.
    var _alpha = 1 - (50 + (scene_steps - _trail.birth) * 10) / 128;
    if (_alpha > 0) {
        draw_sprite_ext(_trail.sprite, _trail.frame, round(_trail.x), round(_trail.y),
            _trail.scale, _trail.scale, _trail.angle, c_white, _alpha);
    }
}
if (!defeated) {
    var _invert = (hit_flash_age >= 2 && hit_flash_age < 4) || (hit_flash_age >= 6 && hit_flash_age < 8);
    _invert = _invert && shader_is_compiled(shd_boss_hit_invert);
    if (_invert) {
        shader_set(shd_boss_hit_invert);
    }
    draw_sprite_ext(sprite_index, image_index, round(x), round(y), image_xscale, image_yscale, image_angle, c_white, 1);
    if (_invert) {
        shader_reset();
    }
    if (easy_mode) {
        var _bow_x = round(x - facing * 8);
        var _bow_y = round(y - image_yscale * 8);
        var _bow_angle = facing * 45 + dsin(scene_steps * 4) * 10;
        draw_sprite_ext(spr_ryu_giant_bow, 0, _bow_x, _bow_y, 0.1 * image_xscale,
            0.1 * image_yscale, _bow_angle, c_white, 1);
    }
} else if (victory_age < 150) {
    draw_sprite_ext(spr_mario_transition, 0, round(x), round(y), image_xscale, image_yscale, 0, c_white, 1);
}

mario_projectiles_draw();
if (defeated) {
    mario_victory_draw();
}
