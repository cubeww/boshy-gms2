restore_saved_display = !variable_global_exists("settings");
if (restore_saved_display) {
    global.settings = game_settings_load();
}
if (!variable_global_exists("profile")) {
    global.profile = game_profile_load();
}
if (!variable_global_exists("debug_overlay_visible")) {
    global.debug_overlay_visible = false;
}
if (!variable_global_exists("debug_invincible")) {
    global.debug_invincible = false;
}

gameplay_room = room != rm_intro && room != rm_title && room != rm_options && room != rm_trophies
    && room != rm_dresser && room != rm_solgryn_ending;
campaign_slot = game_campaign_active_slot();
var _travel = undefined;
if (variable_global_exists("teleporter_travel") && !is_undefined(global.teleporter_travel)) {
    if (global.teleporter_travel.destination == room) {
        _travel = global.teleporter_travel;
    }
    global.teleporter_travel = undefined;
}
var _via_teleporter = !is_undefined(_travel);
var _arrived_from_vvvvvv = false;
if (!variable_global_exists("run") || (gameplay_room && (global.run.room_id != room || _via_teleporter))) {
    var _previous_run = variable_global_exists("run") ? global.run : undefined;
    var _previous_room = is_undefined(_previous_run) ? noone : _previous_run.room_id;
    var _carry_ryu_entry = room == rm_ryu && _previous_room == rm_king_dedede;
    _arrived_from_vvvvvv = room == rm_biollante && _previous_room == rm_vvvvvv;
    var _desert_route = room == rm_desert || room == rm_desert_secret || room == rm_final_path;
    var _tutorial_warp_exit = room == rm_prehistorik && _previous_room == rm_tutorial
        && struct_exists(_previous_run, "teleporter_entry") && !_previous_run.has_checkpoint;
    var _defer_checkpoint = room == rm_hello_kitty || room == rm_green_greens || room == rm_king_dedede
        || room == rm_ryu || room == rm_cheetahmen || room == rm_gastly || room == rm_mario
        || room == rm_vvvvvv || room == rm_biollante || room == rm_wario || room == rm_sanicz
        || room == rm_castlevania || room == rm_gradius || room == rm_skeleton_king || room == rm_milon
        || room == rm_milon_depths || room == rm_mega_man || room == rm_mega_man_world || room == rm_shang_tsung
        || room == rm_kid_icarus || room == rm_bomberman || room == rm_ninja_gaiden || room == rm_missingno
        || _desert_route || room == rm_solgryn || room == rm_credits || room == rm_prize_room || room == rm_teleporter
        || _via_teleporter || _tutorial_warp_exit
        || (room == rm_prehistorik && _previous_room == rm_milon);
    var _continues_without_checkpoint = (_via_teleporter && !is_undefined(_previous_run)) || _tutorial_warp_exit
        || (room == rm_hello_kitty && _previous_room == rm_prehistorik)
        || (room == rm_green_greens && _previous_room == rm_hello_kitty)
        || (room == rm_king_dedede && _previous_room == rm_green_greens) || _carry_ryu_entry
        || (room == rm_cheetahmen && (_previous_room == rm_ryu || _previous_room == rm_gastly))
        || ((room == rm_gastly || room == rm_mario) && _previous_room == rm_cheetahmen)
        || (room == rm_vvvvvv && _previous_room == rm_mario)
        || _arrived_from_vvvvvv || (room == rm_wario && _previous_room == rm_biollante)
        || (room == rm_sanicz && _previous_room == rm_wario)
        || (room == rm_castlevania && (_previous_room == rm_sanicz || _previous_room == rm_gradius))
        || ((room == rm_gradius || room == rm_skeleton_king) && _previous_room == rm_castlevania)
        || (room == rm_milon && (_previous_room == rm_skeleton_king || _previous_room == rm_milon_depths))
        || ((room == rm_milon_depths || room == rm_prehistorik) && _previous_room == rm_milon)
        || (room == rm_mega_man && _previous_room == rm_milon_depths)
        || (room == rm_mega_man_world && _previous_room == rm_mega_man)
        || (room == rm_shang_tsung && _previous_room == rm_mega_man_world)
        || (room == rm_kid_icarus && _previous_room == rm_shang_tsung)
        || (room == rm_bomberman && _previous_room == rm_kid_icarus)
        || (room == rm_ninja_gaiden && _previous_room == rm_bomberman)
        || (room == rm_missingno && _previous_room == rm_ninja_gaiden)
        || (room == rm_desert && (_previous_room == rm_missingno || _previous_room == rm_desert_secret))
        || ((room == rm_desert_secret || room == rm_final_path) && _previous_room == rm_desert)
        || (room == rm_solgryn && _previous_room == rm_final_path)
        || (room == rm_credits && _previous_room == rm_solgryn)
        || (room == rm_prize_room && _previous_room == rm_credits);
    var _restart_run = undefined;
    if (_continues_without_checkpoint) {
        _restart_run = _previous_run.has_checkpoint ? _previous_run : _previous_run.restart_run;
        // A course entrance is also a restart point before its first save block.
        if (is_undefined(_restart_run) && _previous_room != rm_gastly
            && (room == rm_hello_kitty || room == rm_king_dedede
            || room == rm_gastly || room == rm_mario || room == rm_vvvvvv || room == rm_biollante || room == rm_wario
            || room == rm_sanicz || room == rm_gradius || room == rm_skeleton_king || room == rm_milon
            || room == rm_milon_depths || room == rm_mega_man || room == rm_mega_man_world || room == rm_shang_tsung
            || room == rm_kid_icarus || room == rm_bomberman || room == rm_ninja_gaiden || room == rm_missingno
            || (room == rm_prehistorik && _previous_room == rm_milon)
            || _desert_route || room == rm_solgryn || room == rm_credits || _via_teleporter
            || !is_undefined(campaign_slot))) {
            _restart_run = _previous_run;
        }
    }

    var _deaths = 0;
    var _world_deaths = 0;
    if (_continues_without_checkpoint) {
        _deaths = _previous_run.deaths;
        _world_deaths = _previous_run.world_deaths;
    } else if (!is_undefined(campaign_slot)) {
        _deaths = campaign_slot.deaths;
        _world_deaths = campaign_slot.world_deaths;
    } else if (!is_undefined(_previous_run) && game_campaign_stage_key(_previous_run.room_id) != "") {
        _world_deaths = _previous_run.world_deaths;
    }
    global.run = {
        room_id: gameplay_room ? room : rm_tutorial,
        deaths: _deaths,
        world_deaths: _world_deaths,
        has_checkpoint: false,
        checkpoint_x: 0,
        checkpoint_y: 0,
        checkpoint_gravity: 1,
        checkpoint_gravity_flip: false,
        desert_snake: false,
        desert_switch: is_undefined(campaign_slot) ? false : campaign_slot.desert_switch,
        desert_checkpoint_switch: is_undefined(campaign_slot) ? false : campaign_slot.desert_switch,
        boss_entry_steps: 0,
        music_position: 0,
        ryu_entry_y: _carry_ryu_entry ? _previous_run.ryu_entry_y : undefined,
        gastly_return_run: room == rm_gastly && _previous_room == rm_cheetahmen ? _previous_run : undefined,
        gradius_return_run: room == rm_gradius && _previous_room == rm_castlevania ? _previous_run : undefined,
        restart_run: _restart_run
    };
    if (_via_teleporter) {
        global.run.teleporter_entry = _travel.position;
        global.run.boss_rush = _travel.boss_rush_key;
    }
    if (_desert_route && _continues_without_checkpoint) {
        global.run.desert_checkpoint_switch = _previous_run.desert_checkpoint_switch;
        global.run.desert_switch = _previous_run.desert_checkpoint_switch;
        if (room == rm_desert && _previous_room == rm_desert_secret) {
            global.run.desert_entry = { x: 7871, y: 553 };
        }
    }
    if (room == rm_solgryn && _previous_room == rm_final_path && struct_exists(_previous_run, "solgryn_portal_arrival")) {
        global.run.solgryn_portal_arrival = true;
        struct_remove(_previous_run, "solgryn_portal_arrival");
    }
    if ((_desert_route || room == rm_solgryn) && _continues_without_checkpoint
        && struct_exists(_previous_run, "solgryn_route_steps")) {
        global.run.solgryn_route_steps = _previous_run.solgryn_route_steps;
    }
    if (_arrived_from_vvvvvv || (room == rm_vvvvvv && _previous_room == rm_mario)) {
        global.run.boss_entry_steps = _previous_run.boss_entry_steps;
    }
    if (room == rm_shang_tsung && _previous_room == rm_mega_man_world) {
        global.run.boss_entry_steps = _previous_run.boss_entry_steps;
        global.run.mega_man_world_wily_cd = _previous_run.mega_man_world_wily_cd;
        if (struct_exists(_previous_run, "shang_wily_music_handoff")) {
            global.run.shang_wily_music_handoff = _previous_run.shang_wily_music_handoff;
            struct_remove(_previous_run, "shang_wily_music_handoff");
        }
    }
    if (room == rm_kid_icarus && _previous_room == rm_shang_tsung
        && struct_exists(_previous_run, "mega_man_world_wily_cd") && _previous_run.mega_man_world_wily_cd) {
        global.run.kid_icarus_cd = 9;
    }
    if (room == rm_bomberman && _previous_room == rm_kid_icarus) {
        global.run.bomberman_arrival = true;
        if (struct_exists(_previous_run, "kid_icarus_cd")) {
            global.run.kid_icarus_cd = _previous_run.kid_icarus_cd;
        }
    }
    if (room == rm_ninja_gaiden && _previous_room == rm_bomberman
        && struct_exists(_previous_run, "kid_icarus_cd")) {
        global.run.ninja_gaiden_cd = _previous_run.kid_icarus_cd;
    }
    if (room == rm_missingno && _previous_room == rm_ninja_gaiden) {
        if (struct_exists(_previous_run, "ninja_gaiden_cd")) {
            global.run.ninja_gaiden_cd = _previous_run.ninja_gaiden_cd;
        }
        if (struct_exists(_previous_run, "missingno_music_handoff")) {
            global.run.missingno_music_handoff = _previous_run.missingno_music_handoff;
            struct_remove(_previous_run, "missingno_music_handoff");
        }
    }
    if (gameplay_room && !_defer_checkpoint && game_campaign_sync(true)) {
        game_profile_save();
    }
}
if (gameplay_room) {
    var _save_exploration = game_mark_explored(teleporter_exploration_key(room));
    if (room == rm_teleporter) {
        var _progress = game_current_progress();
        _save_exploration = _save_exploration || !_progress.teleporter_unlocked;
        _progress.teleporter_unlocked = true;
        if (!is_undefined(campaign_slot) && campaign_slot.desert_switch) {
            campaign_slot.desert_switch = false;
            _save_exploration = true;
        }
        global.run.desert_switch = false;
        global.run.desert_checkpoint_switch = false;
        var _saved_run = global.run.restart_run;
        if (!is_undefined(_saved_run) && _saved_run.room_id == rm_desert) {
            _saved_run.desert_switch = false;
            _saved_run.desert_checkpoint_switch = false;
        }
    }
    if (_save_exploration) {
        global.profile.dirty = true;
        game_profile_save();
    }
}

