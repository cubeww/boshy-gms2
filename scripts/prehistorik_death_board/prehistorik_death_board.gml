function prehistorik_death_board_draw(_left = 54, _top = 400) {
    var _deaths = global.run.world_deaths;
    var _label = string_format(_deaths, 0, 0);
    if (_deaths == 1) {
        _label += " DEATH";
    } else if (_deaths > 1) {
        _label += " DEATHS";
    }

    // Native Text Blitter margins (6, 16) inside the 96-pixel-wide board.
    var _length = string_length(_label);
    var _scale_x = min(1, 90 / (_length * 9));
    for (var _i = 0; _i < _length; ++_i) {
        var _glyph = ord(string_char_at(_label, _i + 1)) - 32;
        draw_sprite_part_ext(spr_prehistorik_death_board_font, 0, (_glyph mod 32) * 9, (_glyph div 32) * 16,
            9, 16, _left + _i * 9 * _scale_x, _top, _scale_x, 1, c_white, 1);
    }
}
