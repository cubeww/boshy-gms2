function game_profile_read_total(_key, _section = "Stats") {
    var _value = string_trim(ini_read_string(_section, _key, ""));
    if (_value == "" || string_length(_value) > 16 || string_digits(_value) != _value) {
        return 0;
    }

    var _total = real(_value);
    // Keep counters within the range where every integer is represented exactly.
    return _total <= 9007199254740991 ? _total : 0;
}

function game_profile_id_valid(_id) {
    return is_string(_id) && _id != "" && string_trim(_id) == _id
        && string_pos("\n", _id) == 0 && string_pos("\r", _id) == 0
        && string_pos("\"", _id) == 0 && string_pos("\\", _id) == 0;
}

function game_profile_read_ids(_section) {
    var _ids = {};
    for (var _i = 0; ini_key_exists(_section, string(_i)); ++_i) {
        var _id = ini_read_string(_section, string(_i), "");
        if (game_profile_id_valid(_id)) {
            struct_set(_ids, _id, true);
        }
    }
    return _ids;
}

function game_profile_write_ids(_section, _flags) {
    ini_section_delete(_section);
    var _ids = struct_get_names(_flags);
    for (var _i = 0; _i < array_length(_ids); ++_i) {
        // Numbered entries preserve original IDs that contain spaces and punctuation.
        ini_write_string(_section, string(_i), _ids[_i]);
    }
}

function game_profile_read_progress(_progress, _section) {
    _progress.trophies = game_profile_read_ids(_section + " Achievements");
    _progress.items = game_profile_read_ids(_section + " Collectables");
    _progress.exploration = game_profile_read_ids(_section + " Exploration");
    _progress.teleporter_unlocked = ini_read_real(_section, "TeleporterUnlocked", 0) == 1;
    _progress.vvvvvv_gravity = ini_read_real(_section, "VVVVVVGravity", 1) == -1 ? -1 : 1;
    _progress.vvvvvv_gravity_flip = ini_read_real(_section, "VVVVVVGravityFlip", 0) == 1;
    _progress.boss_rush_clears = game_profile_read_ids(_section + " Boss Rush");
    _progress.boss_rush_seconds = game_profile_read_total("BossRushSeconds", _section);
    _progress.boss_rush_deaths = game_profile_read_total("BossRushDeaths", _section);
    _progress.hello_kitty_best_time = clamp(floor(ini_read_real(_section, "HelloKittyBestTime", 9999)), 0, 9999);
    _progress.ryu_best_time = clamp(floor(ini_read_real(_section, "RyuBestTime", 9999)), 0, 9999);
    _progress.mario_best_time = clamp(floor(ini_read_real(_section, "MarioBestTime", 9999)), 0, 9999);
    _progress.biollante_best_time = clamp(floor(ini_read_real(_section, "BiollanteBestTime", 9999)), 0, 9999);
    _progress.sonic_best_time = clamp(floor(ini_read_real(_section, "SonicBestTime", 9999)), 0, 9999);
    _progress.skeleton_king_best_time = clamp(floor(ini_read_real(_section, "SkeletonKingBestTime", 9999)), 0, 9999);
    _progress.mega_man_best_time = clamp(floor(ini_read_real(_section, "MegaManBestTime", 9999)), 0, 9999);
    _progress.shang_tsung_best_time = clamp(floor(ini_read_real(_section, "ShangTsungBestTime", 9999)), 0, 9999);
    _progress.shang_tsung_deaths = game_profile_read_total("ShangTsungDeaths", _section);
    _progress.bomberman_deaths = game_profile_read_total("BombermanDeaths", _section);
    _progress.missingno_best_time = clamp(floor(ini_read_real(_section, "MissingnoBestTime", 9999)), 0, 9999);
    _progress.missingno_deaths = game_profile_read_total("MissingnoDeaths", _section);
    _progress.solgryn_best_time = clamp(floor(ini_read_real(_section, "SolgrynBestTime", 9999)), 0, 9999);
    _progress.solgryn_deaths = game_profile_read_total("SolgrynDeaths", _section);
    _progress.credits_seen = ini_read_real(_section, "CreditsSeen", 0) == 1;
    _progress.gastly_dismissed = ini_read_real(_section, "GastlyDismissed", 1) != 0;
    _progress.mega_man_world_cue_played = ini_read_real(_section, "MegaManWorldCuePlayed", 0) != 0;
    _progress.ninja_gaiden_cd = clamp(floor(ini_read_real(_section, "NinjaGaidenCD", 0)), 0, 12);
}

