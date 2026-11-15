function custom_character_editor_open(_is_edit) {
    custom_editor = {
        edit: _is_edit,
        names: [],
        character: undefined,
        selected: -1,
        scroll: 0,
        animation: 0,
        frame: 0,
        age: 0,
        audio: undefined,
        sound_present: [],
        edited: false,
        music: -1,
        paused_stage: -1,
        message: ""
    };
    if (_is_edit) {
        if (game_controller.stage_music_is_playing()) {
            custom_editor.paused_stage = game_controller.stage_music_instance;
            audio_pause_sound(custom_editor.paused_stage);
        }
        custom_editor.music = audio_play_sound(snd_mario_celebration_music, 0, true, global.settings.music_volume / 100);
    }
    var _preferred = custom_preview_name == "" ? global.profile.custom_character : custom_preview_name;
    custom_character_editor_rescan(_preferred);
}

function custom_character_editor_close(_refresh = true) {
    if (!is_undefined(custom_editor)) {
        var _edited = custom_editor.edited;
        if (custom_editor.music != -1 && audio_is_playing(custom_editor.music)) {
            audio_stop_sound(custom_editor.music);
        }
        var _paused = custom_editor.paused_stage;
        if (_refresh && _paused != -1 && game_controller.stage_music_instance == _paused && audio_is_paused(_paused)) {
            audio_resume_sound(_paused);
        }
        custom_character_editor_stop_audio();
        custom_character_unload(custom_editor.character);
        custom_editor = undefined;
        if (_refresh && _edited && custom_preview_name != "") {
            set_custom_preview(custom_preview_name);
        }
    }
}

function custom_character_editor_rescan(_preferred) {
    var _editor = custom_editor;
    var _root = game_save_id + "Custom/";
    if (!directory_exists(_root)) {
        directory_create(_root);
    }
    _editor.names = [];
    var _name = file_find_first(_root + "*", fa_directory);
    while (_name != "") {
        if (custom_character_valid_name(_name) && directory_exists(custom_character_path(_name))) {
            array_push(_editor.names, _name);
        }
        _name = file_find_next();
    }
    file_find_close();
    array_sort(_editor.names, true);
    var _selected = array_get_index(_editor.names, _preferred);
    _editor.scroll = clamp(_selected - 8, 0, max(0, array_length(_editor.names) - 9));
    custom_character_editor_select(max(0, _selected));
}

function custom_character_editor_select(_index) {
    var _editor = custom_editor;
    custom_character_editor_stop_audio();
    custom_character_unload(_editor.character);
    _editor.selected = -1;
    _editor.character = undefined;
    if (_index >= 0 && _index < array_length(_editor.names)) {
        var _character = custom_character_load(_editor.names[_index], false);
        if (!is_undefined(_character)) {
            _editor.character = _character;
            _editor.selected = _index;
        }
    }
    _editor.frame = 0;
    _editor.age = 0;
    _editor.message = "";
    _editor.sound_present = [];
    if (!is_undefined(_editor.character)) {
        var _names = custom_character_sound_names();
        for (var _i = 0; _i < array_length(_names); ++_i) {
            var _key = _names[_i];
            _editor.sound_present[_i] = file_exists(_editor.character.path + _key + (_key == "theme" ? ".ogg" : ".wav"));
        }
    }
}

function custom_character_editor_new() {
    var _name = string_trim(get_string("New custom character name", ""));
    if (_name == "") {
        return;
    }
    if (!custom_character_valid_name(_name)) {
        custom_editor.message = "Enter a valid folder name.";
        return;
    }
    var _path = custom_character_path(_name);
    if (directory_exists(_path)) {
        custom_editor.message = "A character with that name already exists.";
        return;
    }
    directory_create(_path);
    if (!directory_exists(_path)) {
        custom_editor.message = "Could not create the character folder.";
        return;
    }
    custom_character_editor_rescan(_name);
    custom_editor.animation = PlayerPose.Idle;
    custom_editor.message = "Import Stop frame 1 to make this character selectable.";
}

