function gradius_return_to_castlevania() {
    var _run = global.run;
    var _return_run = _run.gradius_return_run;
    if (!is_undefined(_return_run)) {
        _return_run.deaths = _run.deaths;
        _return_run.world_deaths = _run.world_deaths;
        _return_run.music_position = 0;
        global.run = _return_run;
    }

    // Group 980 leaves the campaign checkpoint in place and sets a one-time arrival position.
    global.castlevania_return_position = { x: 5773, y: 1367 };
    room_goto(rm_castlevania);
}

function gradius_start_audio() {
    var _game = instance_find(obj_game, 0);
    _game.start_stage_music(snd_gradius_music);
    return play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
}

function gradius_stop_audio(_entrance_sound) {
    if (_entrance_sound != -1) {
        audio_stop_sound(_entrance_sound);
    }
}

function gradius_fail(_x, _y) {
    var _game = instance_find(obj_game, 0);
    var _character = game_character_definition(global.profile.character_id);
    if (is_undefined(_character)) {
        _character = boshy_character();
    }
    _game.show_player_death(_x, _y, depth, _character);
}
