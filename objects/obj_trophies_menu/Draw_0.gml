var _scroll_y = max(0, marker_y - 240);
var _cloud_y = floor(_scroll_y * 0.4);
var _cloud_height = min(480, sprite_get_height(spr_options_background) - _cloud_y);
if (_cloud_height > 0) {
    draw_sprite_part_ext(spr_options_background, 0, 192, _cloud_y, 640, _cloud_height,
        0, 0, 1, 1, c_white, 94 / 255);
}

var _bob_row = round((marker_y - 171) / 49);
for (var _i = 0; _i < array_length(rows); ++_i) {
    var _top = 152 + 49 * _i - _scroll_y;
    if (_top <= -49 || _top >= 480) {
        continue;
    }

    var _row = rows[_i];
    draw_sprite(spr_trophy_row, 0, 224, _top);
    var _bob = _i == _bob_row ? round(sin(degtorad(age_steps * 10)) * 3) : 0;
    var _icon_offset = _i == 15 ? 1 : 0;
    draw_sprite(spr_trophy_icon, _row.unlocked ? 1 : 0, 231 + _icon_offset, _top + _icon_offset + _bob);

    var _line_count = array_length(_row.title_lines);
    var _text_y = _top + (44 - 12 * _line_count) div 2;
    for (var _line = 0; _line < _line_count; ++_line) {
        var _text = _row.title_lines[_line];
        draw_boshy_text(_text, 410 - string_length(_text) * 8, _text_y + 12 * _line);
    }

    _line_count = array_length(_row.description_lines);
    _text_y = _top + (44 - 12 * _line_count) div 2;
    for (var _line = 0; _line < _line_count; ++_line) {
        draw_boshy_text(_row.description_lines[_line], 420, _text_y + 12 * _line);
    }
}

draw_sprite(spr_options_marker, 0, 196, marker_y - _scroll_y);

// These sit on the stationary layer above the scrolling list.
draw_sprite_ext(spr_trophies_title, 0, round(317 - 174 * title_scale), round(66 - 50 * title_scale),
    title_scale, title_scale, 0, c_white, 1);
draw_boshy_text(statistics, 16, 156);