caption_prefix = "I Wanna Be The Boshy";
caption_seconds = -1;
caption_deaths = -1;
refresh_window_caption = function() {
    var _play_time = is_undefined(campaign_slot) ? global.practice_play_time_us : campaign_slot.play_time_us;
    var _seconds = floor(_play_time / 1000000);
    var _deaths = global.run.deaths;
    if (_seconds == caption_seconds && _deaths == caption_deaths) {
        return;
    }

    caption_seconds = _seconds;
    caption_deaths = _deaths;
    var _hours = _seconds div 3600;
    var _minutes = (_seconds div 60) mod 60;
    var _time = string_replace_all(string_format(_hours, 2, 0) + ":" + string_format(_minutes, 2, 0)
        + ":" + string_format(_seconds mod 60, 2, 0), " ", "0");
    window_set_caption(caption_prefix + " - Deaths: " + string(_deaths) + " - Time: " + _time);
};

if (gameplay_room) {
    var _slot_number = 0;
    var _difficulty = -1;
    if (is_undefined(campaign_slot)) {
        if (!variable_global_exists("practice_play_time_us")) {
            global.practice_play_time_us = 0;
        }
    } else {
        _slot_number = global.active_campaign_slot + 1;
        _difficulty = campaign_slot.difficulty;
    }
    caption_prefix += " - Game " + string(_slot_number) + " - " + game_campaign_difficulty_name(_difficulty);
    refresh_window_caption();
} else {
    window_set_caption(caption_prefix);
}

