game_controller = instance_find(obj_game, 0);
difficulty = game_campaign_difficulty();
if (difficulty < 0) {
    difficulty = 1;
}

// G67–68 change the first form's HP on the easiest and hardest settings.
var _health = [25, 50, 50, 150];
max_health = _health[difficulty];
hit_points = max_health;
show_boss_health = game_has_item("Scouter");
show_boss_timer = game_has_item("Timer");

fight_age = 0;
scene_steps = 0;
if (!struct_exists(global.run, "solgryn_route_seconds")) {
    global.run.solgryn_route_seconds = 0;
}
first_form_defeated = false;
shield_active = false;
target_x = 320;
target_y = 240;

view_left = -1;
view_top = -2;
shake_strength = 0;
shake_x = 0;
shake_y = 0;
blur_strength = 25;
blur_angle = 0;
flash_ink = 128;
arrival_age = -1;
arrival_sound = -1;
arrival_frame = 0;
history_surface = -1;
history_valid = false;

solgryn_shake = function(_strength) {
    shake_strength = _strength;
};

solgryn_blur = function(_strength, _angle = 0) {
    blur_strength = _strength;
    blur_angle = _angle;
};

solgryn_kick = function(_shake, _blur = 0) {
    if (_shake > 0) {
        solgryn_shake(_shake);
    }
    if (_blur > 0) {
        solgryn_blur(_blur);
    }
};

solgryn_flash = function(_ink = 0) {
    flash_ink = _ink;
};

solgryn_music_seek = function(_seconds, _resume = false) {
    var _track = game_controller.stage_music_instance;
    if (_track != -1) {
        if (_resume) {
            audio_resume_sound(_track);
        }
        audio_sound_set_track_position(_track, _seconds);
    }
};

solgryn_draw_history = function(_scene, _viewport, _mirror) {
    // PT_BlurAndAngle lets the preceding image show through the current one.
    var _width = game_controller.render_width;
    var _height = game_controller.render_height;
    if (!surface_exists(history_surface)) {
        history_surface = surface_create(_width, _height);
        history_valid = false;
    }
    if (surface_exists(history_surface)) {
        if (!history_valid) {
            surface_copy(history_surface, 0, 0, _scene);
            history_valid = true;
        } else if (surface_set_target(history_surface)) {
            gpu_set_blendenable(true);
            gpu_set_blendmode(bm_normal);
            draw_surface_ext(_scene, 0, 0, 1, 1, 0, c_white, solgryn_history_alpha);
            gpu_set_blendenable(false);
            surface_reset_target();
        }
        _scene = history_surface;
    }
    game_controller.draw_scene_surface(_scene, _viewport, _mirror);
};

solgryn_hud_in_scene = function() {
    return arrival_age >= 0 || (fight_age >= 3350 && fight_age < 4010
        && (game_controller.directional_blur_x != 0 || game_controller.directional_blur_y != 0));
};

draw_solgryn_health_bar = function(_left, _top, _scale) {
    var _fill = floor(639 * clamp(hit_points / max_health, 0, 1));
    if (_fill > 0) {
        draw_rectangle_color(_left, _top, _left + _fill * _scale - 1,
            _top + 9 * _scale - 1, c_white, c_white, c_white, c_white, false);
    }
};

draw_solgryn_readouts = function(_left, _top, _scale) {
    var _right = _left + 638 * _scale;
    if (global.settings.show_deaths) {
        var _deaths = game_current_progress().solgryn_deaths;
        var _death_text = string(_deaths) + (_deaths == 1 ? " death" : " deaths");
        var _death_scale = 1.5 * _scale;
        draw_boshy_text(_death_text, _left + 623 * _scale - string_length(_death_text) * 8 * _death_scale,
            _top + 32 * _scale, 1, _death_scale);
    }

    var _line_y = _top + 16 * _scale;
    if (show_boss_health) {
        var _health_text = string(hit_points) + " / " + string(max_health);
        draw_boshy_text(_health_text, _right - string_length(_health_text) * 8 * _scale, _line_y, 0.3, _scale);
        _line_y += 12 * _scale;
    }
    if (show_boss_timer) {
        var _time_text = string(global.run.solgryn_route_seconds) + " seconds";
        draw_boshy_text(_time_text, _right - string_length(_time_text) * 8 * _scale, _line_y, 0.3, _scale);
    }
};

take_player_shot = function(_shot) {
    if (_shot.reflected) {
        return false;
    }
    if (fight_age >= 5020 && solgryn_late_take_shot(_shot)) {
        return true;
    }
    if (victory_age >= 0 || hit_points <= 0 || fight_age <= 400 || !solgryn_actor_hit(_shot)) {
        return false;
    }

    // G684–685 and G891–892 distinguish a hit, shield retaliation, and an invulnerable pose.
    if (shield_active) {
        var _player = instance_find(obj_player, 0);
        if (_player != noone) {
            solgryn_early_hit(_player);
        }
        return true;
    }
    if (fight_age > 3300 && fight_age < 3990) {
        return false;
    }

    --hit_points;
    solgryn_actor_hit_flash(_shot);
    audio_play_sound(snd_mario_bump, 1, false);
    return true;
};

solgryn_actor_init();
solgryn_early_init();
solgryn_late_init();
solgryn_victory_setup();
