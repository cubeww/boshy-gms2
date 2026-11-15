function biollante_victory_setup() {
    victory_age = -1;
    victory_hide_boss = false;
    victory_fanfare = -1;
    victory_blast_delay = 45;
    victory_blast_steps = 0;
    victory_blasts = [];
    victory_zoom_width = 640;
    victory_trophy_text = "";
    victory_trophy_age = -1;
    victory_clear_trophy_pending = false;
}

function biollante_victory_begin(_player, _seconds) {
    if (victory_age >= 0) {
        return;
    }

    // Group 753 interrupts the fight and starts Biollante's death pose.
    victory_age = 0;
    x = 506;
    y = 346;
    image_angle = 0;
    biollante_set_pose(spr_biollante_anim_16_left, true);
    biollante_attacks_clear();
    if (game_controller.stage_music_instance != -1) {
        audio_stop_sound(game_controller.stage_music_instance);
        game_controller.stage_music_instance = -1;
    }
    audio_play_sound(snd_biollante_roar_alt, 1, false);

    if (_player != noone) {
        _player.x = 72;
        _player.y = 255;
        _player.hsp = 0;
        _player.vsp = 0;
        _player.input_locked = true;
        _player.refresh_collision_probes();
    }

    // The record and speed award use the elapsed seconds at the last hit.
    var _progress = game_current_progress();
    if (_seconds < _progress.biollante_best_time) {
        _progress.biollante_best_time = _seconds;
        global.profile.dirty = true;
        audio_play_sound(snd_hello_kitty_new_record, 1, false);
    }
    if (_seconds < 73 && game_trophy_unlock("BiollanteSpeed")) {
        biollante_victory_show_trophy("Biollante\nSpeedrun!");
    }
    victory_clear_trophy_pending = game_trophy_unlock("Biollante");
    game_profile_save();
}

function biollante_victory_show_trophy(_title) {
    victory_trophy_text = _title;
    victory_trophy_age = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
}

function biollante_victory_step(_player) {
    ++victory_age;
    if (!victory_hide_boss) {
        // Group 756 holds the player at the same coordinates until the final blast.
        if (_player != noone) {
            _player.x = 72;
            _player.y = 255;
            _player.refresh_collision_probes();
        }

        // Groups 754–757 reduce the interval after each blast until Biollante breaks apart.
        if (++victory_blast_steps >= max(4, victory_blast_delay)) {
            array_push(victory_blasts, {
                x: x + irandom(99) - irandom(99),
                y: y + irandom(99) - irandom(49),
                start: victory_age,
                scale: 2
            });
            audio_play_sound(snd_king_dedede_explosion, 1, false);
            victory_blast_steps = 0;
            victory_blast_delay -= 5;
            victory_zoom_width = 300 + irandom(119);
            view_center_x = x - 50;
            view_center_y = y - 20;
            if (victory_blast_delay <= -15) {
                victory_hide_boss = true;
                victory_zoom_width = 640;
                view_center_x = 320;
                view_center_y = 240;
                audio_play_sound(snd_biollante_explosion_final, 1, false);
                audio_play_sound(snd_biollante_roar, 1, false);
                game_controller.start_stage_music(snd_biollante_victory_music, false, false, 22050);
                victory_fanfare = game_controller.stage_music_instance;
                if (_player != noone) {
                    _player.input_locked = false;
                }
            }
        }
    } else if (victory_fanfare == -1 || !audio_is_playing(victory_fanfare)) {
        // Group 759 hands off to Wario at (32, 1097) when the fanfare ends.
        if (!teleporter_rush_exit()) {
            room_goto(rm_wario);
        }
        return;
    }

    view_width = lerp(view_width, victory_zoom_width, 0.2);
    if (abs(view_width - victory_zoom_width) < 1) {
        view_width = victory_zoom_width;
    }

    // Groups 793–794 count the creation step before removing each flash at twenty.
    for (var _i = array_length(victory_blasts) - 1; _i >= 0; --_i) {
        var _blast = victory_blasts[_i];
        if (victory_age - _blast.start >= 19) {
            array_delete(victory_blasts, _i, 1);
        } else {
            _blast.scale = 2 + (irandom(19) - irandom(19)) * 0.02;
        }
    }

    if (victory_trophy_age >= 0 && ++victory_trophy_age >= 226) {
        victory_trophy_age = -1;
    }
    // Group 574 displays the defeat award at the next two-second timer pulse.
    if (victory_clear_trophy_pending && scene_steps mod 100 == 0) {
        victory_clear_trophy_pending = false;
        biollante_victory_show_trophy("Mutated Godzilla?\n:/");
    }
}

function biollante_victory_draw() {
    if (array_length(victory_blasts) == 0) {
        return;
    }

    gpu_set_blendmode(bm_add);
    for (var _i = 0; _i < array_length(victory_blasts); ++_i) {
        var _blast = victory_blasts[_i];
        draw_sprite_ext(spr_hello_kitty_death_flash, 0, _blast.x, _blast.y, _blast.scale, _blast.scale,
            0, c_white, 1);
    }
    gpu_set_blendmode(bm_normal);
}

function biollante_victory_draw_hud() {
    var _viewport = game_controller.get_viewport_rectangle();
    if (is_undefined(_viewport)) {
        return;
    }
    var _left = _viewport.left;
    var _top = _viewport.top;
    var _scale = _viewport.width / game_controller.render_width;

    if (victory_trophy_age >= 0) {
        var _alpha = 1 - max(0, victory_trophy_age - 200) / 26;
        draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434 * _scale, _top + 7 * _scale,
            _scale, _scale, 0, c_white, _alpha);
        draw_sprite_ext(spr_trophy_icon, 1, _left + 438 * _scale, _top + 12 * _scale,
            0.5 * _scale, 0.5 * _scale, 0, c_white, _alpha);
        var _lines = string_split(victory_trophy_text, "\n");
        var _letters = victory_trophy_age;
        for (var _line = 0; _line < array_length(_lines) && _letters > 0; ++_line) {
            var _text = _lines[_line];
            var _length = string_length(_text);
            draw_boshy_text(string_copy(_text, 1, _letters),
                _left + (628 - _length * 8) * _scale, _top + (17 + 12 * _line) * _scale, _alpha, _scale);
            _letters -= _length;
        }
    }
}