render_width = 640;
render_height = 480;
teleport_mosaic_columns = 0;
teleport_mosaic_rows = 0;
teleporter_arrival_age = -1;
teleporter_arrival_sound = -1;
inbound_portal = noone;
inbound_portal_age = -1;
inbound_portal_sound = -1;
teleport_mosaic_uniform = -1;
if (shader_is_compiled(shd_teleport_mosaic)) {
    teleport_mosaic_uniform = shader_get_uniform(shd_teleport_mosaic, "u_grid_size");
}
if (_via_teleporter && _travel.play_arrival) {
    teleporter_arrival_age = 0;
    teleport_mosaic_columns = 31;
    teleport_mosaic_rows = 31;
    teleporter_arrival_sound = audio_play_sound(snd_prehistorik_descend, 1, false);
}
directional_blur_x = 0;
directional_blur_y = 0;
directional_blur_uniform = -1;
directional_blur_rotation_uniform = -1;
directional_blur_offset_uniform = -1;
scene_shake_x = 0;
scene_shake_y = 0;
flip_view_y = false;
screen_rotation = 0;
screen_rotation_uniform = -1;
if ((room == rm_hello_kitty || room == rm_king_dedede || room == rm_ryu || room == rm_mario
    || room == rm_biollante || room == rm_skeleton_king || room == rm_mega_man || room == rm_shang_tsung
    || room == rm_missingno || room == rm_final_path || room == rm_solgryn || room == rm_solgryn_ending)
    && shader_is_compiled(shd_directional_blur)) {
    directional_blur_uniform = shader_get_uniform(shd_directional_blur, "u_blur");
    directional_blur_rotation_uniform = shader_get_uniform(shd_directional_blur, "u_scene_rotation");
    directional_blur_offset_uniform = shader_get_uniform(shd_directional_blur, "u_scene_offset");
}
if ((room == rm_green_greens || room == rm_biollante || room == rm_milon) && shader_is_compiled(shd_view_rotation)) {
    screen_rotation_uniform = shader_get_uniform(shd_view_rotation, "u_rotation");
}
desert_heat_phase_uniform = -1;
desert_heat_size_uniform = -1;
if (room == rm_desert && shader_is_compiled(shd_desert_heat)) {
    desert_heat_phase_uniform = shader_get_uniform(shd_desert_heat, "u_phase");
    desert_heat_size_uniform = shader_get_uniform(shd_desert_heat, "u_surface_size");
}
application_surface_draw_enable(false);
gpu_set_texfilter(false);
show_controls = true;
debug_death_position = undefined;
death_audio = [];
stage_music_instance = -1;
stage_music_can_resume = false;
stage_music_sample_rate = 44100;
stage_music_frequency = 44100;
stage_music_volume = global.settings.music_volume;
stage_music_fading = false;
fps_sample_total = 0;
fps_sample_count = 0;

