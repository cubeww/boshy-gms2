// CS_SinWave2 warps the source X coordinate as a function of source Y.
// The original beam is rotated 90 degrees, so its distortion moves vertical scanlines.
var _sprite = sprite_index;
var _frame = floor(image_index);
var _height = sprite_get_height(_sprite);
var _origin_x = sprite_get_xoffset(_sprite);
var _origin_y = sprite_get_yoffset(_sprite);
var _width = sprite_get_width(_sprite);
// G1190 evaluates its amplitude before advancing age. Fusion divides by zero as zero.
if (!fired || beam_age <= 1) {
    draw_self();
    exit;
}
var _phase = (beam_age - 1) * 0.06;
var _amplitude = 1 / (beam_age - 1);

// Clip each shifted one-pixel source row within its own frame on the texture page.
for (var _row = 0; _row < _height; ++_row) {
    var _wave = round(sin((_row / _height + _phase) * 5) * _width * _amplitude);
    var _left = max(0, _wave);
    var _right = min(_width, _width + _wave);
    if (_right > _left) {
        draw_sprite_general(_sprite, _frame, _left, _row, _right - _left, 1,
            x + (_row - _origin_y), y - (_left - _origin_x - _wave),
            1, 1, 90, c_white, c_white, c_white, c_white, image_alpha);
    }
}
