var _wrap_text = function(_text, _columns) {
    var _lines = [];
    var _paragraphs = string_split(string_replace_all(_text, "\r", ""), "\n");

    for (var _i = 0; _i < array_length(_paragraphs); ++_i) {
        var _remaining = _paragraphs[_i];
        while (string_length(_remaining) > _columns) {
            var _take = _columns;
            if (string_char_at(_remaining, _columns + 1) != " ") {
                // The original right alignment includes the trailing separator on a wrapped line.
                while (_take > 0 && string_char_at(_remaining, _take) != " ") {
                    --_take;
                }
                if (_take == 0) {
                    _take = _columns;
                }
            }
            array_push(_lines, string_copy(_remaining, 1, _take));
            _remaining = string_trim_start(string_delete(_remaining, 1, _take));
        }
        array_push(_lines, _remaining);
    }

    return _lines;
};

rows = [];
var _slot = game_menu_from_title() ? game_campaign_title_slot() : game_campaign_active_slot();
var _progress = is_undefined(_slot) ? global.profile.practice : _slot;
var _catalog = trophy_catalog();
var _unlocked_count = 0;
for (var _i = 0; _i < array_length(_catalog); ++_i) {
    var _trophy = _catalog[_i];
    var _unlocked = game_trophy_is_unlocked(_trophy.id, _progress);
    if (_unlocked) {
        ++_unlocked_count;
    }
    array_push(rows, {
        title_lines: _wrap_text(_trophy.title, 16),
        description_lines: _unlocked ? _wrap_text(_trophy.description, 18) : [],
        unlocked: _unlocked
    });
}

var _deaths = is_undefined(_slot) ? global.run.deaths : _slot.deaths;
var _time_us = is_undefined(_slot)
    ? (variable_global_exists("practice_play_time_us") ? global.practice_play_time_us : 0) : _slot.play_time_us;
var _seconds = floor(_time_us / 1000000);
var _hours = _seconds div 3600;
var _minutes = (_seconds div 60) mod 60;
var _total = array_length(rows);
statistics = "Deaths: " + string(_deaths)
    + "\nTime played: " + string(_hours) + ": " + string(_minutes) + ": " + string(_seconds mod 60)
    + "\n\n" + string(_unlocked_count) + "/" + string(_total) + "  trophies unlocked"
    + "\n" + string(round(100 * _unlocked_count / _total)) + "% unlocked";

selected_row = 0;
marker_y = 171;
repeat_direction = 0;
held_steps = 0;
age_steps = 0;
title_scale = 0.1;
var _game = instance_find(obj_game, 0);
_game.start_stage_music(snd_options_music, true, false, 44100);