play_death_audio = function(_line) {
    var _death_track = room == rm_mario ? snd_mario_player_death : snd_death;
    if (room == rm_vvvvvv || room == rm_mega_man_world || room == rm_kid_icarus
        || room == rm_bomberman || room == rm_ninja_gaiden) {
        _death_track = snd_vvvvvv_death;
    } else if (room == rm_biollante) {
        var _boss = instance_find(obj_biollante, 0);
        // The bite replaces loludied on the same sound channel.
        _death_track = _boss != noone && _boss.bite_active ? snd_biollante_bite : snd_vvvvvv_death;
    } else if (room == rm_mega_man) {
        _death_track = snd_mario_guest_defeat;
    } else if (room == rm_missingno) {
        _death_track = snd_gastly_victory_music;
    } else if (room == rm_shang_tsung) {
        _death_track = snd_shang_tsung_player_defeat;
        var _boss = instance_find(obj_shang_tsung, 0);
        if (_boss != noone && _boss.fight_age >= 470 && _boss.fight_age <= 530) {
            _death_track = snd_shang_tsung_mudkip_taunt;
        }
    }
    death_audio = [];
    // The ending rooms and the hub use Death 3 as the base sample.
    if (room != rm_credits && room != rm_prize_room && room != rm_teleporter) {
        array_push(death_audio, audio_play_sound(_death_track, 1, false));
    }
    array_push(death_audio, audio_play_sound(snd_death_impact, 1, false));
    array_push(death_audio, play_boshy_voice(_line.sound, (44000 + irandom(19999) - irandom(9999)) / _line.sample_rate));
};

