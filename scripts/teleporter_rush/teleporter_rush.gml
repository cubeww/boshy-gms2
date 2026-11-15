function teleporter_rush_bosses() {
    static _bosses = ["HelloKitty", "Ryu", "Mario", "Biollante", "Sonic", "SkeletonKing",
        "MegaMan", "ShangTsung", "Ganon", "Missingno", "Solgryn"];
    return _bosses;
}

function teleporter_rush_unlocked() {
    // Fusion frame 28 G1203 removes the right wing barriers once these trophies reach 2.
    var _bosses = teleporter_rush_bosses();
    var _progress = game_current_progress();
    for (var _i = 0; _i < array_length(_bosses); ++_i) {
        if (!game_trophy_is_unlocked(_bosses[_i], _progress)) {
            return false;
        }
    }
    return true;
}

function teleporter_rush_active() {
    return struct_exists(global.run, "boss_rush") && global.run.boss_rush != "";
}

function teleporter_rush_begin(_key, _room, _x, _y) {
    // G1157–1192 jump immediately and use the native room start when both overrides are zero.
    game_travel_by_teleporter(_room, _x, _y, false, _key);
}

function teleporter_rush_step() {
    if (teleporter_rush_active() && frame_second_tick) {
        var _progress = game_current_progress();
        ++_progress.boss_rush_seconds;
        global.profile.dirty = true;
    }
}

function teleporter_rush_record_death() {
    if (teleporter_rush_active()) {
        var _progress = game_current_progress();
        struct_remove(_progress.boss_rush_clears, global.run.boss_rush);
        ++_progress.boss_rush_deaths;
        global.profile.dirty = true;
    }
}

function teleporter_rush_exit() {
    if (!teleporter_rush_active()) {
        return false;
    }
    var _progress = game_current_progress();
    struct_set(_progress.boss_rush_clears, global.run.boss_rush, true);
    global.profile.dirty = true;
    game_profile_save();
    teleporter_rush_return();
    return true;
}

function teleporter_rush_return() {
    // The native end-of-frame handler zeroes both position overrides and returns to the hub.
    var _run = global.run;
    var _saved_hub = _run.restart_run;
    if (!is_undefined(_saved_hub) && _saved_hub.room_id == rm_teleporter && _saved_hub.has_checkpoint) {
        _saved_hub.deaths = _run.deaths;
        _saved_hub.world_deaths = _run.world_deaths;
        _saved_hub.music_position = 0;
        global.run = _saved_hub;
        room_goto(rm_teleporter);
    } else {
        game_travel_by_teleporter(rm_teleporter, undefined, undefined, false);
    }
}

function teleporter_rush_reset() {
    var _progress = game_current_progress();
    _progress.boss_rush_clears = {};
    _progress.boss_rush_seconds = 0;
    _progress.boss_rush_deaths = 0;
    global.profile.dirty = true;
}

function teleporter_rush_complete() {
    // G1197 hides the submission block until every individual Rush result is a clear.
    var _clears = game_current_progress().boss_rush_clears;
    var _bosses = teleporter_rush_bosses();
    for (var _i = 0; _i < array_length(_bosses); ++_i) {
        if (!struct_exists(_clears, _bosses[_i])) {
            return false;
        }
    }
    return true;
}

function teleporter_rush_draw_score_line(_text, _x, _y) {
    var _length = string_length(_text);
    var _left = _x + (384 - _length * 11) div 2;
    for (var _i = 1; _i <= _length; ++_i) {
        var _glyph = ord(string_char_at(_text, _i)) - 32;
        draw_sprite_part(spr_teleporter_rush_score_font, 0, (_glyph mod 32) * 11, (_glyph div 32) * 20,
            11, 20, _left + (_i - 1) * 11, _y);
    }
}
