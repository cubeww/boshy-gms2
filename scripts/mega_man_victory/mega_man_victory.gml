function mega_man_victory_setup() {
    victory_age = -1;
    victory_trophy_title = "";
    victory_trophy_age = -1;
    victory_clear_trophy_pending = false;
}

function mega_man_victory_begin(_seconds) {
    if (victory_age >= 0) {
        return;
    }

    // G788 replaces the giant form with the small airborne pose at screen center.
    victory_age = 0;
    x = 323;
    y = 227;
    image_xscale = 1;
    image_yscale = 1;
    image_alpha = 1;
    image_angle = 0;
    mega_man_set_pose(16, 1);
    if (game_controller.stage_music_instance != -1) {
        audio_stop_sound(game_controller.stage_music_instance);
        game_controller.stage_music_instance = -1;
    }

    // G544–545 and G565–566 use the timer at the final hit, before the outro runs.
    var _progress = game_current_progress();
    if (_seconds < _progress.mega_man_best_time) {
        _progress.mega_man_best_time = _seconds;
        global.profile.dirty = true;
        game_profile_save();
        audio_play_sound(snd_hello_kitty_new_record, 1, false);
    }
    if (_seconds < 140 && game_trophy_unlock("MegaManSpeed")) {
        mega_man_victory_show_trophy("MegaMan Speedrun!");
    }
    victory_clear_trophy_pending = !game_trophy_is_unlocked("MegaMan");
}

function mega_man_victory_step() {
    if (victory_age < 750) {
        ++victory_age;
    }
    switch (victory_age) {
        case 50:
        case 100:
        case 130:
        case 160:
        case 175:
        case 190:
        case 200:
        case 205:
        case 210:
        case 215:
            // G790–799 use the difference of two random draws for each axis.
            mega_man_spawn_explosion(x + irandom(49) - irandom(49), y + irandom(49) - irandom(49));
            audio_play_sound(snd_green_greens_kracko_explosion, 1, false);
            shake_strength = 20;
            blur_strength = 10;
            blur_angle = 0;
            break;

        case 260:
            // G800 enlarges surviving explosions and replaces Mega Man with the death burst.
            with (obj_mega_man_ordnance) {
                if (ordnance_kind == MegaManOrdnance.Explosion) {
                    image_xscale = 3;
                    image_yscale = 3;
                }
            }
            audio_play_sound(snd_mega_man_victory_death, 1, false);
            shake_strength = 20;
            blur_strength = 20;
            blur_angle = 0;
            break;

        case 300:
            game_controller.start_stage_music(snd_mega_man_victory_music, false, false);
            break;

        case 750:
            // G802 enters the eighth world at (1032, 249).
            if (!teleporter_rush_exit()) {
                room_goto(rm_mega_man_world);
            }
            break;
    }

    if (victory_trophy_age >= 0 && ++victory_trophy_age >= 226) {
        victory_trophy_age = -1;
    }
    // G579 unlocks and announces the clear on the next two-second room timer pulse.
    if (victory_clear_trophy_pending && scene_steps mod 100 == 0) {
        victory_clear_trophy_pending = false;
        if (game_trophy_unlock("MegaMan")) {
            mega_man_victory_show_trophy("BoshyMan!");
        }
    }
}

function mega_man_victory_show_trophy(_title) {
    victory_trophy_title = _title;
    victory_trophy_age = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
}

function mega_man_victory_effects_draw() {
    if (victory_age >= 260 && victory_age < 295) {
        // The source burst plays 14 frames at 40% speed and then disappears.
        var _frame = max(0, ((victory_age - 260) * 40 - 1) div 100);
        draw_sprite(spr_mega_man_victory_burst, _frame, x, y);
    }
}

function mega_man_victory_draw() {
    if (victory_trophy_age < 0) {
        return;
    }

    // The original banner is in the scene, where shake and directional blur also affect it.
    var _alpha = 1 - max(0, victory_trophy_age - 200) / 26;
    draw_sprite_ext(spr_tutorial_achievement_banner, 0, 434, 7, 1, 1, 0, c_white, _alpha);
    draw_sprite_ext(spr_trophy_icon, 1, 438, 12, 0.5, 0.5, 0, c_white, _alpha);
    var _text = string_copy(victory_trophy_title, 1, victory_trophy_age);
    draw_boshy_text(_text, 628 - string_length(victory_trophy_title) * 8, 22, _alpha);
}
