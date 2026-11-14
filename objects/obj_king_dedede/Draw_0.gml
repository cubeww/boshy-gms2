if (dedede_show_puzzle) {
    king_dedede_attacks_draw();
}

if (!dedede_defeated || defeat_steps < 300) {
    var _flash = (hit_flash_steps >= 8 && hit_flash_steps <= 9) || (hit_flash_steps >= 4 && hit_flash_steps <= 5);
    var _invert = _flash && shader_is_compiled(shd_boss_hit_invert);
    if (_invert) {
        shader_set(shd_boss_hit_invert);
    }
    draw_self();
    if (_invert) {
        shader_reset();
    }
    exit;
}

if (instance_exists(knight)) {
    draw_sprite_ext(knight.sprite_index, knight.image_index, knight.x, knight.y,
        knight.image_xscale, knight.image_yscale, 0, c_white, 1);
}
if (instance_exists(cutscene_king)) {
    // Group 733 brings the King in front of Meta Knight during the slash.
    draw_sprite_ext(cutscene_king.sprite_index, cutscene_king.image_index, cutscene_king.x, cutscene_king.y,
        cutscene_king.image_xscale, cutscene_king.image_yscale, 0, c_white, 1);
}
if (instance_exists(hadoken)) {
    draw_sprite(hadoken.sprite_index, hadoken.image_index, hadoken.x, hadoken.y);
}
