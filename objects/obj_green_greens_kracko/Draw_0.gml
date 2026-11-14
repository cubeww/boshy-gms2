var _additive = (hit_flash_age >= 2 && hit_flash_age <= 3) || (hit_flash_age >= 6 && hit_flash_age <= 7);
if (_additive) {
    gpu_set_blendmode(bm_add);
}
draw_self();
if (_additive) {
    gpu_set_blendmode(bm_normal);
}
draw_sprite_ext(spr_green_greens_kracko_eye, 0, x, y, 2, 2, eye_angle, c_white, 1);
if (giant_bow && hit_points > 0) {
    var _angle = -45 + dsin(animation_age * 4) * 10;
    draw_sprite_ext(spr_hello_kitty_giant_bow, 0, x + 64, y - 32, 0.5, 0.5, _angle, c_white, 1);
}
