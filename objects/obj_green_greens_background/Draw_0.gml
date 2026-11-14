var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}

var _stage = instance_find(obj_green_greens, 0);
var _left = _stage == noone ? camera_get_view_x(_camera) : _stage.view_base_x;
var _top = _stage == noone ? camera_get_view_y(_camera) : _stage.view_base_y;
var _hills_x = _left - floor(_left * 0.025);
var _hills_y = _top - 48;
draw_sprite(spr_green_greens_hills, 0, _hills_x, _hills_y);

// The final blast can pan beyond the bottom of the parallax image.
var _hills_height = sprite_get_height(spr_green_greens_hills);
var _hills_bottom = _hills_y + _hills_height;
var _extra = camera_get_view_y(_camera) + camera_get_view_height(_camera) - _hills_bottom;
if (_extra > 0) {
    draw_sprite_part_ext(spr_green_greens_hills, 0, 0, _hills_height - 1,
        sprite_get_width(spr_green_greens_hills), 1, _hills_x, _hills_bottom,
        1, _extra, c_white, 1);
}

gpu_set_blendmode(bm_add);
for (var _i = 0; _i < array_length(clouds); ++_i) {
    var _cloud = clouds[_i];
    var _screen_x = _cloud.offset_x - _left * _cloud.camera_factor;
    draw_sprite(_cloud.sprite, 0, _left + floor(_screen_x), _top + _cloud.offset_y);
}
gpu_set_blendmode(bm_normal);
