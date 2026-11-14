++elapsed_steps;
notice_steps = max(0, notice_steps - 1);

if (!is_undefined(hidden_portrait)
    && string_ends_with(string_lower(keyboard_string), string_lower(hidden_portrait.entry.unlock_key))) {
    game_character_unlock(hidden_portrait.entry.unlock_key);
    hidden_portrait.status = game_character_status(hidden_portrait.entry);
    array_push(portraits, hidden_portrait);
    hidden_portrait = undefined;
}

hovered_slot = -1;
var _viewport = game_controller.get_viewport_rectangle();
if (!is_undefined(_viewport)) {
    // Match the application surface destination, including the fullscreen black bars.
    var _pointer_x = floor((window_mouse_get_x() - _viewport.left) * 640 / _viewport.width);
    var _pointer_y = floor((window_mouse_get_y() - _viewport.top) * 480 / _viewport.height);

    for (var _i = array_length(portraits) - 1; _i >= 0; --_i) {
        var _portrait = portraits[_i];
        var _left = _portrait.center_x - _portrait.half_width;
        var _top = _portrait.entry.y - _portrait.half_width;
        var _size = _portrait.half_width * 2;
        if (point_in_rectangle(_pointer_x, _pointer_y, _left, _top, _left + _size - 1, _top + _size - 1)) {
            hovered_slot = _i;
            break;
        }
    }

    if (mouse_check_button_pressed(mb_left) && !keyboard_check_pressed(vk_escape)) {
        if (hovered_slot >= 0) {
            var _portrait = portraits[hovered_slot];
            if (_portrait.status == "available") {
                selected_slot = hovered_slot;
                preview_character = game_character_definition(_portrait.entry.id);
                preview_frame = 0;
                spotlight_alpha = 0;
                notice_steps = 0;

                if (preview_sound != -1) {
                    audio_stop_sound(preview_sound);
                    preview_sound = -1;
                }
                var _cue = stock_character_select_sound(_portrait.entry.id);
                if (_cue == snd_tutorial_entrance) {
                    preview_sound = play_boshy_voice(_cue);
                } else if (_cue != noone) {
                    preview_sound = audio_play_sound(_cue, 1, false);
                }
            } else {
                notice = _portrait.status == "locked" ? "This character is locked." : "This character is unavailable.";
                notice_steps = 100;
            }
        } else if (point_in_rectangle(_pointer_x, _pointer_y, 250, 396, 390, 418)) {
            if (game_character_select(portraits[selected_slot].entry)) {
                game_return_from_menu();
                exit;
            }
        } else if (point_in_rectangle(_pointer_x, _pointer_y, 32, 192, 95, 223)
            || point_in_rectangle(_pointer_x, _pointer_y, 104, 192, 151, 223)
            || point_in_rectangle(_pointer_x, _pointer_y, 32, 225, 127, 247)) {
            notice = "Custom characters are unavailable.";
            notice_steps = 100;
        }
    }
}

for (var _i = 0; _i < array_length(portraits); ++_i) {
    var _portrait = portraits[_i];
    _portrait.scale = lerp(_portrait.scale, _i == hovered_slot ? 1.3 : 1, 0.2);
    if (_i != hovered_slot && _portrait.scale < 1.05) {
        _portrait.scale = 1;
    }
}

var _selected = portraits[selected_slot];
selection_x = lerp(selection_x, _selected.center_x, 0.25);
selection_y = lerp(selection_y, _selected.entry.y, 0.25);
selection_angle = (selection_angle + 5) mod 360;
spotlight_alpha = min(0.625, spotlight_alpha + 5 / 128);

var _idle = preview_character.poses[PlayerPose.Idle];
var _frame_count = array_length(_idle.frames);
preview_frame += _idle.rate;
if (preview_frame >= _frame_count) {
    if (_idle.loop) {
        var _loop_start = struct_exists(_idle, "loop_start") ? _idle.loop_start : 0;
        preview_frame = _loop_start + (preview_frame - _loop_start) mod (_frame_count - _loop_start);
    } else {
        preview_frame = _frame_count - 1;
    }
}
