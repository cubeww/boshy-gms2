function ninja_gaiden_wall_contact(_player, _probe, _kind) {
    var _hit = false;
    var _left = _player.probe_x + _probe.left;
    var _right = _player.probe_x + _probe.right;
    with (obj_ninja_gaiden_wall_jump) {
        if (wall_jump_kind == _kind && bbox_left <= _right && bbox_right >= _left
            && _player.probe_overlaps(_probe, id)) {
            _hit = true;
            break;
        }
    }
    return _hit;
}

function ninja_gaiden_cds() {
    // G93–104 map digit keys, OEM plus and Backspace to the original tracks.
    static _tracks = [
        [ord("1"), "Lalalalalala CD", snd_ninja_gaiden_lalalalala_cd, 48000],
        [ord("2"), "Trololol CD", snd_ninja_gaiden_trololol_cd, 48000],
        [ord("3"), "RickRoll CD", snd_ninja_gaiden_rickroll_cd, 44100],
        [ord("4"), "Chocolate CD", snd_ninja_gaiden_chocolate_cd, 44100],
        [ord("5"), "Barrel Roll CD", snd_ninja_gaiden_barrel_roll_cd, 44100],
        [ord("6"), "Keyboard Cat CD", snd_ninja_gaiden_keyboard_cat_cd, 44100],
        [ord("7"), "Hamster CD", snd_ninja_gaiden_hamster_cd, 44100],
        [ord("8"), "Cookie CD", snd_ninja_gaiden_cookie_cd, 44100],
        [ord("9"), "Wily CD", snd_mega_man_world_wily_cd, 44100],
        [ord("0"), "LIVE CD", snd_kid_icarus_live_cd, 44100],
        [187, "Sax CD", snd_ninja_gaiden_sax_cd, 44100],
        [vk_backspace, "Sexy Sax CD", snd_ninja_gaiden_sexy_sax_cd, 44100]
    ];
    return _tracks;
}

function ninja_gaiden_selected_cd() {
    var _tracks = ninja_gaiden_cds();
    var _cd = global.run.ninja_gaiden_cd;
    if (_cd > 0 && game_has_item(_tracks[_cd - 1][1])) {
        return _tracks[_cd - 1];
    }
    return undefined;
}

function ninja_gaiden_toggle_cd() {
    var _tracks = ninja_gaiden_cds();
    var _keys = global.settings.keys;
    for (var _i = 0; _i < array_length(_tracks); ++_i) {
        var _entry = _tracks[_i];
        if (!keyboard_check_pressed(_entry[0]) || game_key_is_bound(_keys, _entry[0])) {
            continue;
        }
        var _cd = global.run.ninja_gaiden_cd;
        if (_cd == 0 && !game_has_item(_entry[1])) {
            continue;
        }
        _cd = _cd == 0 ? _i + 1 : 0;
        global.run.ninja_gaiden_cd = _cd;
        var _progress = game_current_progress();
        _progress.ninja_gaiden_cd = _cd;
        global.profile.dirty = true;
        global.run.music_position = 0;
        return true;
    }
    return false;
}
