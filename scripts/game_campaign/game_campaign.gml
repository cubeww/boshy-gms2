function game_campaign_empty_slot() {
    return {
        stage: "", difficulty: -1, deaths: 0, world_deaths: 0, play_time_us: 0,
        has_checkpoint: false, x: 32, y: 32, checkpoint_gravity: 1, checkpoint_gravity_flip: false,
        desert_snake: false, desert_switch: false,
        trophies: {}, items: {}, hello_kitty_best_time: 9999, ryu_best_time: 9999, mario_best_time: 9999,
        biollante_best_time: 9999, sonic_best_time: 9999, skeleton_king_best_time: 9999, mega_man_best_time: 9999,
        shang_tsung_best_time: 9999, shang_tsung_deaths: 0, bomberman_deaths: 0,
        missingno_best_time: 9999, missingno_deaths: 0,
        solgryn_best_time: 9999, solgryn_deaths: 0, credits_seen: false,
        exploration: {}, teleporter_unlocked: false, boss_rush_clears: {}, boss_rush_seconds: 0, boss_rush_deaths: 0,
        vvvvvv_gravity: 1, vvvvvv_gravity_flip: false,
        gastly_dismissed: true, mega_man_world_cue_played: false, ninja_gaiden_cd: 0
    };
}

function game_campaign_stage_key(_room) {
    switch (_room) {
        case rm_tutorial: return "tutorial";
        case rm_prehistorik: return "prehistorik";
        case rm_hello_kitty: return "hello_kitty";
        case rm_green_greens: return "green_greens";
        case rm_king_dedede: return "king_dedede";
        case rm_ryu: return "ryu";
        case rm_cheetahmen: return "cheetahmen";
        case rm_gastly: return "gastly";
        case rm_mario: return "mario";
        case rm_vvvvvv: return "vvvvvv";
        case rm_biollante: return "biollante";
        case rm_wario: return "wario";
        case rm_sanicz: return "sanicz";
        case rm_castlevania: return "castlevania";
        case rm_gradius: return "gradius";
        case rm_skeleton_king: return "skeleton_king";
        case rm_milon: return "milon";
        case rm_milon_depths: return "milon_depths";
        case rm_mega_man: return "mega_man";
        case rm_mega_man_world: return "mega_man_world";
        case rm_shang_tsung: return "shang_tsung";
        case rm_kid_icarus: return "kid_icarus";
        case rm_bomberman: return "bomberman";
        case rm_ninja_gaiden: return "ninja_gaiden";
        case rm_missingno: return "missingno";
        case rm_desert: return "desert";
        case rm_desert_secret: return "desert_secret";
        case rm_final_path: return "final_path";
        case rm_solgryn: return "solgryn";
        case rm_credits: return "credits";
        case rm_prize_room: return "prize_room";
        case rm_teleporter: return "teleporter";
    }
    return "";
}

function game_campaign_stage_room(_stage) {
    switch (_stage) {
        case "tutorial": return rm_tutorial;
        case "prehistorik": return rm_prehistorik;
        case "hello_kitty": return rm_hello_kitty;
        case "green_greens": return rm_green_greens;
        case "king_dedede": return rm_king_dedede;
        case "ryu": return rm_ryu;
        case "cheetahmen": return rm_cheetahmen;
        case "gastly": return rm_gastly;
        case "mario": return rm_mario;
        case "vvvvvv": return rm_vvvvvv;
        case "biollante": return rm_biollante;
        case "wario": return rm_wario;
        case "sanicz": return rm_sanicz;
        case "castlevania": return rm_castlevania;
        case "gradius": return rm_gradius;
        case "skeleton_king": return rm_skeleton_king;
        case "milon": return rm_milon;
        case "milon_depths": return rm_milon_depths;
        case "mega_man": return rm_mega_man;
        case "mega_man_world": return rm_mega_man_world;
        case "shang_tsung": return rm_shang_tsung;
        case "kid_icarus": return rm_kid_icarus;
        case "bomberman": return rm_bomberman;
        case "ninja_gaiden": return rm_ninja_gaiden;
        case "missingno": return rm_missingno;
        case "desert": return rm_desert;
        case "desert_secret": return rm_desert_secret;
        case "final_path": return rm_final_path;
        case "solgryn": return rm_solgryn;
        case "credits": return rm_credits;
        case "prize_room": return rm_prize_room;
        case "teleporter": return rm_teleporter;
    }
    return noone;
}

