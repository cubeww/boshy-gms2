if (!victory_hide_boss) {
    // Groups 766–771 alternate the normal and additive ink effects every two steps.
    var _flash = (hit_flash_age >= 2 && hit_flash_age < 4) || (hit_flash_age >= 6 && hit_flash_age < 8);
    if (_flash) {
        gpu_set_blendmode(bm_add);
    }
    draw_self();
    if (_flash) {
        gpu_set_blendmode(bm_normal);
    }
    if (easy_mode) {
        var _mouth = biollante_mouth();
        // Groups 772 and 983 offset the bow from the left-facing action point.
        var _bow_x = _mouth.x + 16;
        var _bow_y = _mouth.y - 16 * image_yscale;
        var _angle = -45 + dsin(scene_steps * 4) * 10;
        var _scale = 0.1 * image_xscale;
        draw_sprite_ext(spr_ryu_giant_bow, 0, _bow_x, _bow_y, _scale, _scale, _angle, c_white, 1);
    }
}
biollante_victory_draw();
