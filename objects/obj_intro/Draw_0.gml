var _center_x = 320;
var _logo_y = 197;
var _logo_scale = 15;

if (elapsed_steps < 22) {
    // Fusion advances the intro counter by two each step and adds it to each letter's travel.
    var _travel = elapsed_steps * (elapsed_steps + 1);
    draw_sprite_ext(spr_intro_letter_j, 0, -100 + _travel, _logo_y, _logo_scale, _logo_scale, 0, c_white, 1);
    draw_sprite_ext(spr_intro_letter_a, 0, _center_x, -223 + _travel, _logo_scale, _logo_scale, 0, c_white, 1);
    draw_sprite_ext(spr_intro_letter_e, 0, 740 - _travel, _logo_y, _logo_scale, _logo_scale, 0, c_white, 1);
    exit;
}

var _alpha = 1 - clamp((elapsed_steps - 67) / 32, 0, 1);
draw_sprite_ext(spr_intro_jae, 0, _center_x + logo_offset_x, _logo_y + logo_offset_y,
    _logo_scale, _logo_scale, 0, c_white, _alpha);
draw_sprite_ext(spr_intro_solgryn, 0, _center_x, 333, 1, 1, 0, c_white, _alpha);