show_player_death = function(_x, _y, _depth, _character) {
    teleporter_rush_record_death();
    ++global.run.deaths;
    if (room == rm_shang_tsung) {
        var _progress = game_current_progress();
        ++_progress.shang_tsung_deaths;
    } else if (room == rm_bomberman) {
        var _progress = game_current_progress();
        ++_progress.bomberman_deaths;
    } else if (room == rm_missingno) {
        var _progress = game_current_progress();
        ++_progress.missingno_deaths;
    } else if (room == rm_solgryn) {
        var _progress = game_current_progress();
        ++_progress.solgryn_deaths;
    }
    if (game_campaign_stage_key(room) != "") {
        ++global.run.world_deaths;
    }
    ++global.profile.total_deaths;
    global.profile.dirty = true;
    game_campaign_sync(false);
    game_profile_save();
    debug_death_position = { x: _x, y: _y };
    var _line = _character.death_lines[irandom(array_length(_character.death_lines) - 1)];
    play_death_audio(_line);
    instance_create_depth(0, 0, -1000, obj_game_over);
    instance_create_depth(_x + 27, _y - 21, _depth - 1, obj_floating_text, { message: _line.text });
    repeat (floor(360 * global.settings.blood_intensity / 100)) {
        instance_create_depth(_x, _y - 8, _depth - 1, obj_blood);
    }
};

start_stage_music = function(_sound, _loop = true, _can_resume = true, _sample_rate = 44100) {
    if (stage_music_instance != -1) {
        audio_stop_sound(stage_music_instance);
    }
    stage_music_can_resume = _can_resume;
    stage_music_sample_rate = _sample_rate;
    stage_music_frequency = _sample_rate;
    stage_music_volume = global.settings.music_volume;
    stage_music_fading = false;
    var _start_position = 0;
    if (_can_resume && !global.settings.restart_music) {
        _start_position = global.run.music_position;
    }
    stage_music_instance = audio_play_sound(_sound, 0, _loop, stage_music_volume / 100, _start_position);
};

