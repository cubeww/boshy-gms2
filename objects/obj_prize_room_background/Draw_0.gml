var _stage = inst_prize_room_stage;
var _left = _stage.page_left;
if (scroll_period == 0) {
    draw_sprite(sprite_index, 0, _left + x, y);
    exit;
}

// These clouds scroll independently of the room and retain their authored offsets on a page change.
var _drift = (_stage.stage_steps * scroll_speed) mod scroll_period;
var _x = _left + x - _drift;
if (additive) {
    gpu_set_blendmode(bm_add);
}
draw_sprite(sprite_index, 0, _x - scroll_period, y);
draw_sprite(sprite_index, 0, _x, y);
draw_sprite(sprite_index, 0, _x + scroll_period, y);
if (additive) {
    gpu_set_blendmode(bm_normal);
}
