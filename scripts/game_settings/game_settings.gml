function game_key_is_bound(_keys, _key) {
    return _keys.left == _key || _keys.right == _key || _keys.up == _key || _keys.down == _key
        || _keys.jump == _key || _keys.shoot == _key || _keys.restart == _key;
}

function game_settings_key_allowed(_key) {
    return is_numeric(_key) && _key >= 0 && _key <= 255 && _key == floor(_key)
        && _key != vk_nokey && _key != vk_anykey && _key != vk_escape
        && _key != vk_tab && _key != vk_f3 && _key != vk_f4 && _key != vk_f5;
}

function game_key_name(_key) {
    if ((_key >= ord("A") && _key <= ord("Z")) || (_key >= ord("0") && _key <= ord("9"))) {
        return chr(_key);
    }
    if (_key >= vk_f1 && _key <= vk_f12) {
        return "F" + string(_key - vk_f1 + 1);
    }
    if (_key >= vk_numpad0 && _key <= vk_numpad9) {
        return "Num " + string(_key - vk_numpad0);
    }

    switch (_key) {
        case vk_left: return "Left";
        case vk_right: return "Right";
        case vk_up: return "Up";
        case vk_down: return "Down";
        case vk_enter: return "Enter";
        case vk_escape: return "Esc";
        case vk_space: return "Space";
        case vk_shift: return "Shift";
        case vk_lshift: return "L Shift";
        case vk_rshift: return "R Shift";
        case vk_control: return "Ctrl";
        case vk_lcontrol: return "L Ctrl";
        case vk_rcontrol: return "R Ctrl";
        case vk_alt: return "Alt";
        case vk_lalt: return "L Alt";
        case vk_ralt: return "R Alt";
        case vk_backspace: return "Backspace";
        case vk_tab: return "Tab";
        case vk_home: return "Home";
        case vk_end: return "End";
        case vk_insert: return "Ins";
        case vk_delete: return "Del";
        case vk_pageup: return "PgUp";
        case vk_pagedown: return "PgDn";
        case vk_pause: return "Pause";
        case vk_printscreen: return "PrtSc";
        case vk_multiply: return "Num *";
        case vk_divide: return "Num /";
        case vk_add: return "Num +";
        case vk_subtract: return "Num -";
        case vk_decimal: return "Num .";
    }

    return "Key " + string(_key);
}

function game_settings_read_integer(_section, _key, _fallback) {
    var _value = string_trim(ini_read_string(_section, _key, ""));
    var _digits = string_char_at(_value, 1) == "-" ? string_delete(_value, 1, 1) : _value;
    if (_digits == "" || string_length(_digits) > 9 || string_digits(_digits) != _digits) {
        return _fallback;
    }

    return real(_value);
}

function game_settings_option_value(_setting) {
    var _value = struct_get(global.settings, _setting);
    if (_setting == "auto_fire" && is_undefined(_value)) {
        return game_campaign_difficulty() == 0;
    }
    return _value;
}

function game_view_mirrored() {
    // The original Viewport object is absent from these frames.
    return global.settings.mirror && room != rm_intro && room != rm_options && room != rm_trophies
        && room != rm_dresser && room != rm_final_path && room != rm_solgryn_ending && room != rm_credits;
}

function game_horizontal_key(_keys, _right, _reverse = false) {
    // Fusion's Control X swaps the bindings for the whole application.
    var _reverse_input = global.settings.mirror != _reverse;
    return _right != _reverse_input ? _keys.right : _keys.left;
}

