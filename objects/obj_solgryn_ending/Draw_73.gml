if (ending_age >= 950) {
    exit;
}

// The rainbow sits above the fire. Draw the Layer 2 flash and final fade last.
if (ending_age >= 550) {
    var _rainbow_alpha = min(171, ending_age - 549) / 255;
    draw_sprite_ext(spr_solgryn_ending_rainbow, 0, 0, 0, 1, 1, 0, c_white, _rainbow_alpha);
}
if (flash_ink < 128) {
    draw_sprite_ext(spr_solgryn_ending_flash, 0, 0, 0, 1, 1, 0, c_white, 1 - flash_ink / 128);
}
if (ending_age >= 800) {
    var _fade_alpha = min(128, ending_age - 799) / 128;
    draw_sprite_ext(spr_solgryn_ending_fade, 0, 0, 0, 1, 1, 0, c_white, _fade_alpha);
}