function custom_character_editor_saved() {
    var _name = custom_editor.character.name;
    if (variable_global_exists("custom_character_cache") && global.custom_character_cache.name == _name) {
        global.custom_character_cache.reload = true;
    }
    custom_editor.edited = true;
    custom_editor.message = "Saved to animation.ini";
}

function custom_character_editor_update_clip(_field, _delta) {
    var _editor = custom_editor;
    var _character = _editor.character;
    var _key = custom_character_animation_names()[_editor.animation];
    var _clip = _character.animations[_editor.animation];
    var _frames = _clip.frames;
    var _old_count = array_length(_frames);
    switch (_field) {
        case 0:
            _clip.delay = max(0, _clip.delay + _delta);
            _clip.rate = 1 / max(1, _clip.delay);
            break;
        case 1:
            var _is_trail = _editor.animation == CustomPose.Trail;
            var _count = _is_trail && _character.trail_uses_portrait ? 0 : _old_count;
            var _new_count = clamp(_count + _delta, _is_trail ? 0 : 1, 256);
            if (_is_trail) {
                _character.trail_uses_portrait = _new_count == 0;
                _new_count = max(1, _new_count);
            }
            for (var _i = _new_count; _i < _old_count; ++_i) {
                if (_frames[_i] != noone) {
                    sprite_delete(_frames[_i]);
                }
            }
            array_resize(_frames, _new_count);
            for (var _i = _old_count; _i < _new_count; ++_i) {
                _frames[_i] = custom_character_load_png(_character.path + _key + string(_i + 1) + ".png");
            }
            _clip.frames = _frames;
            _clip.loop_start = min(_clip.loop_start, _new_count - 1);
            _editor.frame = min(_editor.frame, _new_count - 1);
            break;
        case 2:
            _clip.loop = !_clip.loop;
            break;
        case 3:
            _clip.loop_start = clamp(_clip.loop_start + _delta, 0, _old_count - 1);
            break;
    }
    ini_open(_character.path + "animation.ini");
    ini_write_real("speeds", _key, _clip.delay);
    ini_write_real("frames", _key, _editor.animation == CustomPose.Trail && _character.trail_uses_portrait
        ? 0 : array_length(_clip.frames));
    ini_write_real("loop", "loop" + _key, _clip.loop);
    ini_write_real("loop", "frame" + _key, _clip.loop_start + 1);
    ini_close();
    _editor.age = 0;
    custom_character_editor_saved();
}

function custom_character_editor_import(_file, _target) {
    var _source = string_lower(string_replace_all(_file, "\\", "/"));
    if (_source == string_lower(string_replace_all(_target, "\\", "/"))) {
        return true;
    }
    var _contents = buffer_load(_file);
    if (_contents == -1) {
        return false;
    }
    var _length = buffer_get_size(_contents);
    buffer_save(_contents, _target);
    var _check = buffer_load(_target);
    var _written = _check != -1 && buffer_get_size(_check) == _length
        && buffer_md5(_check, 0, _length) == buffer_md5(_contents, 0, _length);
    if (_check != -1) {
        buffer_delete(_check);
    }
    buffer_delete(_contents);
    return _written;
}

function custom_character_editor_replace_frame() {
    var _editor = custom_editor;
    var _file = get_open_filename("PNG images|*.png", "");
    if (_file == "") {
        return;
    }
    var _sprite = custom_character_load_png(_file);
    if (_sprite == noone) {
        _editor.message = "Could not open that PNG image.";
        return;
    }
    var _clip = _editor.character.animations[_editor.animation];
    var _key = custom_character_animation_names()[_editor.animation];
    var _target = _editor.character.path + _key + string(_editor.frame + 1) + ".png";
    if (!custom_character_editor_import(_file, _target)) {
        sprite_delete(_sprite);
        _editor.message = "Could not save the imported image.";
        return;
    }
    if (_clip.frames[_editor.frame] != noone) {
        sprite_delete(_clip.frames[_editor.frame]);
    }
    _clip.frames[_editor.frame] = _sprite;
    custom_character_editor_saved();
    _editor.message = "Imported " + filename_name(_target);
}