function game_settings_load() {
    var _settings = {
        music_volume: 100,
        speech_volume: 100,
        special_jump_sounds: true,
        special_shoot_sounds: true,
        special_shot_graphics: true,
        character_walk_sound: true,
        blood_intensity: 50,
        mirror: false,
        restart_music: true,
        show_fps: false,
        show_deaths: false,
        auto_fire: undefined,
        low_input_latency: false,
        display_mode: 1,
        frame_rate: 50,
        keys: {
            left: vk_left,
            right: vk_right,
            up: vk_up,
            down: vk_down,
            jump: ord("Z"),
            shoot: ord("X"),
            restart: ord("R")
        }
    };

    if (!file_exists("iwbtb_settings.ini")) {
        return _settings;
    }

    ini_open("iwbtb_settings.ini");
    _settings.music_volume = clamp(game_settings_read_integer("Options", "MusicVolume", _settings.music_volume), 0, 100);
    _settings.speech_volume = clamp(game_settings_read_integer("Options", "SpeechVolume", _settings.speech_volume), 0, 100);
    _settings.special_jump_sounds = game_settings_read_integer("Options", "SpecialJumpingSounds", 1) != 0;
    _settings.special_shoot_sounds = game_settings_read_integer("Options", "SpecialShootingSounds", 1) != 0;
    _settings.special_shot_graphics = game_settings_read_integer("Options", "SpecialShotGraphics", 1) != 0;
    _settings.character_walk_sound = game_settings_read_integer("Options", "DigDugWalkSound", 1) != 0;
    _settings.blood_intensity = clamp(game_settings_read_integer("Options", "BloodIntensity", _settings.blood_intensity), 0, 200);
    _settings.mirror = game_settings_read_integer("Options", "Mirror", 0) == 1;
    _settings.restart_music = game_settings_read_integer("Options", "MusicRestart", 1) != 0;
    _settings.show_fps = game_settings_read_integer("Options", "FPS", 0) == 1;
    _settings.show_deaths = game_settings_read_integer("Options", "ShowDeaths", 0) == 1;
    var _auto_fire = game_settings_read_integer("Options", "AutoFire", -1);
    if (_auto_fire == 0 || _auto_fire == 1) {
        _settings.auto_fire = _auto_fire == 1;
    }
    _settings.low_input_latency = game_settings_read_integer("Options", "LowInputLatency", 0) == 1;
    var _display_mode = game_settings_read_integer("Options", "DisplayMode", _settings.display_mode);
    if (_display_mode >= 0 && _display_mode <= 3) {
        _settings.display_mode = _display_mode;
    }
    _settings.frame_rate = clamp(game_settings_read_integer("Options", "FrameRate", 50), 50, 1000);

    var _key_names = struct_get_names(_settings.keys);
    var _loaded_keys = {};
    var _assigned_keys = [];

    for (var _i = 0; _i < array_length(_key_names); ++_i) {
        var _name = _key_names[_i];
        if (!ini_key_exists("Controls", _name)) {
            continue;
        }
        var _key = game_settings_read_integer("Controls", _name, vk_nokey);
        if ((_key == vk_tab || _key == vk_f3 || _key == vk_f5)
            && !array_contains(_assigned_keys, _key)) {
            array_push(_assigned_keys, _key);
            continue;
        }
        if (!game_settings_key_allowed(_key) || array_contains(_assigned_keys, _key)) {
            // Keep the entire default map when a stored assignment is invalid or conflicts.
            ini_close();
            return _settings;
        }

        struct_set(_loaded_keys, _name, _key);
        array_push(_assigned_keys, _key);
    }

    ini_close();
    // Older settings may already use Up or Down for another action.
    var _available_defaults = [];
    var _displaced_actions = [];
    for (var _i = 0; _i < array_length(_key_names); ++_i) {
        var _name = _key_names[_i];
        var _default_key = struct_get(_settings.keys, _name);
        var _taken = array_contains(_assigned_keys, _default_key);
        if (struct_exists(_loaded_keys, _name)) {
            if (!_taken) {
                array_push(_available_defaults, _default_key);
            }
        } else if (_taken) {
            array_push(_displaced_actions, _name);
        } else {
            struct_set(_loaded_keys, _name, _default_key);
        }
    }
    for (var _i = 0; _i < array_length(_displaced_actions); ++_i) {
        struct_set(_loaded_keys, _displaced_actions[_i], _available_defaults[_i]);
    }

    _settings.keys = _loaded_keys;
    return _settings;
}

function game_settings_save() {
    var _settings = global.settings;
    ini_open("iwbtb_settings.ini");
    ini_write_string("Options", "MusicVolume", string_format(_settings.music_volume, 0, 0));
    ini_write_string("Options", "SpeechVolume", string_format(_settings.speech_volume, 0, 0));
    ini_write_string("Options", "SpecialJumpingSounds", _settings.special_jump_sounds ? "1" : "0");
    ini_write_string("Options", "SpecialShootingSounds", _settings.special_shoot_sounds ? "1" : "0");
    ini_write_string("Options", "SpecialShotGraphics", _settings.special_shot_graphics ? "1" : "0");
    ini_write_string("Options", "DigDugWalkSound", _settings.character_walk_sound ? "1" : "0");
    ini_write_string("Options", "BloodIntensity", string_format(_settings.blood_intensity, 0, 0));
    ini_write_string("Options", "Mirror", _settings.mirror ? "1" : "0");
    ini_write_string("Options", "MusicRestart", _settings.restart_music ? "1" : "0");
    ini_write_string("Options", "FPS", _settings.show_fps ? "1" : "0");
    ini_write_string("Options", "ShowDeaths", _settings.show_deaths ? "1" : "0");
    if (!is_undefined(_settings.auto_fire)) {
        ini_write_string("Options", "AutoFire", _settings.auto_fire ? "1" : "0");
    }
    ini_write_string("Options", "LowInputLatency", _settings.low_input_latency ? "1" : "0");
    ini_write_string("Options", "DisplayMode", string_format(_settings.display_mode, 0, 0));
    ini_write_string("Options", "FrameRate", string_format(_settings.frame_rate, 0, 0));

    var _key_names = struct_get_names(_settings.keys);
    for (var _i = 0; _i < array_length(_key_names); ++_i) {
        var _name = _key_names[_i];
        ini_write_string("Controls", _name, string_format(struct_get(_settings.keys, _name), 0, 0));
    }

    ini_close();
}