function game_profile_write_progress(_progress, _section) {
    game_profile_write_ids(_section + " Achievements", _progress.trophies);
    game_profile_write_ids(_section + " Collectables", _progress.items);
    game_profile_write_ids(_section + " Exploration", _progress.exploration);
    game_profile_write_ids(_section + " Boss Rush", _progress.boss_rush_clears);
    ini_write_real(_section, "ExplorationRecorded", 1);
    ini_write_real(_section, "TeleporterUnlocked", _progress.teleporter_unlocked ? 1 : 0);
    ini_write_real(_section, "VVVVVVGravity", _progress.vvvvvv_gravity);
    ini_write_real(_section, "VVVVVVGravityFlip", _progress.vvvvvv_gravity_flip ? 1 : 0);
    ini_write_string(_section, "BossRushSeconds", string_format(_progress.boss_rush_seconds, 0, 0));
    ini_write_string(_section, "BossRushDeaths", string_format(_progress.boss_rush_deaths, 0, 0));
    if (_progress.hello_kitty_best_time < 9999) {
        ini_write_real(_section, "HelloKittyBestTime", _progress.hello_kitty_best_time);
    }
    if (_progress.ryu_best_time < 9999) {
        ini_write_real(_section, "RyuBestTime", _progress.ryu_best_time);
    }
    if (_progress.mario_best_time < 9999) {
        ini_write_real(_section, "MarioBestTime", _progress.mario_best_time);
    }
    if (_progress.biollante_best_time < 9999) {
        ini_write_real(_section, "BiollanteBestTime", _progress.biollante_best_time);
    }
    if (_progress.sonic_best_time < 9999) {
        ini_write_real(_section, "SonicBestTime", _progress.sonic_best_time);
    }
    if (_progress.skeleton_king_best_time < 9999) {
        ini_write_real(_section, "SkeletonKingBestTime", _progress.skeleton_king_best_time);
    }
    if (_progress.mega_man_best_time < 9999) {
        ini_write_real(_section, "MegaManBestTime", _progress.mega_man_best_time);
    }
    if (_progress.shang_tsung_best_time < 9999) {
        ini_write_real(_section, "ShangTsungBestTime", _progress.shang_tsung_best_time);
    }
    ini_write_string(_section, "ShangTsungDeaths", string_format(_progress.shang_tsung_deaths, 0, 0));
    if (_progress.bomberman_deaths > 0) {
        ini_write_string(_section, "BombermanDeaths", string_format(_progress.bomberman_deaths, 0, 0));
    }
    if (_progress.missingno_best_time < 9999) {
        ini_write_real(_section, "MissingnoBestTime", _progress.missingno_best_time);
    }
    if (_progress.missingno_deaths > 0) {
        ini_write_string(_section, "MissingnoDeaths", string_format(_progress.missingno_deaths, 0, 0));
    }
    if (_progress.solgryn_best_time < 9999) {
        ini_write_real(_section, "SolgrynBestTime", _progress.solgryn_best_time);
    }
    if (_progress.solgryn_deaths > 0) {
        ini_write_string(_section, "SolgrynDeaths", string_format(_progress.solgryn_deaths, 0, 0));
    }
    if (_progress.credits_seen) {
        ini_write_real(_section, "CreditsSeen", 1);
    }
    ini_write_real(_section, "GastlyDismissed", _progress.gastly_dismissed ? 1 : 0);
    ini_write_real(_section, "MegaManWorldCuePlayed", _progress.mega_man_world_cue_played ? 1 : 0);
    ini_write_real(_section, "NinjaGaidenCD", _progress.ninja_gaiden_cd);
}

