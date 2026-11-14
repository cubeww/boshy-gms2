// Layer 4 and Layer 5 are stationary relative to the viewport.
draw_sprite(spr_credits_vignette, 0, 0, page_top);
if (credits_age < 85) {
    draw_sprite_ext(spr_credits_entry_fade, 0, 0, page_top, 1, 1, 0, c_white, 1 - credits_age * 3 / 255);
}
