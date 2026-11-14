var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}

// Fill sky beyond the normal page when the chest camera centers near an edge.
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _width = camera_get_view_width(_camera);
var _height = camera_get_view_height(_camera);
if (_left < page_left || _top < page_top || _left + _width > page_left + 640 || _top + _height > page_top + 480) {
    draw_sprite_stretched(spr_prehistorik_sky, 0, _left, _top, _width, _height);
}

for (var _i = 0; _i < array_length(background_elements); ++_i) {
    var _element = background_elements[_i];
    var _screen_x = _element.offset_x - page_left * _element.camera_factor;
    gpu_set_blendmode(_element.additive ? bm_add : bm_normal);
    draw_sprite(_element.sprite, 0, page_left + round(_screen_x), page_top + _element.offset_y);
}
gpu_set_blendmode(bm_normal);
