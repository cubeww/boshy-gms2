function shang_tsung_victory_setup() {
    victory_age = -1;
    victory_finish_scene_step = -1;
    victory_shade_ink = 128;
    victory_trophy_title = "";
    victory_trophy_age = -1;
    victory_clear_at_us = -1;
    victory_hide_boss = false;
    victory_audio = [];
}

function shang_tsung_victory_play_sound(_sound) {
    array_push(victory_audio, audio_play_sound(_sound, 1, false));
}

function shang_tsung_victory_clean_up() {
    for (var _i = 0; _i < array_length(victory_audio); ++_i) {
        audio_stop_sound(victory_audio[_i]);
    }
}

function shang_tsung_victory_burst() {
    // G800 and G809 inherit the defeated fighter's foreground layer.
    var _layer = "Foreground Effects";
    shang_spawn_attack(321, x, y, { attack_phase: 4 }, _layer);
    shang_spawn_attack(321, x - 29, y - 26, { attack_phase: 4 }, _layer);
    shang_spawn_attack(321, x + 47, y - 26, { attack_phase: 4 }, _layer);
    shang_spawn_attack(321, x + 11, y + 67, { attack_phase: 4 }, _layer);
}

function shang_tsung_victory_begin(_player) {
    if (_player == noone || _player.dead || victory_age >= 0) {
        return;
    }

    victory_age = 0;
    depth = layer_get_depth("Foreground Effects");
    shang_tsung_victory_burst();
    game_controller.start_stage_music(snd_shang_tsung_flawless_victory, false, false, 22050);
    shang_tsung_pose(29);
    boss_target_x = 550;
    boss_target_y = 800;
    visible = true;
    shake_strength = 50;
    blur_strength = 15;
    blur_angle = 0;
    shang_kill_attacks(338);
}

function shang_tsung_victory_take_shot(_bullet) {
    // G807 and G823 only select shots on the fighter's layer.
    if (victory_age < 150 || victory_age >= 350 || _bullet.depth != depth) {
        return false;
    }
    var _boss = id;
    var _overlap = false;
    with (_bullet) {
        _overlap = place_meeting(x, y, _boss);
    }
    if (!_overlap) {
        return false;
    }

    shang_blood_shards(_bullet.x, _bullet.y, 1, false, true, "Foreground Effects");
    audio_play_sound(snd_shang_tsung_blood_explode, 1, false);
    shang_tsung_pose(30);
    shake_strength += 2;
    blur_strength = 1;
    blur_angle = 0;
    return true;
}

function shang_tsung_victory_show_trophy(_title) {
    victory_trophy_title = _title;
    victory_trophy_age = 0;
    shang_tsung_victory_play_sound(snd_tutorial_achievement_obtain);
    shang_tsung_victory_play_sound(snd_tutorial_achievement_success);
}

function shang_tsung_victory_fire(_player) {
    // G806 shoots from the current action point, then moves the player for the next shot.
    var _character = _player.character;
    instance_create_layer(_player.x + _player.facing * _character.muzzle_x, _player.y + _character.muzzle_y,
        "Foreground Effects", obj_shang_tsung_fatality_bullet, { boss: id });
    with (obj_bullet) {
        depth = other.depth;
    }
    _player.facing = 1;
    _player.x = x - 400 - irandom(49);
    _player.y = y + irandom(49) - irandom(49) - 50;
    _player.refresh_collision_probes();
}

