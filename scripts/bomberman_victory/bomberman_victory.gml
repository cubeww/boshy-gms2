function bomberman_victory_setup() {
    victory_age = -1;
    victory_trophy_age = -1;
    victory_trophy_pending = false;
    victory_audio = [];
}

function bomberman_victory_play_sound(_sound) {
    array_push(victory_audio, audio_play_sound(_sound, 1, false));
}

function bomberman_victory_cleanup() {
    for (var _i = 0; _i < array_length(victory_audio); ++_i) {
        audio_stop_sound(victory_audio[_i]);
    }
}

function bomberman_victory_begin() {
    // G1124 starts the defeat counter and removes the active attacks listed by Fusion.
    victory_age = 0;
    bomberman_attacks_clear();
    if (game_controller.stage_music_instance != -1) {
        audio_stop_sound(game_controller.stage_music_instance);
        game_controller.stage_music_instance = -1;
    }
}

function bomberman_victory_step(_player) {
    if (victory_age < 0 || victory_age >= 1000) {
        return;
    }

    ++victory_age;
    if (victory_age == 1) {
        // G1125 switches to the defeated pose before the first explosion.
        bomberman_pose(18);
        bomberman_victory_play_sound(snd_bomberman_victory_voice);
        bomberman_victory_play_sound(snd_bomberman_burst);
    }
    if (victory_age <= 250) {
        // G1126–1128 build up camera shake, with alternate-step bursts at the boss hotspot.
        shake_strength = victory_age * 0.1;
        if (scene_steps mod 10 == 0) {
            bomberman_victory_play_sound(snd_bomberman_explosion);
        }
        if (victory_age mod 2 == 0) {
            // G1128 draws the new burst in front of Ganon, beneath Layer 3's clouds.
            instance_create_depth(x + irandom(79) - irandom(79), y + irandom(79) - irandom(79), depth - 1,
                obj_bomberman_victory_explosion);
        }
    }

    var _alive = _player != noone && !_player.dead;
    if (victory_age == 250 && _alive) {
        // G1129 and G1132 hide Ganon and credit the clear on the same step.
        bomberman_victory_play_sound(snd_bomberman_victory_explosion);
        visible = false;
        victory_trophy_pending = game_trophy_unlock("Ganon");
    }
    if (victory_age == 400 && _alive) {
        var _gain = global.settings.music_volume / 100;
        array_push(victory_audio, audio_play_sound(snd_bomberman_victory_cue, 0, false, _gain));
    }
    if (victory_age == 1000 && _alive) {
        // G1131 targets Fusion handle 32, Ninja Gaiden, at (44, 430).
        if (!teleporter_rush_exit()) {
            room_goto(rm_ninja_gaiden);
        }
    }

    if (victory_trophy_age >= 0 && ++victory_trophy_age >= 226) {
        victory_trophy_age = -1;
    }
    // G580 announces the saved trophy on the next two-second room pulse.
    if (victory_trophy_pending && scene_steps mod 100 == 0) {
        victory_trophy_pending = false;
        victory_trophy_age = 0;
        bomberman_victory_play_sound(snd_tutorial_achievement_obtain);
        bomberman_victory_play_sound(snd_tutorial_achievement_success);
    }
}

function bomberman_victory_draw() {
    if (victory_age >= 3 && victory_age <= 7) {
        // The playthrough shows five full-screen gray frames at the start of the defeat.
        var _camera = camera_get_active();
        var _left = camera_get_view_x(_camera);
        var _top = camera_get_view_y(_camera);
        draw_set_color(make_color_rgb(181, 181, 181));
        draw_rectangle(_left, _top, _left + camera_get_view_width(_camera),
            _top + camera_get_view_height(_camera), false);
        draw_set_color(c_white);
    }
    if (victory_trophy_age >= 0) {
        var _alpha = 1 - max(0, victory_trophy_age - 200) / 26;
        var _title = "IT IS WRITTEN...";
        draw_sprite_ext(spr_tutorial_achievement_banner, 0, 433, 14, 1, 1, 0, c_white, _alpha);
        draw_sprite_part_ext(spr_trophy_icon, 1, 0, 6, 32, 32, 439, 19, 1, 1, c_white, _alpha);
        draw_boshy_text(string_copy(_title, 1, victory_trophy_age), 490, 24, _alpha);
    }
}
