var _stage = instance_find(obj_ninja_gaiden, 0);
if (_stage != noone) {
    draw_sprite(sprite_index, 0, _stage.page_left + x, _stage.page_top + y);
}
