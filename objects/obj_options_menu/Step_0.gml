// The game controller owns these keys, including cancelling a key capture.
if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_f3)
    || keyboard_check_pressed(vk_f4) || keyboard_check_pressed(vk_f5)) {
    exit;
}

var _rows = controls_open ? bindings : options;
var _vertical = 0;
if (!capturing_key) {
    _vertical = read_direction(vk_up, vk_down, vertical_repeat, true);
    if (_vertical != 0) {
        selected_row = clamp(selected_row + _vertical, 0, array_length(_rows) - 1);
    }
}

if (controls_open) {
    controls_marker_y = lerp(controls_marker_y, bindings[selected_row].top + 23, 0.2);
} else {
    var _target_y = 145 + 49 * selected_row;
    marker_y = floor(lerp(marker_y, _target_y, 0.2) + 1);
}

if (capturing_key) {
    if (keyboard_check_pressed(vk_tab)) {
        capture_hint = "Tab opens the debug overlay.\nChoose another key.";
        exit;
    }
    var _key = keyboard_key;
    if (!game_settings_key_allowed(_key) || !keyboard_check_pressed(_key)) {
        exit;
    }

    var _selected_binding = bindings[selected_row].setting;
    for (var _i = 0; _i < array_length(bindings) - 1; ++_i) {
        var _binding = bindings[_i];
        if (_binding.setting != _selected_binding && struct_get(global.settings.keys, _binding.setting) == _key) {
            capture_hint = "Already bound to\n" + _binding.label + ".\nChoose another key.";
            exit;
        }
    }

    struct_set(global.settings.keys, _selected_binding, _key);
    game_settings_save();
    capturing_key = false;
    exit;
}

var _horizontal = read_direction(vk_left, vk_right, horizontal_repeat);

if (!controls_open && selected_row == speech_row) {
    if (++speech_preview_steps >= game_get_speed(gamespeed_fps) * 0.5) {
        speech_preview_steps = 0;
        if (speech_preview_instance != -1) {
            audio_stop_sound(speech_preview_instance);
        }
        var _pitch = (44000 + irandom(19999) - irandom(9999)) / 48000;
        speech_preview_instance = play_boshy_voice(snd_options_speech_preview, _pitch);
    }
} else {
    speech_preview_steps = 0;
    if (speech_preview_instance != -1) {
        audio_stop_sound(speech_preview_instance);
        speech_preview_instance = -1;
    }
}

if (_vertical != 0) {
    exit;
}

var _confirm = keyboard_check_pressed(vk_enter);
var _row = _rows[selected_row];
if (controls_open) {
    if (_confirm) {
        if (struct_exists(_row, "setting")) {
            capturing_key = true;
            capture_hint = "Press a key to bind. ESC cancels.";
        } else {
            handle_escape();
        }
    }
    exit;
}

if (struct_exists(_row, "setting")) {
    if (_horizontal == 0 && !_confirm) {
        exit;
    }

    var _current = game_settings_option_value(_row.setting);
    var _value = _row.limit == 1
        ? (_confirm ? !_current : _horizontal > 0)
        : clamp(_current + _horizontal, 0, _row.limit);

    if (_value != _current || is_undefined(struct_get(global.settings, _row.setting))) {
        struct_set(global.settings, _row.setting, _value);
        if (_row.setting == "music_volume") {
            game_controller.stage_music_volume = _value;
            var _track = game_controller.stage_music_instance;
            if (_track != -1 && (audio_is_playing(_track) || audio_is_paused(_track))) {
                audio_sound_gain(_track, _value / 100, 0);
            }
        } else if (_row.setting == "speech_volume" && speech_preview_instance != -1) {
            audio_sound_gain(speech_preview_instance, _value / 100, 0);
        }
        game_settings_save();
    }
    exit;
}

switch (_row.action) {
    case "frame_rate":
        // Fusion G456–457 write one change per held-key event. G367 applies it on entry.
        var _frame_rate = global.settings.frame_rate;
        if (keyboard_check(vk_left) && _frame_rate > 50) {
            --_frame_rate;
        }
        if (keyboard_check(vk_right) && _frame_rate < 1000) {
            ++_frame_rate;
        }
        if (_frame_rate != global.settings.frame_rate) {
            global.settings.frame_rate = _frame_rate;
            game_settings_save();
        }
        break;
    case "display":
        if (keyboard_check_pressed(vk_left)) {
            game_controller.cycle_display_mode(-1);
        } else if (_confirm || keyboard_check_pressed(vk_right)) {
            game_controller.cycle_display_mode();
        }
        break;
    case "controls":
        if (_confirm) {
            selected_row = 0;
            controls_marker_y = bindings[selected_row].top + 23;
            controls_open = true;
        }
        break;
}
