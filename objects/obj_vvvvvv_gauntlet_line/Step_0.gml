if (flash_steps < 0) {
    exit;
}

var _frame = (++flash_steps * 35 - 1) div 100;
if (_frame >= sprite_get_number(spr_vvvvvv_gauntlet_line_flash)) {
    flash_steps = -1;
    sprite_index = spr_vvvvvv_gauntlet_line;
    image_index = 0;
} else {
    image_index = _frame;
}
