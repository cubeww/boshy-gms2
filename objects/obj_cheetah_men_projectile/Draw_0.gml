draw_self();
if (attack_kind == CheetahMenAttack.Bouncer) {
    // G1169 pairs the red rendition with the same position, clip and scale.
    var _alpha = clamp((attack_age * 2 - 745) / 255, 0, 1);
    if (_alpha > 0) {
        draw_sprite_ext(spr_cheetah_men_bouncer_flash, image_index,
            x, y, image_xscale, image_yscale, image_angle, c_white, _alpha);
    }
}