function custom_character_editor_change_sound(_slot) {
    var _editor = custom_editor;
    var _theme = _slot == array_length(custom_character_sound_names()) - 1;
    var _key = custom_character_sound_names()[_slot];
    var _target = _editor.character.path + _key + (_theme ? ".ogg" : ".wav");
    var _file = get_open_filename(_theme ? "Ogg Vorbis|*.ogg" : "PCM WAV|*.wav", "");
    if (_file == "") {
        return;
    }
    var _resource = _theme ? custom_character_load_theme(_file) : custom_character_load_wav(_file);
    if (is_undefined(_resource)) {
        _editor.message = _theme ? "Choose an Ogg Vorbis theme." : "Choose a mono or stereo 8-bit or 16-bit PCM WAV.";
        return;
    }
    custom_character_editor_free_sound(_resource, _theme);
    custom_character_editor_stop_audio();
    if (!custom_character_editor_import(_file, _target)) {
        _editor.message = "Could not save the imported sound.";
        return;
    }
    custom_character_editor_saved();
    _editor.sound_present[_slot] = true;
    _editor.message = "Imported " + filename_name(_target);
}

function custom_character_editor_remove_sound(_slot) {
    var _editor = custom_editor;
    var _key = custom_character_sound_names()[_slot];
    var _target = _editor.character.path + _key + (_key == "theme" ? ".ogg" : ".wav");
    if (file_exists(_target) && show_question("Remove " + filename_name(_target) + " from this character?")) {
        custom_character_editor_stop_audio();
        file_delete(_target);
        if (file_exists(_target)) {
            _editor.message = "Could not remove the sound.";
            return;
        }
        custom_character_editor_saved();
        _editor.sound_present[_slot] = false;
        _editor.message = "Removed " + filename_name(_target);
    }
}

function custom_character_editor_preview_sound(_slot) {
    custom_character_editor_stop_audio();
    var _editor = custom_editor;
    var _key = custom_character_sound_names()[_slot];
    var _theme = _key == "theme";
    var _path = _editor.character.path + _key + (_theme ? ".ogg" : ".wav");
    var _entry = _theme ? custom_character_load_theme(_path) : custom_character_load_wav(_path);
    if (is_undefined(_entry)) {
        _editor.message = "No playable " + filename_name(_path) + " was found.";
        return;
    }
    _editor.audio = { entry: _entry, theme: _theme, instance: audio_play_sound(_entry.sound, 1, false) };
    _editor.message = "Playing " + filename_name(_path);
}

function custom_character_editor_free_sound(_entry, _theme) {
    if (_theme) {
        audio_destroy_stream(_entry.sound);
    } else {
        audio_free_buffer_sound(_entry.sound);
        buffer_delete(_entry.data);
    }
}

function custom_character_editor_stop_audio() {
    var _audio = custom_editor.audio;
    if (!is_undefined(_audio)) {
        if (audio_is_playing(_audio.instance) || audio_is_paused(_audio.instance)) {
            audio_stop_sound(_audio.instance);
        }
        custom_character_editor_free_sound(_audio.entry, _audio.theme);
        custom_editor.audio = undefined;
    }
}

function custom_character_editor_set_origin(_x, _y) {
    var _character = custom_editor.character;
    _character.bullet_x = _x;
    _character.bullet_y = _y;
    ini_open(_character.path + "animation.ini");
    ini_write_real("values", "bulletXoffset", _x);
    ini_write_real("values", "bulletYoffset", _y);
    ini_close();
    custom_character_editor_saved();
}

