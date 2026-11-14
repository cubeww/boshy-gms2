function gastly_draw_text(_text, _left, _top) {
    var _x = _left;
    var _y = _top;
    for (var _i = 1; _i <= string_length(_text); ++_i) {
        var _character = string_char_at(_text, _i);
        if (_character == "\n") {
            _x = _left;
            _y += 8;
            continue;
        }
        var _glyph = ord(_character) - 32;
        if (_glyph >= 0 && _glyph < 96) {
            draw_sprite_part(spr_gastly_font, 0, (_glyph mod 32) * 8, (_glyph div 32) * 8, 8, 8, _x, _y);
        }
        _x += 8;
    }
}
