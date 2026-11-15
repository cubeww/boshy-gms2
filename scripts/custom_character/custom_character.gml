#macro CHARACTER_CUSTOM 156
#macro CUSTOM_THEME_CD 1337

enum CustomPose {
    Bullet = 5,
    OpenChest,
    ItemGet,
    Trail
}

function custom_character_path(_name) {
    return game_save_id + "Custom/" + _name + "/";
}

function custom_character_valid_name(_name) {
    if (_name == "" || _name != string_trim(_name) || string_ends_with(_name, ".")) {
        return false;
    }
    for (var _i = 1; _i <= string_length(_name); ++_i) {
        var _char = string_char_at(_name, _i);
        if (ord(_char) < 32 || string_pos(_char, "<>:\"/\\|?*") > 0) {
            return false;
        }
    }
    var _dot = string_pos(".", _name);
    var _stem = string_upper(_dot == 0 ? _name : string_copy(_name, 1, _dot - 1));
    if (_stem == "CON" || _stem == "PRN" || _stem == "AUX" || _stem == "NUL") {
        return false;
    }
    if (string_length(_stem) == 4 && (string_starts_with(_stem, "COM") || string_starts_with(_stem, "LPT"))
        && string_pos(string_char_at(_stem, 4), "123456789¹²³") > 0) {
        return false;
    }
    return true;
}

function custom_character_available(_name) {
    return custom_character_valid_name(_name) && file_exists(custom_character_path(_name) + "stop1.png");
}

function custom_character_animation_names() {
    static _names = ["stop", "walk", "jump", "fall", "shoot", "bullet", "openchest", "itemget", "trail"];
    return _names;
}

function custom_character_sound_names() {
    static _names = ["jump", "doublejump", "shoot", "walk", "land", "theme"];
    return _names;
}

function custom_character_load_png(_file) {
    if (!file_exists(_file)) {
        return noone;
    }
    var _sprite = sprite_add(_file, 1, false, false, 0, 0);
    if (_sprite == -1) {
        return noone;
    }
    sprite_set_offset(_sprite, sprite_get_width(_sprite) div 2, sprite_get_height(_sprite) div 2);
    return _sprite;
}

function custom_character_load_wav(_file) {
    if (!file_exists(_file)) {
        return undefined;
    }
    var _buffer = buffer_load(_file);
    if (_buffer == -1) {
        return undefined;
    }
    var _size = buffer_get_size(_buffer);
    var _sound = -1;
    var _pcm = -1;
    // Read the RIFF chunk directory. Encoders may put other chunks before the PCM data.
    if (_size >= 12 && buffer_peek(_buffer, 0, buffer_u32) == $46464952
        && buffer_peek(_buffer, 8, buffer_u32) == $45564157) {
        var _rate = 0;
        var _channels = 0;
        var _bits = 0;
        var _offset = 0;
        var _length = 0;
        for (var _chunk = 12; _chunk + 8 <= _size;) {
            var _tag = buffer_peek(_buffer, _chunk, buffer_u32);
            var _bytes = buffer_peek(_buffer, _chunk + 4, buffer_u32);
            var _data = _chunk + 8;
            if (_bytes > _size - _data) {
                break;
            }
            if (_tag == $20746D66 && _bytes >= 16 && buffer_peek(_buffer, _data, buffer_u16) == 1) {
                _channels = buffer_peek(_buffer, _data + 2, buffer_u16);
                _rate = buffer_peek(_buffer, _data + 4, buffer_u32);
                _bits = buffer_peek(_buffer, _data + 14, buffer_u16);
            } else if (_tag == $61746164 && _offset == 0) {
                _offset = _data;
                _length = _bytes;
            }
            _chunk = _data + _bytes + (_bytes mod 2);
        }
        if (_length > 0 && _rate >= 8000 && _rate <= 48000 && (_channels == 1 || _channels == 2)
            && (_bits == 8 || _bits == 16)) {
            var _stride = _channels * (_bits div 8);
            _length -= _length mod _stride;
            if (_length > 0) {
                _pcm = buffer_create(_length, buffer_fixed, 1);
                buffer_copy(_buffer, _offset, _length, _pcm, 0);
                _sound = audio_create_buffer_sound(_pcm, _bits == 8 ? buffer_u8 : buffer_s16, _rate, 0,
                    _length, _channels == 1 ? audio_mono : audio_stereo);
            }
        }
    }
    buffer_delete(_buffer);
    if (_sound == -1 && _pcm != -1) {
        buffer_delete(_pcm);
    }
    if (_sound == -1) {
        return undefined;
    }
    return { sound: _sound, data: _pcm };
}

