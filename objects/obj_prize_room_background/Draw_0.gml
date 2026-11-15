if (additive) {
    gpu_set_blendmode(bm_add);
}
// The Viewport crop zooms the whole page after Fusion draws its scrolling-independent layer.
draw_sprite(sprite_index, 0, inst_prize_room_stage.page_left + x, y);
if (additive) {
    gpu_set_blendmode(bm_normal);
}