function game_profile_load() {
    var _profile = {
        total_deaths: 0,
        play_time_us: 0,
        title_slot: 0,
        practice: {
            trophies: {}, items: {}, hello_kitty_best_time: 9999, ryu_best_time: 9999, mario_best_time: 9999,
            biollante_best_time: 9999, sonic_best_time: 9999, skeleton_king_best_time: 9999, mega_man_best_time: 9999,
            shang_tsung_best_time: 9999, shang_tsung_deaths: 0, bomberman_deaths: 0,
            missingno_best_time: 9999, missingno_deaths: 0,
            solgryn_best_time: 9999, solgryn_deaths: 0, credits_seen: false,
            exploration: {}, teleporter_unlocked: false, boss_rush_clears: {}, boss_rush_seconds: 0, boss_rush_deaths: 0,
            vvvvvv_gravity: 1, vvvvvv_gravity_flip: false,
            gastly_dismissed: true, mega_man_world_cue_played: false, ninja_gaiden_cd: 0
        },
        character_id: CHARACTER_BOSHY,
        character_unlocks: {},
        campaign_slots: [],
        dirty: false
    };

    if (!file_exists("iwbtb_profile.ini")) {
        _profile.campaign_slots = [game_campaign_empty_slot(), game_campaign_empty_slot(), game_campaign_empty_slot()];
        return _profile;
    }

    ini_open("iwbtb_profile.ini");
    _profile.total_deaths = game_profile_read_total("Deaths");
    _profile.play_time_us = game_profile_read_total("PlayTimeUS");
    _profile.campaign_slots = game_campaign_read_slots();
    _profile.title_slot = clamp(floor(ini_read_real("Stats", "TitleSlot", 0)), 0, array_length(_profile.campaign_slots) - 1);
    game_profile_read_progress(_profile.practice, "Practice");
    if (ini_read_real("Practice", "ExplorationRecorded", 0) == 0) {
        teleporter_restore_legacy_exploration(_profile.practice, noone);
    }
    var _character_id = ini_read_real("License", "Character", CHARACTER_BOSHY);
    var _selected_character = undefined;
    var _catalog = dresser_catalog();
    for (var _i = 0; _i < array_length(_catalog); ++_i) {
        var _entry = _catalog[_i];
        if (_entry.unlock_key != "" && ini_read_real("Unlockables", _entry.unlock_key, 0) == 1) {
            struct_set(_profile.character_unlocks, _entry.unlock_key, true);
        }
        if (_entry.id == _character_id) {
            _selected_character = _entry;
        }
    }
    ini_close();
    if (!is_undefined(_selected_character) && game_character_status(_selected_character, _profile) == "available") {
        _profile.character_id = _character_id;
    }
    return _profile;
}

function game_profile_save() {
    var _profile = global.profile;
    if (!_profile.dirty) {
        return;
    }

    ini_open("iwbtb_profile.ini");
    ini_write_string("Stats", "Deaths", string_format(_profile.total_deaths, 0, 0));
    ini_write_string("Stats", "PlayTimeUS", string_format(_profile.play_time_us, 0, 0));
    ini_write_real("Stats", "TitleSlot", _profile.title_slot);
    ini_write_real("License", "Character", _profile.character_id);

    var _character_unlocks = struct_get_names(_profile.character_unlocks);
    for (var _i = 0; _i < array_length(_character_unlocks); ++_i) {
        ini_write_real("Unlockables", _character_unlocks[_i], 1);
    }

    game_profile_write_progress(_profile.practice, "Practice");
    game_campaign_write_slots(_profile.campaign_slots);
    ini_close();
    _profile.dirty = false;
}

function game_current_progress() {
    var _slot = game_campaign_active_slot();
    return is_undefined(_slot) ? global.profile.practice : _slot;
}

function game_trophy_is_unlocked(_id, _progress = undefined) {
    if (is_undefined(_progress)) {
        _progress = game_current_progress();
    }
    return struct_exists(_progress.trophies, _id);
}

function game_trophy_unlock(_id) {
    if (!game_profile_id_valid(_id) || game_trophy_is_unlocked(_id)) {
        return false;
    }

    var _progress = game_current_progress();
    struct_set(_progress.trophies, _id, true);
    global.profile.dirty = true;
    game_profile_save();
    return true;
}

function game_has_item(_id, _progress = undefined) {
    if (is_undefined(_progress)) {
        _progress = game_current_progress();
    }
    return struct_exists(_progress.items, _id);
}

function game_collect_item(_id, _trophy_id = "") {
    if (!game_profile_id_valid(_id) || game_has_item(_id)) {
        return false;
    }

    var _progress = game_current_progress();
    struct_set(_progress.items, _id, true);
    global.profile.dirty = true;
    if (_trophy_id == "" || !game_trophy_unlock(_trophy_id)) {
        game_profile_save();
    }
    return true;
}