function game_campaign_read_slots() {
    var _slots = [game_campaign_empty_slot(), game_campaign_empty_slot(), game_campaign_empty_slot()];
    for (var _i = 0; _i < array_length(_slots); ++_i) {
        var _section = "Campaign " + string(_i + 1);
        var _stage = ini_read_string(_section, "Stage", "");
        var _difficulty = ini_read_real(_section, "Difficulty", -1);
        var _room = game_campaign_stage_room(_stage);
        if (_room == noone || _difficulty < 0
            || _difficulty > 3 || _difficulty != floor(_difficulty)) {
            continue;
        }

        var _slot = _slots[_i];
        _slot.stage = _stage;
        _slot.difficulty = _difficulty;
        _slot.deaths = game_profile_read_total("Deaths", _section);
        _slot.world_deaths = game_profile_read_total("WorldDeaths", _section);
        _slot.desert_switch = ini_read_real(_section, "DesertSwitch", 0) == 1;
        _slot.play_time_us = game_profile_read_total("PlayTimeUS", _section);
        game_profile_read_progress(_slot, _section);
        if (ini_read_real(_section, "ExplorationRecorded", 0) == 0) {
            teleporter_restore_legacy_exploration(_slot, _room);
        }
        var _x = ini_read_real(_section, "CheckpointX", 32);
        var _y = ini_read_real(_section, "CheckpointY", 32);
        var _width = 9000;
        if (_room == rm_ninja_gaiden || _room == rm_teleporter) {
            var _room_info = room_get_info(_room, false, false, false, false, false);
            _width = _room_info.width;
        }
        if (ini_read_real(_section, "HasCheckpoint", 0) == 1
            && _x >= -640 && _x < _width && _y >= -480 && _y < 9000) {
            _slot.has_checkpoint = true;
            _slot.x = _x;
            _slot.y = _y;
            if (_stage == "vvvvvv") {
                _slot.checkpoint_gravity = ini_read_real(_section, "CheckpointGravity", 1) == -1 ? -1 : 1;
                _slot.checkpoint_gravity_flip = ini_read_real(_section, "CheckpointGravityFlip", 0) == 1;
                _slot.vvvvvv_gravity = _slot.checkpoint_gravity;
                _slot.vvvvvv_gravity_flip = _slot.checkpoint_gravity_flip;
            }
            if (_stage == "desert") {
                _slot.desert_snake = ini_read_real(_section, "DesertSnake", 0) == 1;
            }
        }
    }
    return _slots;
}

function game_campaign_write_slots(_slots) {
    for (var _i = 0; _i < array_length(_slots); ++_i) {
        var _section = "Campaign " + string(_i + 1);
        var _slot = _slots[_i];
        if (_slot.stage == "") {
            ini_section_delete(_section);
            ini_section_delete(_section + " Achievements");
            ini_section_delete(_section + " Collectables");
            ini_section_delete(_section + " Exploration");
            ini_section_delete(_section + " Boss Rush");
            continue;
        }
        ini_write_string(_section, "Stage", _slot.stage);
        ini_write_real(_section, "Difficulty", _slot.difficulty);
        ini_write_string(_section, "Deaths", string_format(_slot.deaths, 0, 0));
        ini_write_string(_section, "WorldDeaths", string_format(_slot.world_deaths, 0, 0));
        ini_write_string(_section, "PlayTimeUS", string_format(_slot.play_time_us, 0, 0));
        ini_write_real(_section, "HasCheckpoint", _slot.has_checkpoint ? 1 : 0);
        ini_write_real(_section, "CheckpointX", _slot.x);
        ini_write_real(_section, "CheckpointY", _slot.y);
        if (_slot.stage == "vvvvvv") {
            ini_write_real(_section, "CheckpointGravity", _slot.checkpoint_gravity);
            ini_write_real(_section, "CheckpointGravityFlip", _slot.checkpoint_gravity_flip ? 1 : 0);
        }
        ini_write_real(_section, "DesertSwitch", _slot.desert_switch ? 1 : 0);
        if (_slot.stage == "desert") {
            ini_write_real(_section, "DesertSnake", _slot.desert_snake ? 1 : 0);
        }
        game_profile_write_progress(_slot, _section);
    }
}

function game_campaign_active_slot() {
    if (!variable_global_exists("active_campaign_slot") || global.active_campaign_slot < 0) {
        return undefined;
    }
    return global.profile.campaign_slots[global.active_campaign_slot];
}

function game_campaign_title_slot() {
    return global.profile.campaign_slots[global.profile.title_slot];
}

function game_campaign_select_title_slot(_slot) {
    if (global.profile.title_slot != _slot) {
        global.profile.title_slot = _slot;
        global.profile.dirty = true;
    }
}

function game_campaign_difficulty() {
    var _slot = game_campaign_active_slot();
    return is_undefined(_slot) ? -1 : _slot.difficulty;
}

function game_campaign_difficulty_name(_difficulty) {
    static _names = ["Ez-mode", "Totally Average-mode", "Hardon-mode", "You're gonna rage-mode"];
    return _difficulty < 0 ? "Practice" : _names[_difficulty];
}