function custom_character_editor_trail_color() {
    var _character = custom_editor.character;
    var _hex = "0123456789ABCDEF";
    var _color = _character.trail_color;
    var _text = "";
    for (var _channel = 0; _channel < 3; ++_channel) {
        var _byte = (_color >> (_channel * 8)) & 255;
        _text += string_char_at(_hex, (_byte >> 4) + 1) + string_char_at(_hex, (_byte & 15) + 1);
    }
    _text = string_upper(string_trim(get_string("Trail color (RRGGBB)", _text)));
    if (string_length(_text) != 6) {
        return;
    }
    _color = 0;
    for (var _channel = 0; _channel < 3; ++_channel) {
        var _high = string_pos(string_char_at(_text, _channel * 2 + 1), _hex) - 1;
        var _low = string_pos(string_char_at(_text, _channel * 2 + 2), _hex) - 1;
        if (_high < 0 || _low < 0) {
            custom_editor.message = "Enter six hexadecimal digits.";
            return;
        }
        _color |= (_high * 16 + _low) << (_channel * 8);
    }
    _character.trail_color = _color;
    custom_character_editor_save_trail();
}

function custom_character_editor_save_trail() {
    var _character = custom_editor.character;
    ini_open(_character.path + "animation.ini");
    ini_write_real("trail", "color", _character.trail_color);
    ini_write_real("trail", "length", _character.trail_length);
    ini_write_real("trail", "trans", _character.trail_transparency);
    ini_write_real("frames", "trail", _character.trail_uses_portrait ? 0
        : array_length(_character.animations[CustomPose.Trail].frames));
    ini_close();
    custom_character_editor_saved();
}

function custom_character_editor_step(_mx, _my) {
    var _editor = custom_editor;
    ++_editor.age;
    if (!is_undefined(_editor.audio) && !audio_is_playing(_editor.audio.instance) && !audio_is_paused(_editor.audio.instance)) {
        custom_character_editor_stop_audio();
    }
    if (keyboard_check_pressed(vk_escape)) {
        custom_character_editor_close();
        return;
    }

    var _over_names = point_in_rectangle(_mx, _my, 16, 87, 177, 284);
    if (_over_names) {
        var _wheel = mouse_wheel_down() - mouse_wheel_up();
        var _max_scroll = max(0, array_length(_editor.names) - 9);
        _editor.scroll = clamp(_editor.scroll + _wheel, 0, _max_scroll);
    }
    if (!mouse_check_button_pressed(mb_left)) {
        return;
    }
    if (point_in_rectangle(_mx, _my, 16, 15, 79, 34)) {
        custom_character_editor_close();
        return;
    }
    if (point_in_rectangle(_mx, _my, 464, 53, 623, 74)) {
        clipboard_set_text(game_save_id + "Custom/");
        _editor.message = "Copied the Custom folder path.";
        return;
    }
    if (point_in_rectangle(_mx, _my, 106, 53, 177, 74)) {
        var _name = is_undefined(_editor.character) ? global.profile.custom_character : _editor.character.name;
        custom_character_editor_rescan(_name);
        return;
    }
    if (_editor.edit && point_in_rectangle(_mx, _my, 16, 53, 102, 74)) {
        custom_character_editor_new();
        return;
    }
    if (_over_names) {
        if (_my >= 267) {
            var _delta = _mx < 96 ? -1 : 1;
            _editor.scroll = clamp(_editor.scroll + _delta, 0, max(0, array_length(_editor.names) - 9));
        } else {
            var _index = _editor.scroll + floor((_my - 87) / 20);
            if (_index != _editor.selected && _index < array_length(_editor.names)) {
                custom_character_editor_select(_index);
            }
        }
        return;
    }
    var _character = _editor.character;
    if (is_undefined(_character)) {
        return;
    }
    if (_editor.edit) {
        custom_character_editor_edit_step(_mx, _my);
    } else if (point_in_rectangle(_mx, _my, 333, 409, 475, 435)) {
        if (set_custom_preview(_character.name)) {
            custom_character_editor_close();
        } else {
            _editor.message = "Import stop1.png before selecting this character.";
        }
    }
}