function custom_character_load_theme(_file) {
    if (!file_exists(_file)) {
        return undefined;
    }
    var _buffer = buffer_create(128, buffer_fixed, 1);
    buffer_load_partial(_buffer, _file, 0, 128, 0);
    var _rate = 44100;
    // The first packet of a Vorbis stream contains the channel's native rate.
    var _packet = 27 + buffer_peek(_buffer, 26, buffer_u8);
    if (_packet + 16 <= 128 && buffer_peek(_buffer, 0, buffer_u32) == $5367674F
        && buffer_peek(_buffer, _packet, buffer_u32) == $726F7601
        && buffer_peek(_buffer, _packet + 4, buffer_u32) == $00736962) {
        _rate = max(1, buffer_peek(_buffer, _packet + 12, buffer_u32));
    }
    buffer_delete(_buffer);
    var _sound = audio_create_stream(_file);
    return _sound == -1 ? undefined : { sound: _sound, rate: _rate };
}

function custom_character_load(_name, _with_sound = true) {
    if (!custom_character_valid_name(_name)) {
        return undefined;
    }
    var _path = custom_character_path(_name);
    if (!directory_exists(_path)) {
        return undefined;
    }
    var _custom = { name: _name, path: _path, animations: [], sounds: [], theme: undefined, trail_uses_portrait: false };
    var _names = custom_character_animation_names();
    ini_open(_path + "animation.ini");
    for (var _i = 0; _i < array_length(_names); ++_i) {
        var _key = _names[_i];
        var _requested = floor(ini_read_real("frames", _key, 4));
        var _count = clamp(_requested, 1, 256);
        if (_i == CustomPose.Trail) {
            _custom.trail_uses_portrait = _requested <= 0;
        }
        var _delay = max(0, floor(ini_read_real("speeds", _key, 10)));
        var _loop_start = clamp(floor(ini_read_real("loop", "frame" + _key, 1)), 1, _count) - 1;
        var _loop = ini_read_real("loop", "loop" + _key, 1) != 0;
        _custom.animations[_i] = { frames: array_create(_count, noone), rate: 1 / max(1, _delay),
            delay: _delay, loop: _loop, loop_start: _loop_start };
    }
    _custom.bullet_x = ini_read_real("values", "bulletXoffset", 0);
    _custom.bullet_y = ini_read_real("values", "bulletYoffset", 0);
    _custom.trail_color = clamp(floor(ini_read_real("trail", "color", 16754215)), 0, $FFFFFF);
    _custom.trail_length = max(0, floor(ini_read_real("trail", "length", 9)));
    _custom.trail_transparency = clamp(ini_read_real("trail", "trans", 50), 0, 100);
    ini_close();
    for (var _i = 0; _i < array_length(_names); ++_i) {
        var _clip = _custom.animations[_i];
        for (var _j = 0; _j < array_length(_clip.frames); ++_j) {
            _clip.frames[_j] = custom_character_load_png(_path + _names[_i] + string(_j + 1) + ".png");
        }
    }
    if (_with_sound) {
        _names = custom_character_sound_names();
        for (var _i = 0; _i < array_length(_names) - 1; ++_i) {
            _custom.sounds[_i] = custom_character_load_wav(_path + _names[_i] + ".wav");
        }
        _custom.theme = custom_character_load_theme(_path + "theme.ogg");
    }
    return _custom;
}

function custom_character_unload(_custom) {
    if (is_undefined(_custom)) {
        return;
    }
    for (var _i = 0; _i < array_length(_custom.animations); ++_i) {
        var _frames = _custom.animations[_i].frames;
        for (var _j = 0; _j < array_length(_frames); ++_j) {
            if (_frames[_j] != noone) {
                sprite_delete(_frames[_j]);
            }
        }
    }
    for (var _i = 0; _i < array_length(_custom.sounds); ++_i) {
        var _entry = _custom.sounds[_i];
        if (!is_undefined(_entry)) {
            audio_stop_sound(_entry.sound);
            audio_free_buffer_sound(_entry.sound);
            buffer_delete(_entry.data);
        }
    }
    if (!is_undefined(_custom.theme)) {
        audio_stop_sound(_custom.theme.sound);
        audio_destroy_stream(_custom.theme.sound);
    }
}

function custom_character_clip_sprite(_custom, _pose, _frame) {
    var _frames = _custom.animations[_pose].frames;
    return _frames[clamp(_frame, 0, array_length(_frames) - 1)];
}

function custom_character_frame_at(_clip, _age) {
    var _count = array_length(_clip.frames);
    var _frame = floor(_age / max(1, _clip.delay));
    if (_frame >= _count) {
        _frame = _clip.loop ? _clip.loop_start + (_frame - _clip.loop_start) mod (_count - _clip.loop_start) : _count - 1;
    }
    return _frame;
}

