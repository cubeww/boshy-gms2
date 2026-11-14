var _stage = instance_find(obj_kid_icarus, 0);
if (_stage == noone) {
    exit;
}

// Fusion Layer 1 stays fixed to the viewport and draws the moving strips additively.
if (scroll_speed != 0) {
    gpu_set_blendmode(bm_add);
}
draw_sprite(sprite_index, 0, _stage.page_left + x, _stage.page_top + y);
if (scroll_speed != 0) {
    gpu_set_blendmode(bm_normal);
}
