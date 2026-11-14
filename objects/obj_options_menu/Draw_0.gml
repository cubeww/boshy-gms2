var _rows = controls_open ? bindings : options;
var _marker_y = round(controls_open ? controls_marker_y : marker_y);
var _scroll_y = max(0, _marker_y - 240);

// The cloud layer moves at 30 percent of the Options camera speed.
draw_sprite_part_ext(spr_options_background, 0, 176, floor(_scroll_y * 0.3), 640, 480,
    0, 0, 1, 1, c_white, 94 / 255);
draw_sprite(spr_options_title, 0, 224, 16 - _scroll_y);

for (var _i = 0; _i < array_length(_rows); ++_i) {
    var _row = _rows[_i];
    var _top = _row.top - _scroll_y;
    if (_top <= -49 || _top >= 480) {
        continue;
    }

    draw_sprite(spr_options_button, 0, 266, _top);
    var _lines = string_count("\n", _row.label) + 1;
    var _label_x = _row.top >= 815 ? 277 : 278;
    draw_boshy_text(_row.label, _label_x, _top + (49 - 12 * _lines) div 2);

    var _value = "";
    if (struct_exists(_row, "setting")) {
        if (controls_open) {
            _value = capturing_key && _i == selected_row
                ? "Press a key"
                : game_key_name(struct_get(global.settings.keys, _row.setting));
        } else {
            var _setting = game_settings_option_value(_row.setting);
            _value = _row.limit == 1 ? (_setting ? "ON" : "OFF") : string(_setting) + "%";
        }
    } else if (_row.action == "display") {
        _value = window_get_fullscreen() ? "Fullscreen" : string(window_get_width()) + "x" + string(window_get_height());
    } else if (_row.action == "controls") {
        draw_boshy_text("Button 1: Jump\nButton 2: Shoot\nButton 3: Restart", 399, _top + 6);
    } else if (_row.action == "unavailable") {
        _value = _row.value;
    }

    var _value_x = !controls_open && _i >= 4 && _row.top < 815 ? 393 : 394;
    var _value_y = _top + 14;
    if (!controls_open) {
        if (_i >= 4 && _i <= 11 && _i != 9) {
            ++_value_y;
        } else if (_i == 15) {
            --_value_y;
        }
    }
    for (var _j = 1; _j <= string_length(_value); ++_j) {
        var _glyph = ord(string_char_at(_value, _j)) - 32;
        draw_sprite_part(spr_options_value_font, 0, (_glyph mod 32) * 15, (_glyph div 32) * 20,
            15, 20, _value_x + (_j - 1) * 15, _value_y);
    }
}

draw_sprite(spr_options_marker, 0, 245, _marker_y - _scroll_y);

var _help = controls_open ? "Press enter to change\nthe selected binding." : _rows[selected_row].help;
var _back = controls_open ? "Press [ESC] to return to \nOptions." : "Press [ESC] to return to \nthe game.";
if (!controls_open && game_menu_from_title()) {
    _back = "Press [ESC] to return to \nthe title screen.";
}
if (capturing_key) {
    _help = capture_hint;
    _back = "Press [ESC] to cancel.";
}

var _help_lines = string_split(_help, "\n");
for (var _i = 0; _i < array_length(_help_lines); ++_i) {
    var _line = _help_lines[_i];
    draw_boshy_text(_line, 224 - string_length(_line) * 8, 229 + _i * 12);
}

var _back_lines = string_split(_back, "\n");
for (var _i = 0; _i < array_length(_back_lines); ++_i) {
    var _line = _back_lines[_i];
    draw_boshy_text(_line, 326 - string_length(_line) * 4, 77 + _i * 12);
}
