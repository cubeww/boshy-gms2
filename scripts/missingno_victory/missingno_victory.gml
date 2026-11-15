function missingno_victory_setup() {
    victory_age = -1;
    victory_trophy_age = -1;
    victory_trophy_text = "";
    victory_clear_at_us = -1;
    victory_speed_pending = false;
    victory_new_record = false;
    victory_audio = [];
}

function missingno_victory_play_sound(_sound) {
    array_push(victory_audio, audio_play_sound(_sound, 1, false));
}

function missingno_victory_cleanup() {
    for (var _i = 0; _i < array_length(victory_audio); ++_i) {
        audio_stop_sound(victory_audio[_i]);
    }
}

function missingno_victory_begin(_player, _seconds) {
    // G710–713 end the attack cycle when HP reaches zero.
    victory_age = 0;
    missingno_attacks_clear();
    if (game_controller.stage_music_instance != -1) {
        audio_stop_sound(game_controller.stage_music_instance);
        game_controller.stage_music_instance = -1;
    }
    if (_player != noone && !_player.dead) {
        _player.input_locked = false;
    }
    set_read_sign("Wild MISSINGO. fainted!");

    var _progress = game_current_progress();
    if (_seconds < _progress.missingno_best_time) {
        _progress.missingno_best_time = _seconds;
        global.profile.dirty = true;
        victory_new_record = true;
    }
    if (game_trophy_unlock("Missingno")) {
        victory_clear_at_us = game_controller.frame_elapsed_us + 2000000;
    }
    victory_speed_pending = _seconds < 64 && game_trophy_unlock("MissingnoSpeed");
    if (victory_new_record) {
        game_profile_save();
    }
}

function missingno_victory_announce(_text) {
    victory_trophy_text = _text;
    victory_trophy_age = 0;
    missingno_victory_play_sound(snd_tutorial_achievement_obtain);
    missingno_victory_play_sound(snd_tutorial_achievement_success);
}

function missingno_victory_step() {
    if (victory_age < 0 || victory_age >= 600) {
        return;
    }
    ++victory_age;

    if (victory_trophy_age >= 0 && ++victory_trophy_age >= 226) {
        victory_trophy_age = -1;
    }
    if (victory_age == 1) {
        // G568 and G588 evaluate the recorded time after the defeat event.
        if (victory_new_record) {
            missingno_victory_play_sound(snd_hello_kitty_new_record);
        }
        if (victory_speed_pending) {
            missingno_victory_announce("MISSINGNO\nSPEEDRUN!");
        }
    }
    // G602 starts its two-second timer once the clear is pending.
    if (victory_clear_at_us >= 0 && game_controller.frame_elapsed_us >= victory_clear_at_us) {
        victory_clear_at_us = -1;
        missingno_victory_announce("CHECK YOUR 6TH\nITEM");
    }

    // G714 spawns an additive burst at the boss with a new angle every five steps.
    if (victory_age < 80 && victory_age mod 5 == 0) {
        var _x = x + irandom(31) - irandom(31);
        var _y = y + irandom(63) - irandom(63);
        instance_create_layer(_x, _y, "Hazards", obj_missingno_victory_blast, { image_angle: irandom(359) });
        missingno_victory_play_sound(snd_green_greens_kracko_explosion);
        shake_strength = 20;
        set_screen_blur(2);
    }
    if (victory_age >= 80) {
        target_y += 2;
        image_angle = -15;
    }
    switch (victory_age) {
        case 80:
            missingno_victory_play_sound(snd_missingno_victory_scream);
            break;
        case 210:
            // The same boss-relative emitter is enlarged as the sprite falls below the view.
            instance_create_layer(x, y, "Hazards", obj_missingno_victory_blast,
                { image_xscale: 3, image_yscale: 3 });
            missingno_victory_play_sound(snd_missingno_victory_final_blast);
            visible = false;
            break;
        case 250:
            game_controller.start_stage_music(snd_gastly_victory_music, false, false);
            break;
        case 600:
            // G719 jumps to storyboard handle 37 (Desert, index 34) at (47, 377).
            if (game_controller.stage_music_instance != -1) {
                audio_stop_sound(game_controller.stage_music_instance);
                game_controller.stage_music_instance = -1;
            }
            if (!teleporter_rush_exit()) {
                global.run.solgryn_route_seconds = game_controller.frame_seconds - timer_reset_second;
                room_goto(rm_desert);
            }
            break;
    }
}

function missingno_victory_draw(_viewport) {
    var _left = _viewport.left;
    var _top = _viewport.top;
    var _scale = _viewport.width / 640;
    if (victory_trophy_age >= 0) {
        var _alpha = 1 - max(0, victory_trophy_age - 200) / 26;
        draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434 * _scale, _top + 16 * _scale,
            _scale, _scale, 0, c_white, _alpha);
        draw_sprite_part_ext(spr_trophy_icon, 1, 0, 6, 32, 32, _left + 440 * _scale, _top + 21 * _scale,
            _scale, _scale, c_white, _alpha);
        var _lines = string_split(victory_trophy_text, "\n");
        var _letters = victory_trophy_age;
        for (var _i = 0; _i < array_length(_lines) && _letters > 0; ++_i) {
            var _line = _lines[_i];
            var _length = string_length(_line);
            draw_boshy_text(string_copy(_line, 1, _letters), _left + (621 - 8 * _length) * _scale,
                _top + (20 + 12 * _i) * _scale, _alpha, _scale);
            _letters -= _length;
        }
    }
}