function custom_character_editor_edit_step(_mx, _my) {
    var _editor = custom_editor;
    var _character = _editor.character;
    var _clip = _character.animations[_editor.animation];

    if (point_in_rectangle(_mx, _my, 16, 315, 150, 449)) {
        _editor.animation = (_my - 315) div 15;
        _editor.frame = 0;
        _editor.age = 0;
        return;
    }
    if (point_in_rectangle(_mx, _my, 168, 315, 319, 394)) {
        var _frame = (_editor.frame div 16) * 16 + ((_my - 315) div 20) * 4 + ((_mx - 168) div 38);
        if (_frame < array_length(_clip.frames)) {
            _editor.frame = _frame;
        }
        return;
    }
    if (point_in_rectangle(_mx, _my, 168, 396, 319, 413)) {
        var _page = _editor.frame div 16 + (_mx < 244 ? -1 : 1);
        var _last_page = (array_length(_clip.frames) - 1) div 16;
        _editor.frame = 16 * clamp(_page, 0, _last_page);
        return;
    }
    if (point_in_rectangle(_mx, _my, 168, 416, 319, 435)) {
        custom_character_editor_replace_frame();
        return;
    }
    if (point_in_rectangle(_mx, _my, 451, 315, 498, 394)) {
        var _field = (_my - 315) div 20;
        if (_field != 3 || _clip.loop) {
            custom_character_editor_update_clip(_field, _mx < 474 ? -1 : 1);
        }
        return;
    }
    if (point_in_rectangle(_mx, _my, 188, 107, 380, 271)) {
        custom_character_editor_set_origin(_mx - 284, _my - 267);
        return;
    }
    if (_editor.animation == CustomPose.Trail) {
        if (point_in_rectangle(_mx, _my, 506, 315, 625, 333)) {
            _character.trail_uses_portrait = !_character.trail_uses_portrait;
            custom_character_editor_save_trail();
        } else if (point_in_rectangle(_mx, _my, 506, 335, 625, 353)) {
            custom_character_editor_trail_color();
        } else if (point_in_rectangle(_mx, _my, 506, 355, 625, 373)) {
            _character.trail_length = max(0, get_integer("Trail length (steps)", _character.trail_length));
            custom_character_editor_save_trail();
        } else if (point_in_rectangle(_mx, _my, 506, 375, 625, 393)) {
            _character.trail_transparency = clamp(get_integer("Trail transparency (0-100)", _character.trail_transparency), 0, 100);
            custom_character_editor_save_trail();
        }
        return;
    }
    if (point_in_rectangle(_mx, _my, 500, 88, 625, 255)) {
        var _sound = (_my - 88) div 28;
        if (_mx < 563) {
            custom_character_editor_change_sound(_sound);
        } else if (_mx < 595) {
            custom_character_editor_preview_sound(_sound);
        } else if (_editor.sound_present[_sound]) {
            custom_character_editor_remove_sound(_sound);
        }
    }
}

function custom_character_editor_button(_x, _y, _width, _height, _label, _selected = false, _enabled = true) {
    draw_set_color(_selected ? make_color_rgb(248, 218, 109) : make_color_rgb(231, 243, 250));
    draw_rectangle(_x, _y, _x + _width, _y + _height, false);
    draw_set_color(make_color_rgb(36, 54, 72));
    draw_rectangle(_x, _y, _x + _width, _y + _height, true);
    draw_set_color(_enabled ? make_color_rgb(19, 33, 50) : make_color_rgb(101, 123, 135));
    draw_text(_x + 4, _y + (_height - string_height(_label)) div 2, _label);
}

