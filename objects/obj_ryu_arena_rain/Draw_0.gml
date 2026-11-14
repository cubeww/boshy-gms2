var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}

// Fusion anchors the rain to the 640 × 480 page before the viewport crops or shakes it.
var _page_center = camera_get_view_x(_camera) + camera_get_view_width(_camera) * 0.5;
var _left = floor(_page_center / 640) * 640 - rain_offset;
gpu_set_blendmode(bm_add);
for (var _row = 0; _row < 480; _row += 128) {
    for (var _column = 0; _column < 768; _column += 128) {
        draw_sprite(sprite_index, image_index, _left + _column, _row);
    }
}
gpu_set_blendmode(bm_normal);
