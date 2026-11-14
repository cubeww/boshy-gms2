gpu_set_blendmode(bm_add);
for (var _index = 0; _index < array_length(sparks); ++_index) {
    var _spark = sparks[_index];
    var _scale = max(0, _spark.scale);
    draw_sprite_ext(sprite_index, 0, _spark.draw_x, _spark.draw_y, _scale, _scale, 0, c_white, 1);
}
gpu_set_blendmode(bm_normal);