function custom_character_editor_preview(_label, _sprite, _x, _y, _width, _height) {
    draw_set_color(make_color_rgb(53, 183, 242));
    draw_rectangle(_x, _y, _x + _width, _y + _height, false);
    draw_set_color(make_color_rgb(26, 60, 73));
    draw_rectangle(_x, _y, _x + _width, _y + _height, true);
    draw_text(_x + 8, _y + 6, _label);
    var _base = _y + _height - 5;
    for (var _i = 0; _i < _width div 16; ++_i) {
        draw_sprite(spr_dresser_platform_tile, 0, _x + _i * 16, _base);
    }
    if (_sprite != noone) {
        var _scale = min(1, (_width - 16) / sprite_get_width(_sprite), (_height - 44) / sprite_get_height(_sprite));
        draw_sprite_ext(_sprite, 0, _x + _width div 2, _base, _scale, _scale, 0, c_white, 1);
    }
}

function custom_character_editor_draw() {
    var _editor = custom_editor;
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(213, 232, 246));
    draw_rectangle(0, 0, 640, 480, false);
    draw_set_color(make_color_rgb(21, 46, 76));
    draw_rectangle(0, 0, 640, 44, false);
    draw_set_color(c_white);
    draw_text(91, 16, _editor.edit ? "Custom Character Editor" : "Choose a Custom Character");
    custom_character_editor_button(16, 15, 63, 19, "Back");
    if (_editor.edit) {
        custom_character_editor_button(16, 53, 86, 21, "New Character");
    }
    custom_character_editor_button(106, 53, 71, 21, "Refresh");
    custom_character_editor_button(464, 53, 159, 21, "Copy Custom folder path");

    var _count = array_length(_editor.names);
    for (var _i = 0; _i < 9 && _editor.scroll + _i < _count; ++_i) {
        var _index = _editor.scroll + _i;
        var _name = _editor.names[_index];
        while (string_width(_name) > 150) {
            _name = string_delete(_name, string_length(_name), 1);
        }
        custom_character_editor_button(16, 87 + _i * 20, 161, 18, _name, _index == _editor.selected);
    }
    if (_count > 9) {
        custom_character_editor_button(16, 267, 78, 17, "Previous", false, _editor.scroll > 0);
        custom_character_editor_button(97, 267, 80, 17, "Next", false, _editor.scroll < _count - 9);
    }

    if (is_undefined(_editor.character)) {
        draw_set_color(make_color_rgb(21, 46, 76));
        draw_text(196, 128, _editor.edit ? "Create a character or copy a character folder into Custom." : "No local characters found.");
        draw_text(196, 148, _editor.edit ? "Import numbered PNG frames to build its animations." : "Add a character folder or create one with Edit.");
    } else if (_editor.edit) {
        custom_character_editor_draw_clip();
    } else {
        var _clip = _editor.character.animations[PlayerPose.Idle];
        var _sprite = _clip.frames[custom_character_frame_at(_clip, _editor.age)];
        custom_character_editor_preview(_editor.character.name, _sprite, 208, 87, 392, 294);
        var _available = _clip.frames[0] != noone;
        custom_character_editor_button(333, 409, 142, 26, "Select Character", false, _available);
        if (!_available) {
            draw_text(333, 440, "Missing stop1.png");
        }
    }
    draw_set_color(make_color_rgb(19, 33, 50));
    draw_text(16, 460, _editor.message);
    draw_set_color(c_white);
}