function shang_tsung_victory_step(_player, _seconds) {
    if (_player == noone || _player.dead || victory_age < 0 || victory_age >= 600) {
        return;
    }

    if (victory_trophy_age >= 0 && ++victory_trophy_age >= 226) {
        victory_trophy_age = -1;
    }
    // G577 evaluates its two-second timer only after the clear is pending.
    if (victory_clear_at_us >= 0 && game_controller.frame_elapsed_us >= victory_clear_at_us) {
        victory_clear_at_us = -1;
        shang_tsung_victory_show_trophy("FATALITY...");
    }

    // G801 pauses at 100 until the player presses the configured shoot button.
    if (victory_age != 100) {
        ++victory_age;
    }
    if (victory_age == 100 && !_player.input_locked && keyboard_check_pressed(global.settings.keys.shoot)) {
        victory_age = 105;
        _player.input_locked = true;
        _player.hsp = 0;
        _player.vsp = 0;
        game_controller.start_stage_music(snd_shang_tsung_fatality_music, false, false, 48000);
    }
    if (victory_age >= 105 && victory_shade_ink > 40) {
        victory_shade_ink -= 10;
    }
    if (victory_age >= 150 && victory_age < 300) {
        shang_tsung_victory_fire(_player);
    } else if (victory_age >= 300) {
        _player.x = 204;
        _player.y = 723;
        _player.refresh_collision_probes();
    }

    switch (victory_age) {
        case 99:
            victory_finish_scene_step = scene_steps;
            shang_tsung_victory_play_sound(snd_shang_tsung_finish_him);
            break;

        case 200:
            shang_tsung_victory_play_sound(snd_shang_tsung_fatality_scream);
            if (game_trophy_unlock("ShangTsung")) {
                victory_clear_at_us = game_controller.frame_elapsed_us + 2000000;
            }
            break;

        case 201:
            if (_seconds < 64 && game_trophy_unlock("ShangTsungSpeed")) {
                shang_tsung_victory_show_trophy("SHANG TSUNG\nSPEEDRUN!");
            }
            break;

        case 301:
            var _progress = game_current_progress();
            if (_seconds < _progress.shang_tsung_best_time) {
                _progress.shang_tsung_best_time = _seconds;
                global.profile.dirty = true;
                game_profile_save();
                shang_tsung_victory_play_sound(snd_hello_kitty_new_record);
            }
            break;

        case 350:
            shang_tsung_victory_play_sound(snd_biollante_explosion_final);
            shang_tsung_victory_burst();
            shang_tsung_flash();
            victory_hide_boss = true;
            break;

        case 420:
            shang_tsung_victory_play_sound(snd_shang_tsung_boshy_wins);
            break;

        case 500:
            shang_tsung_victory_play_sound(snd_shang_tsung_fatality_voice);
            break;

        case 600:
            // G816 advances to the ninth world at (719, 8553).
            if (!teleporter_rush_exit()) {
                room_goto(rm_kid_icarus);
            }
            break;
    }
}

function shang_tsung_victory_draw() {
    var _top = camera_get_view_y(view_camera[0]);
    if (victory_finish_scene_step >= 0) {
        var _frame = max(0, ((scene_steps - victory_finish_scene_step) * 65 - 1) div 100);
        if (_frame < sprite_get_number(spr_shang_tsung_finish_him)) {
            draw_sprite(spr_shang_tsung_finish_him, _frame, 320, 653);
        }
    }
    if (victory_age >= 420) {
        draw_sprite_ext(spr_shang_tsung_boshy_wins, 0, 320, 568, 3, 3, 0, c_white, 1);
    }
    if (victory_age >= 500) {
        var _elapsed = victory_age - 500;
        var _frame = max(0, (_elapsed * 20 - 1) div 100) mod sprite_get_number(spr_shang_tsung_fatality);
        draw_sprite(spr_shang_tsung_fatality, _frame, 254, 614);
    }
    if (victory_trophy_age >= 0) {
        // G835–846 move the greeting and icon while the banner stays anchored.
        var _age = victory_trophy_age;
        var _alpha = 1 - clamp((_age - 200) * 5, 0, 128) / 128;
        var _bounce_age = _age - _age mod 2;
        var _bounce = max(0, 15 - _bounce_age) * ((_bounce_age div 2 mod 2) == 0 ? 1 : -1);
        draw_sprite_ext(spr_tutorial_achievement_banner, 0, 434, _top + 16, 1, 1, 0, c_white, _alpha);
        draw_sprite_ext(spr_trophy_icon, 1, 440, _top + (_age < 15 ? 14 + _bounce : 13), 1, 1, 0, c_white, _alpha);

        var _lines = string_split(victory_trophy_title, "\n");
        var _text_y = _top + 17 + (39 - 12 * array_length(_lines)) div 2 + _bounce;
        var _remaining = _age + 1;
        for (var _i = 0; _i < array_length(_lines) && _remaining > 0; ++_i) {
            var _line = string_copy(_lines[_i], 1, _remaining);
            draw_boshy_text(_line, 619 - string_length(_line) * 8, _text_y + _i * 12, _alpha);
            _remaining -= string_length(_lines[_i]) + 1;
        }
    }
}
