if (!gauntlet_started) {
    exit;
}

var _text = string(gauntlet_remaining div 50);
var _length = string_length(_text);
var _digit_width = 32;
// The ink in a digit cell is two pixels left of the cell's center.
var _left = x - 304 - _length * _digit_width / 2 + 2;
var _top = y + 104;
for (var _i = 1; _i <= _length; ++_i) {
    var _digit = ord(string_char_at(_text, _i)) - ord("0");
    draw_sprite_part(spr_vvvvvv_gauntlet_digits, 0, _digit * _digit_width, 0, _digit_width, 46,
        _left, _top);
    _left += _digit_width;
}