function custom_character_editor_draw_clip() {
    var _editor = custom_editor;
    var _character = _editor.character;
    var _names = custom_character_animation_names();
    var _clip = _character.animations[_editor.animation];
    var _frame = _editor.frame;
    var _count = array_length(_clip.frames);
    var _is_trail = _editor.animation == CustomPose.Trail;
    var _keys = ["Stop", "Walk", "Jump", "Fall", "Shoot", "Bullet", "Open Chest", "Item Get", "Trail"];
    var _animated = _clip.frames[custom_character_frame_at(_clip, _editor.age)];
    custom_character_editor_preview("Frame " + string(_frame + 1), _clip.frames[_frame], 188, 107, 192, 165);
    custom_character_editor_preview("Animation", _animated, 387, 107, 112, 165);
    draw_set_color(c_red);
    var _origin_x = 284 + _character.bullet_x;
    var _origin_y = 267 + _character.bullet_y;
    draw_line(_origin_x - 4, _origin_y, _origin_x + 4, _origin_y);
    draw_line(_origin_x, _origin_y - 4, _origin_x, _origin_y + 4);
    draw_set_color(make_color_rgb(21, 46, 76));
    draw_text(188, 278, "Click the frame preview to set the bullet origin.");
    for (var _i = 0; _i < array_length(_keys); ++_i) {
        custom_character_editor_button(16, 315 + 15 * _i, 134, 14, _keys[_i], _editor.animation == _i);
    }
    var _first = (_frame div 16) * 16;
    for (var _i = 0; _i < min(16, _count - _first); ++_i) {
        var _index = _first + _i;
        custom_character_editor_button(168 + (_i mod 4) * 38, 315 + (_i div 4) * 20, 36, 18,
            string(_index + 1), _frame == _index, _clip.frames[_index] != noone);
    }
    custom_character_editor_button(168, 396, 75, 17, "Previous", false, _first > 0);
    custom_character_editor_button(245, 396, 74, 17, "Next", false, _first + 16 < _count);
    custom_character_editor_button(168, 416, 151, 19, "Import PNG");
    draw_set_color(make_color_rgb(21, 46, 76));
    draw_text(168, 439, _names[_editor.animation] + string(_frame + 1) + ".png");

    var _fields = ["Frame delay", "Frame count", "Loop", "Loop start"];
    var _shown_count = _is_trail && _character.trail_uses_portrait ? 0 : _count;
    var _values = [string(_clip.delay), string(_shown_count), _clip.loop ? "On" : "Off", string(_clip.loop_start + 1)];
    for (var _i = 0; _i < array_length(_fields); ++_i) {
        var _y = 315 + _i * 20;
        draw_set_color(make_color_rgb(21, 46, 76));
        draw_text(331, _y + 3, _fields[_i]);
        draw_text(417, _y + 3, _values[_i]);
        if (_i == 2) {
            custom_character_editor_button(451, _y, 47, 18, "Toggle");
        } else {
            var _active = _i != 3 || _clip.loop;
            custom_character_editor_button(451, _y, 21, 18, "-", false, _active);
            custom_character_editor_button(476, _y, 22, 18, "+", false, _active);
        }
    }
    if (_is_trail) {
        custom_character_editor_button(506, 315, 119, 18, _character.trail_uses_portrait ? "Use pose: On" : "Use pose: Off");
        custom_character_editor_button(506, 335, 119, 18, "Trail color");
        draw_set_color(_character.trail_color);
        draw_rectangle(601, 339, 619, 348, false);
        custom_character_editor_button(506, 355, 119, 18, "Length: " + string(_character.trail_length));
        custom_character_editor_button(506, 375, 119, 18, "Opacity: " + string(100 - _character.trail_transparency) + "%");
    } else {
        var _sounds = ["Jump", "Air Jump", "Shoot", "Walk", "Land", "Theme"];
        for (var _i = 0; _i < array_length(_sounds); ++_i) {
            var _y = 88 + _i * 28;
            var _present = _editor.sound_present[_i];
            custom_character_editor_button(500, _y, 61, 21, _sounds[_i], _present);
            custom_character_editor_button(564, _y, 29, 21, "Play", false, _present);
            custom_character_editor_button(596, _y, 29, 21, "Del", false, _present);
        }
        draw_set_color(make_color_rgb(21, 46, 76));
        draw_text(503, 259, "Click a name to import.");
    }
}
