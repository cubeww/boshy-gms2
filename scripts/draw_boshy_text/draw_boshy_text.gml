function draw_boshy_text(_text, _left, _top, _alpha = 1, _scale = 1) {
    var _draw_x = _left;
    var _draw_y = _top;
    var _length = string_length(_text);

    // The original bitmap starts at ASCII 32 and uses 32 columns of 8 x 12 cells.
    for (var _i = 1; _i <= _length; ++_i) {
        var _character = string_char_at(_text, _i);
        if (_character == "\n") {
            _draw_x = _left;
            _draw_y += 12 * _scale;
            continue;
        }

        var _glyph = ord(_character) - 32;
        if (_glyph >= 0 && _glyph < 224) {
            draw_sprite_part_ext(spr_boshy_voice_font, 0, (_glyph mod 32) * 8, (_glyph div 32) * 12,
                8, 12, _draw_x, _draw_y, _scale, _scale, c_white, _alpha);
        }
        _draw_x += 8 * _scale;
    }
}