remember_stage_music = function() {
    if (stage_music_can_resume && stage_music_instance != -1
        && (audio_is_playing(stage_music_instance) || audio_is_paused(stage_music_instance))) {
        global.run.music_position = audio_sound_get_track_position(stage_music_instance);
    }
};

fade_stage_music = function() {
    if (stage_music_instance == -1 || stage_music_frequency <= 400) {
        return;
    }
    // A non-looping track can finish while this controller still holds its instance ID.
    if (!audio_is_playing(stage_music_instance) && !audio_is_paused(stage_music_instance)) {
        stage_music_instance = -1;
        return;
    }
    if (!stage_music_fading) {
        remember_stage_music();
        stage_music_fading = true;
    }

    // The original music channel drops one volume point and 300 Hz per dead step.
    stage_music_volume = max(0, stage_music_volume - 1);
    stage_music_frequency -= 300;
    audio_sound_gain(stage_music_instance, stage_music_volume / 100, 0);
    audio_sound_pitch(stage_music_instance, stage_music_frequency / stage_music_sample_rate);
};

if (!variable_global_exists("window_restore_steps")) {
    global.window_restore_steps = 0;
}

if (os_type == os_windows || os_type == os_macosx) {
    window_enable_borderless_fullscreen(true);
}

set_window_limits = function(_width, _height) {
    // GameMaker needs the resize option enabled to enter fullscreen on macOS.
    if (os_type == os_macosx) {
        window_set_min_width(_width);
        window_set_max_width(_width);
        window_set_min_height(_height);
        window_set_max_height(_height);
    }
};

if (global.window_restore_steps == 0 && !window_get_fullscreen()) {
    set_window_limits(window_get_width(), window_get_height());
}

get_window_display = function() {
    var _display = { left: 0, top: 0, width: display_get_width(), height: display_get_height() };
    var _x = window_get_x();
    var _y = window_get_y();
    var _rects = window_get_visible_rects(_x, _y, _x + window_get_width(), _y + window_get_height());
    if (!is_array(_rects)) {
        return _display;
    }

    var _largest_overlap = 0;

    for (var _i = 0; _i < array_length(_rects); _i += 8) {
        var _overlap = (_rects[_i + 2] - _rects[_i]) * (_rects[_i + 3] - _rects[_i + 1]);
        if (_overlap > _largest_overlap) {
            _largest_overlap = _overlap;
            _display.left = _rects[_i + 4];
            _display.top = _rects[_i + 5];
            _display.width = _rects[_i + 6] - _display.left;
            _display.height = _rects[_i + 7] - _display.top;
        }
    }

    return _display;
};

apply_window_scale = function(_scale, _display) {
    var _width = render_width * _scale;
    var _height = render_height * _scale;
    var _left = _display.left + (_display.width - _width) div 2;
    var _top = _display.top + (_display.height - _height) div 2;

    set_window_limits(-1, -1);
    window_set_rectangle(_left, _top, _width, _height);
    set_window_limits(_width, _height);
};

largest_window_scale = function(_display) {
    // Reserve space for the window frame and desktop controls.
    return clamp(floor(min((_display.width - 32) / render_width, (_display.height - 64) / render_height)), 1, 3);
};

get_viewport_rectangle = function() {
    var _window_width = window_get_width();
    var _window_height = window_get_height();
    if (_window_width <= 0 || _window_height <= 0) {
        return undefined;
    }

    // Prefer whole pixels when enlarging. Small windows use the same aspect ratio.
    var _scale = min(_window_width / render_width, _window_height / render_height);
    if (_scale >= 1) {
        _scale = floor(_scale);
    }
    var _width = max(1, round(render_width * _scale));
    var _height = max(1, round(render_height * _scale));
    return {
        left: (_window_width - _width) div 2,
        top: (_window_height - _height) div 2,
        width: _width,
        height: _height
    };
};