function custom_character_definition(_custom) {
    if (is_undefined(_custom) || custom_character_clip_sprite(_custom, PlayerPose.Idle, 0) == noone) {
        return undefined;
    }
    var _base = boshy_character();
    var _poses = array_create(5);
    for (var _i = 0; _i < array_length(_poses); ++_i) {
        var _clip = _custom.animations[_i];
        var _frames = array_create(array_length(_clip.frames));
        for (var _j = 0; _j < array_length(_frames); ++_j) {
            _frames[_j] = _j;
        }
        _poses[_i] = { frames: _frames, rate: _clip.rate, loop: _clip.loop, loop_start: _clip.loop_start };
    }
    var _sounds = array_create(5, noone);
    for (var _i = 0; _i < array_length(_custom.sounds); ++_i) {
        if (!is_undefined(_custom.sounds[_i])) {
            _sounds[_i] = _custom.sounds[_i].sound;
        }
    }
    return {
        sprite_right: _base.sprite_right,
        sprite_left: _base.sprite_left,
        projectile_sprite: _base.projectile_sprite,
        muzzle_x: _base.muzzle_x + _custom.bullet_x,
        muzzle_y: _base.muzzle_y + _custom.bullet_y,
        jump_sound: _sounds[0],
        air_jump_sound: _sounds[1],
        shoot_sound: _sounds[2],
        walk_sound: _sounds[3],
        walk_sound_always: true,
        land_sound: _sounds[4],
        death_lines: _base.death_lines,
        movement: _base.movement,
        poses: _poses,
        custom: _custom
    };
}

function game_custom_character() {
    var _name = global.profile.custom_character;
    if (!variable_global_exists("custom_character_cache")) {
        global.custom_character_cache = { name: "", definition: undefined, data: undefined, reload: false };
    }
    var _cache = global.custom_character_cache;
    var _reload = _cache.reload;
    if (_reload && _name == _cache.name) {
        var _game = instance_find(obj_game, 0);
        if (_game != noone && _game.stage_music_cd == CUSTOM_THEME_CD && _game.stage_music_is_playing()) {
            _reload = false;
        }
    }
    if (_name != _cache.name || _reload) {
        custom_character_unload(_cache.data);
        _cache.name = _name;
        _cache.data = custom_character_load(_name);
        _cache.definition = custom_character_definition(_cache.data);
        _cache.reload = false;
    }
    return _cache.definition;
}

function game_custom_character_theme() {
    var _character = game_custom_character();
    return is_undefined(_character) ? undefined : _character.custom.theme;
}

function custom_character_bullet_clip(_character) {
    if (global.settings.special_shot_graphics && room != rm_gastly && struct_exists(_character, "custom")) {
        return _character.custom.animations[CustomPose.Bullet];
    }
    return undefined;
}

function custom_character_player_trail_step() {
    if (!struct_exists(character, "custom") || ++custom_trail_steps < 3) {
        return;
    }
    custom_trail_steps = 0;
    var _custom = character.custom;
    if (_custom.trail_length <= 0 || _custom.trail_transparency >= 100) {
        return;
    }
    var _facing = visual_facing();
    var _clip = character.poses[pose];
    var _frame = _clip.frames[clamp(floor(pose_frame), 0, array_length(_clip.frames) - 1)];
    var _visual = game_character_sprite(character, pose, _frame, _facing);
    var _trail = _custom.trail_uses_portrait ? undefined : _custom.animations[CustomPose.Trail];
    instance_create_depth(x, y, depth + 1, obj_custom_character_trail, {
        sprite_index: _visual.sprite,
        image_index: _visual.frame,
        image_speed: 0,
        image_xscale: _facing,
        image_angle: image_angle,
        image_blend: _custom.trail_color,
        image_alpha: 1 - _custom.trail_transparency / 100,
        trail: _trail,
        lifetime: _custom.trail_length
    });
}

function game_character_sprite(_character, _pose, _frame, _facing) {
    if (struct_exists(_character, "custom")) {
        var _sprite = custom_character_clip_sprite(_character.custom, _pose, _frame);
        if (_sprite == noone) {
            _sprite = custom_character_clip_sprite(_character.custom, PlayerPose.Idle, 0);
        }
        return { sprite: _sprite, frame: 0, xscale: _facing };
    }
    return { sprite: _facing < 0 ? _character.sprite_left : _character.sprite_right, frame: _frame, xscale: 1 };
}

function game_character_draw(_character, _pose, _frame, _facing, _x, _y, _sx = 1, _sy = 1, _angle = 0) {
    var _visual = game_character_sprite(_character, _pose, _frame, _facing);
    draw_sprite_ext(_visual.sprite, _visual.frame, _x, _y, _sx * _visual.xscale, _sy, _angle, c_white, 1);
}
