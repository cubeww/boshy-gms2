if (instance_exists(dedede_wrong_effect)) {
    gpu_set_blendmode(bm_add);
    draw_sprite_ext(dedede_wrong_effect.sprite_index, dedede_wrong_effect.image_index,
        dedede_wrong_effect.x, dedede_wrong_effect.y, dedede_wrong_effect.image_xscale,
        dedede_wrong_effect.image_yscale, 0, c_white, 1);
    gpu_set_blendmode(bm_normal);
}

if (trophy_steps >= 0) {
    var _alpha = 1 - max(0, trophy_steps - 200) / 26;
    draw_sprite_ext(spr_tutorial_achievement_banner, 0, 434, 7, 1, 1, 0, c_white, _alpha);
    draw_sprite_ext(spr_trophy_icon, 1, 438, 12, 0.5, 0.5, 0, c_white, _alpha);
    draw_boshy_text(string_copy("Mastermind!", 1, trophy_steps), 458, 22, _alpha);
}
