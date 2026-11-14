var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}
var _x = camera_get_view_x(_camera);
var _y = camera_get_view_y(_camera);
var _width = camera_get_view_width(_camera);
var _height = camera_get_view_height(_camera);
draw_sprite_stretched(sprite_index, image_index, _x, _y, _width, _height);

// Fusion's scroll-independent layer adds Active 61 over the fixed backdrop.
gpu_set_blendmode(bm_add);
draw_sprite_stretched(spr_vvvvvv_background_overlay, (max(0, background_steps - 1) div 2) mod 8,
    _x, _y, _width, _height);
gpu_set_blendmode(bm_normal);
