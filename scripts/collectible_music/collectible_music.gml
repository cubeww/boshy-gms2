function game_music_progress() {
    if (room == rm_title || ((room == rm_options || room == rm_trophies || room == rm_dresser)
        && game_menu_from_title())) {
        return game_campaign_title_slot();
    }
    return game_current_progress();
}

function game_cd_tracks() {
    // Fusion's common CD events use the top row, OEM plus, and Backspace.
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

function game_selected_cd(_progress = undefined) {
    if (is_undefined(_progress)) {
        _progress = game_music_progress();
    }
    var _index = _progress.playing_cd;
    if (_index == CUSTOM_THEME_CD) {
        return is_undefined(game_custom_character_theme()) ? 0 : CUSTOM_THEME_CD;
    }
    var _tracks = game_cd_tracks();
    if (_index >= 1 && _index <= array_length(_tracks) && game_has_item(_tracks[_index - 1][1], _progress)) {
        return _index;
    }
    return 0;
}

function game_cd_is_playing(_index) {
    var _game = instance_find(obj_game, 0);
    return _index > 0 && _game != noone && _game.stage_music_cd == _index && _game.stage_music_is_playing();
}

function game_play_selected_cd(_game, _position = 0) {
    var _index = game_selected_cd();
    if (_index == CUSTOM_THEME_CD) {
        var _theme = game_custom_character_theme();
        _game.play_music_channel(_theme.sound, true, true, _theme.rate, _position, CUSTOM_THEME_CD);
    } else if (_index > 0) {
        var _tracks = game_cd_tracks();
        var _track = _tracks[_index - 1];
        _game.play_music_channel(_track[2], true, true, _track[3], _position, _index);
    }
}

function game_mixer_can_apply() {
    switch (room) {
        case rm_title:
        case rm_credits:
            return true;
        case rm_gradius:
            var _ship = instance_find(obj_gradius_player, 0);
            return (_ship != noone && !_ship.dead) || instance_exists(obj_player);
        case rm_intro:
        case rm_options:
        case rm_trophies:
        case rm_dresser:
        case rm_solgryn_ending:
            return false;
    }
    return instance_exists(obj_player);
}

function game_collectible_music_step(_game, _input_free) {
    if (room == rm_intro || room == rm_solgryn_ending) {
        return false;
    }

    var _progress = game_music_progress();
    var _selected = game_selected_cd(_progress);
    if (_game.cd_entry_pending) {
        _game.cd_entry_pending = false;
        // These frame-start cues replace channel 2 after the inherited CD events.
        if (_selected > 0 && room != rm_title && room != rm_cheetah_men && room != rm_bomberman
            && (room != rm_credits || game_campaign_difficulty() != 0)) {
            game_play_selected_cd(_game, _game.cd_entry_position);
        }
    }

    if (_input_free && room != rm_title) {
        game_mixer_step(_progress);
    }
    _game.apply_stage_mixer();

    if (!variable_global_exists("cd_keys_latched")) {
        global.cd_keys_latched = false;
    }
    var _tracks = game_cd_tracks();
    var _released = !keyboard_check(vk_tab);
    var _pressed = 0;
    for (var _i = 0; _i < array_length(_tracks); ++_i) {
        var _key = _tracks[_i][0];
        _released = _released && !keyboard_check(_key);
        if (_pressed == 0 && keyboard_check_pressed(_key)
            && (_selected > 0 || game_has_item(_tracks[_i][1], _progress))) {
            _pressed = _i + 1;
        }
    }
    if (_released) {
        global.cd_keys_latched = false;
    }
    if (room == rm_credits || room == rm_bomberman || (room == rm_options && !_input_free)) {
        return false;
    }

    var _tab = keyboard_check_pressed(vk_tab);
    var _stop_with_tab = _selected > 0 && _tab;
    if (global.cd_keys_latched) {
        return _stop_with_tab;
    }
    var _start_custom_theme = _selected == 0 && _tab && _game.gameplay_room && _input_free
        && global.profile.character_id == CHARACTER_CUSTOM && !is_undefined(game_custom_character_theme());
    if (_selected > 0 && (_stop_with_tab || _pressed > 0)) {
        _progress.playing_cd = 0;
        _game.stop_stage_music();
        game_restore_music_after_cd(_game);
    } else if (_start_custom_theme) {
        _progress.playing_cd = CUSTOM_THEME_CD;
        game_play_selected_cd(_game);
    } else if (_selected == 0 && _pressed > 0 && _game.gameplay_room && _input_free) {
        _progress.playing_cd = _pressed;
        game_play_selected_cd(_game);
    } else {
        return false;
    }
    global.cd_keys_latched = true;
    global.profile.dirty = true;
    game_profile_save();
    return _stop_with_tab || _start_custom_theme;
}

function game_restore_music_after_cd(_game) {
    var _sound = noone;
    var _loop = true;
    var _rate = 44100;
    var _position = 0;
    switch (room) {
        case rm_tutorial: _sound = snd_tutorial_music; break;
        case rm_prehistorik: _sound = snd_prehistorik_music; break;
        case rm_secret_1_1: _sound = snd_secret_1_1_music; break;
        case rm_hello_kitty: _sound = snd_hello_kitty_music; _loop = false; break;
        case rm_green_greens:
            var _player = instance_find(obj_player, 0);
            if (_player != noone) {
                _sound = _player.x >= 2550 ? snd_green_greens_plains : snd_green_greens_music;
                _position = global.settings.restart_music ? 0 : global.run.music_position;
                var _stage = instance_find(obj_green_greens, 0);
                if (_stage != noone) {
                    _stage.region_music = _sound;
                }
            }
            break;
        case rm_king_dedede: _sound = snd_king_dedede_music; break;
        case rm_ryu:
            var _player = instance_find(obj_player, 0);
            if (_player != noone && _player.x >= 1280) {
                _sound = snd_ryu_music;
                _loop = false;
                _rate = 48000;
            }
            break;
        case rm_cheetahmen: _sound = snd_cheetahmen_music; break;
        case rm_secret_jtv:
            var _boss = instance_find(obj_secret_jtv_encounter, 0);
            _sound = _boss != noone && _boss.arena_started ? snd_secret_jtv_encounter_music : snd_secret_jtv_music;
            break;
        case rm_gastly: _sound = snd_gastly_music; break;
        case rm_mario: _sound = snd_mario_music; break;
        case rm_vvvvvv: _sound = snd_vvvvvv_music; break;
        case rm_biollante:
            var _boss = instance_find(obj_biollante, 0);
            if (_boss != noone && _boss.fight_age >= 250) {
                _sound = snd_biollante_music;
                _loop = false;
            }
            break;
        case rm_wario: _sound = snd_wario_music; _rate = 48000; break;
        case rm_sanicz:
            var _boss = instance_find(obj_sanicz, 0);
            if (_boss != noone && _boss.fight_age >= 40) {
                _sound = snd_sanicz_music;
                _loop = false;
            }
            break;
        case rm_castlevania: _sound = snd_castlevania_music; _rate = 48000; break;
        case rm_pokemon_puzzle: _sound = snd_pokemon_puzzle_music; break;
        case rm_gradius: _sound = snd_gradius_music; break;
        case rm_skeleton_king: skeleton_king_start_music(); return;
        case rm_milon: _sound = snd_milon_music; break;
        case rm_wow: _sound = snd_wow_legends; break;
        case rm_milon_depths: _sound = snd_milon_depths_music; break;
        case rm_mega_man: _sound = snd_mega_man_music; _loop = false; break;
        case rm_mega_man_world: _sound = snd_mega_man_world_music; break;
        case rm_shang_tsung:
            var _boss = instance_find(obj_shang_tsung, 0);
            if (_boss != noone && _boss.fight_age >= 490) {
                _sound = snd_shang_tsung_music;
                _loop = false;
            }
            break;
        case rm_kid_icarus: _sound = snd_kid_icarus_music; _rate = 48000; break;
        case rm_ninja_gaiden: _sound = snd_ninja_gaiden_music; break;
        case rm_missingno:
            var _boss = instance_find(obj_missingno, 0);
            if (_boss != noone && _boss.fight_age >= 780) {
                _sound = snd_ninja_gaiden_boss_exit_music;
            }
            break;
        case rm_desert: _sound = snd_desert_music; break;
        case rm_desert_secret: _sound = snd_desert_secret_music; break;
        case rm_final_path: _sound = snd_final_path_music; break;
        case rm_prize_room: _sound = snd_prize_room_music; break;
        case rm_teleporter: _sound = snd_teleporter_music; break;
    }
    if (_sound != noone) {
        _game.start_stage_music(_sound, _loop, true, _rate, _position);
    }
}
