// UserChat 7 is part of the game layer. The white counter is fixed to the screen separately.
var _text_y = 10;
if (show_boss_health) {
    var _health = string(hit_points) + " / " + string(max_health);
    draw_boshy_text(_health, 640 - string_length(_health) * 8, _text_y);
    _text_y += 12;
}
if (show_boss_timer) {
    var _seconds = string(game_controller.frame_seconds) + " seconds";
    draw_boshy_text(_seconds, 640 - string_length(_seconds) * 8, _text_y);
}

if (sprite_index < 0) {
    exit;
}

// Groups 1221–1225 alternate subtractive and ordinary drawing.
var _flash = hit_flash_age == 2 || hit_flash_age == 3 || hit_flash_age == 6 || hit_flash_age == 7;
if (_flash) {
    gpu_set_blendmode(bm_subtract);
}
draw_self();
if (_flash) {
    gpu_set_blendmode(bm_normal);
}
