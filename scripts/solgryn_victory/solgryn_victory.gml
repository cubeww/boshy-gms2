function solgryn_victory_setup() {
    victory_age = -1;
    victory_trophy_age = -1;
    victory_trophy_pending = false;
    victory_new_record = false;
    victory_audio = [];
}

function solgryn_victory_cleanup() {
    for (var _i = 0; _i < array_length(victory_audio); ++_i) {
        audio_stop_sound(victory_audio[_i]);
    }
}

function solgryn_victory_begin() {
    // G880–881 stop the attack schedule and queue the trophy and time check.
    fight_age = 900000;
    victory_age = 0;
    var _progress = game_current_progress();
    var _seconds = attempt_steps div 50;
    if (_seconds < _progress.solgryn_best_time) {
        _progress.solgryn_best_time = _seconds;
        global.profile.dirty = true;
        victory_new_record = true;
    }
    victory_trophy_pending = game_trophy_unlock("Solgryn");
    if (victory_new_record && !victory_trophy_pending) {
        game_profile_save();
    }
    array_push(victory_audio, audio_play_sound(snd_solgryn_victory_voice, 1, false));
    // G882 emits the first burst on the same step as G881.
    solgryn_victory_burst(x, y, true);
}

function solgryn_victory_step(_player) {
    if (victory_age < 0 || _player == noone || _player.dead) {
        return;
    }

    ++victory_age;
    if (victory_age == 1 && victory_new_record) {
        array_push(victory_audio, audio_play_sound(snd_hello_kitty_new_record, 1, false));
    }

    if (victory_trophy_age >= 0 && ++victory_trophy_age >= 226) {
        victory_trophy_age = -1;
    }
    // G583 presents a newly earned trophy on the next two-second timer pulse.
    if (victory_trophy_pending && scene_steps mod 100 == 0) {
        victory_trophy_pending = false;
        victory_trophy_age = 0;
        array_push(victory_audio, audio_play_sound(snd_tutorial_achievement_obtain, 1, false));
        array_push(victory_audio, audio_play_sound(snd_tutorial_achievement_success, 1, false));
    }

    // G882 creates one additive burst with the same lethal qualifier as its combat counterpart.
    solgryn_victory_burst(x, y, true);
    if (victory_age == 350) {
        // G883 advances to the separate explosion and rainbow scene on physical frame 46.
        if (!teleporter_rush_exit()) {
            room_goto(rm_solgryn_ending);
        }
    }
}

function solgryn_victory_burst(_x, _y, _hazard) {
    solgryn_early_explosion(_x + irandom(99) - irandom(99), _y + irandom(199) - irandom(199),
        "Attack Effects", _hazard);
}

function solgryn_victory_draw(_viewport) {
    if (victory_trophy_age < 0) {
        return;
    }
    var _left = _viewport.left;
    var _top = _viewport.top;
    var _scale = _viewport.width / 640;
    var _alpha = 1 - max(0, victory_trophy_age - 200) / 26;
    draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434 * _scale, _top + 14 * _scale,
        _scale, _scale, 0, c_white, _alpha);
    draw_sprite_part_ext(spr_trophy_icon, 1, 0, 6, 32, 32, _left + 440 * _scale, _top + 19 * _scale,
        _scale, _scale, c_white, _alpha);
    draw_boshy_text(string_copy("THE BOSHY!", 1, victory_trophy_age), _left + 543 * _scale, _top + 26 * _scale,
        _alpha, _scale);
}