function game_campaign_sync(_save_position) {
    var _slot = game_campaign_active_slot();
    var _stage = game_campaign_stage_key(global.run.room_id);
    if (is_undefined(_slot) || _stage == "") {
        return false;
    }
    _slot.deaths = global.run.deaths;
    _slot.world_deaths = global.run.world_deaths;
    if (_save_position) {
        _slot.stage = _stage;
        _slot.has_checkpoint = global.run.has_checkpoint;
        _slot.x = global.run.checkpoint_x;
        _slot.y = global.run.checkpoint_y;
        if (_stage == "vvvvvv") {
            _slot.checkpoint_gravity = global.run.checkpoint_gravity;
            _slot.checkpoint_gravity_flip = global.run.checkpoint_gravity_flip;
        }
        if (global.run.room_id == rm_desert) {
            _slot.desert_snake = global.run.desert_snake;
            _slot.desert_switch = global.run.desert_checkpoint_switch;
        }
    }
    global.profile.dirty = true;
    return true;
}

function game_start_campaign(_slot, _difficulty = undefined) {
    var _slots = global.profile.campaign_slots;
    if (_slot < 0 || _slot >= array_length(_slots)) {
        return;
    }
    var _save = _slots[_slot];
    if (_save.stage == "") {
        if (is_undefined(_difficulty) || _difficulty < 0 || _difficulty > 3 || _difficulty != floor(_difficulty)) {
            return;
        }
        _save.stage = "tutorial";
        _save.difficulty = _difficulty;
        global.profile.dirty = true;
    }

    var _room = game_campaign_stage_room(_save.stage);
    global.active_campaign_slot = _slot;
    game_campaign_select_title_slot(_slot);
    game_profile_save();
    global.menu_from_title = false;
    global.run = {
        room_id: _room,
        deaths: _save.deaths,
        world_deaths: _save.world_deaths,
        has_checkpoint: _save.has_checkpoint,
        checkpoint_x: _save.x,
        checkpoint_y: _save.y,
        checkpoint_gravity: _save.checkpoint_gravity,
        checkpoint_gravity_flip: _save.checkpoint_gravity_flip,
        desert_snake: _save.desert_snake,
        desert_switch: _save.desert_switch,
        desert_checkpoint_switch: _save.desert_switch,
        boss_entry_steps: 0,
        music_position: 0,
        ryu_entry_y: undefined,
        gastly_return_run: undefined,
        gradius_return_run: undefined,
        restart_run: undefined
    };
    room_goto(_room);
}

function game_enter_ryu(_entry_y) {
    global.run.ryu_entry_y = _entry_y;
    room_goto(rm_ryu);
}

function game_ryu_entry_position() {
    var _entry_y = global.run.ryu_entry_y;
    return is_undefined(_entry_y) ? { x: 47, y: 425 } : { x: 24, y: _entry_y };
}

function game_return_from_gastly(_x, _y) {
    var _run = global.run;
    var _return_run = _run.gastly_return_run;
    if (!is_undefined(_return_run)) {
        _return_run.deaths = _run.deaths;
        _return_run.world_deaths = _run.world_deaths;
        _return_run.music_position = 0;
        global.run = _return_run;
    }
    global.cheetahmen_return_position = { x: _x, y: _y };
    room_goto(rm_cheetahmen);
}

function game_delete_campaign_slot(_slot) {
    var _slots = global.profile.campaign_slots;
    if (_slot < 0 || _slot >= array_length(_slots) || _slots[_slot].stage == "") {
        return;
    }
    _slots[_slot] = game_campaign_empty_slot();
    global.profile.campaign_slots = _slots;
    global.profile.dirty = true;
    game_profile_save();
}

function game_open_title_menu(_room) {
    global.menu_from_title = true;
    room_goto(_room);
}

function game_menu_from_title() {
    return variable_global_exists("menu_from_title") && global.menu_from_title;
}

function game_go_to_title() {
    global.active_campaign_slot = -1;
    global.menu_from_title = false;
    global.title_return = true;
    room_goto(rm_title);
}

function game_return_from_menu() {
    if (game_menu_from_title()) {
        game_go_to_title();
        return;
    }
    var _run = global.run;
    if (room == rm_options && (_run.room_id == rm_credits || _run.room_id == rm_prize_room
        || _run.room_id == rm_teleporter || struct_exists(_run, "teleporter_entry"))
        && !_run.has_checkpoint && !is_undefined(_run.restart_run)) {
        // Fusion Options G364 returns to the last saved frame.
        var _checkpoint_run = _run.restart_run;
        _checkpoint_run.deaths = _run.deaths;
        _checkpoint_run.world_deaths = _run.world_deaths;
        _checkpoint_run.music_position = 0;
        global.run = _checkpoint_run;
    }
    room_goto(global.run.room_id);
}

function game_take_title_return() {
    var _returning = variable_global_exists("title_return") && global.title_return;
    global.title_return = false;
    return _returning;
}
