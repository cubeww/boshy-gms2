game_controller = instance_find(obj_game, 0);
var _catalog = dresser_catalog();
portraits = [];
hidden_portrait = undefined;
selected_slot = 0;
for (var _i = 0; _i < array_length(_catalog); ++_i) {
    var _entry = _catalog[_i];
    var _status = game_character_status(_entry);
    var _hidden_slot = struct_exists(_entry, "unlocked_x");
    var _portrait = {
        entry: _entry,
        status: _status,
        center_x: _hidden_slot ? _entry.unlocked_x : _entry.x,
        half_width: _entry.id == 88 ? 32 : 16,
        scale: 1
    };
    if (_hidden_slot && _status == "locked") {
        hidden_portrait = _portrait;
        continue;
    }

    if (_entry.id == global.profile.character_id && _status == "available") {
        selected_slot = array_length(portraits);
    }
    array_push(portraits, _portrait);
}
keyboard_string = "";

var _selected = portraits[selected_slot];
preview_character = game_character_definition(_selected.entry.id);
preview_frame = 0;
preview_sound = -1;
selection_x = _selected.center_x;
selection_y = _selected.entry.y;
selection_angle = 0;
spotlight_alpha = 0;
hovered_slot = -1;
notice = "";
notice_steps = 0;
elapsed_steps = 0;

fire_positions = [0, 32, 80, 128, 176, 240, 320, 368, 432, 496, 544, -80, 240, 384, 480];
fire_rates = [];
for (var _i = 0; _i < array_length(fire_positions); ++_i) {
    array_push(fire_rates, irandom_range(25, 64) / 100);
}
music_instance = audio_play_sound(snd_options_music, 0, true, global.settings.music_volume / 100);