cycle_display_mode = function(_direction = 1) {
    if (global.window_restore_steps > 0) {
        return;
    }

    var _display = get_window_display();
    var _largest_scale = largest_window_scale(_display);
    var _fullscreen = window_get_fullscreen();
    var _current_mode = _fullscreen ? 0 : clamp(round(window_get_width() / render_width), 1, _largest_scale);
    var _mode_count = _largest_scale + 1;
    var _next_mode = (_current_mode + _direction + _mode_count) mod _mode_count;

    if (_fullscreen) {
        window_set_fullscreen(false);
        global.window_restore_steps = 10;
    } else if (_next_mode == 0) {
        set_window_limits(-1, -1);
        window_set_fullscreen(true);
    } else {
        apply_window_scale(_next_mode, _display);
    }
    global.settings.display_mode = _next_mode;
    game_settings_save();
};

save_checkpoint = function(_player, _checkpoint) {
    if (teleporter_rush_active()) {
        return;
    }
    var _run = global.run;
    _run.has_checkpoint = true;
    _run.checkpoint_x = _player.x;
    _run.checkpoint_y = _player.y;
    if (room == rm_vvvvvv) {
        _run.checkpoint_gravity = _player.gravity_direction;
        _run.checkpoint_gravity_flip = _player.gravity_flip_enabled;
        var _progress = game_current_progress();
        _progress.vvvvvv_gravity = _run.checkpoint_gravity;
        _progress.vvvvvv_gravity_flip = _run.checkpoint_gravity_flip;
        global.profile.dirty = true;
        // Group 54 adds 16 when saving inverted. The two startup shifts cancel.
        _run.checkpoint_y += _player.gravity_direction < 0 ? 16 : 0;
    } else if (room == rm_desert) {
        _run.desert_snake = desert_snake_is_mounted();
        _run.desert_checkpoint_switch = _run.desert_switch;
    }
    // Fusion resets the world board's count when saving near a world entrance.
    if ((room == rm_prehistorik || room == rm_cheetahmen || room == rm_vvvvvv)
        && point_in_rectangle(_player.x, _player.y, 5, 5, 636, 476)) {
        _run.world_deaths = 0;
    } else if (room == rm_green_greens && point_in_rectangle(_player.x, _player.y, -13, 1599, 235, 1897)) {
        _run.world_deaths = 0;
    } else if (room == rm_wario && point_in_rectangle(_player.x, _player.y, 8, 963, 157, 1180)) {
        _run.world_deaths = 0;
    } else if (room == rm_castlevania && _player.x >= 0 && _player.x < 195
        && _player.y >= 1137 && _player.y < 1385) {
        _run.world_deaths = 0;
    } else if (room == rm_milon && point_in_rectangle(_player.x, _player.y, 499, 1140, 655, 1367)) {
        _run.world_deaths = 0;
    } else if (room == rm_mega_man_world && _player.x >= 960 && _player.x < 1065
        && _player.y >= 62 && _player.y < 285) {
        _run.world_deaths = 0;
    } else if (room == rm_kid_icarus && _player.x >= 644 && _player.x < 747
        && _player.y >= 8503 && _player.y < 8594) {
        _run.world_deaths = 0;
    } else if (room == rm_ninja_gaiden && _player.x >= 8 && _player.x < 163
        && _player.y >= 304 && _player.y < 469) {
        _run.world_deaths = 0;
    } else if (room == rm_desert && _player.x >= 17 && _player.x < 99
        && _player.y >= 303 && _player.y < 474) {
        _run.world_deaths = 0;
    }
    _checkpoint.activate();
    if (game_campaign_sync(true) || room == rm_vvvvvv) {
        game_profile_save();
    }

    instance_create_depth(_player.x + 21, _player.y - 25, _player.depth - 1, obj_floating_text, {
        message: "SAVE!"
    });
    play_boshy_voice(snd_save, (44000 + irandom(9999) - irandom(9999)) / 48000);
};

if (_arrived_from_vvvvvv) {
    instance_create_depth(0, 0, -1, obj_biollante_arrival, { game_controller: id });
}
