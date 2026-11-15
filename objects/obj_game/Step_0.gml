if (restore_saved_display) {
    restore_saved_display = false;
    var _mode = global.settings.display_mode;
    if (_mode == 0) {
        set_window_limits(-1, -1);
        window_set_fullscreen(true);
    } else if (_mode > 1) {
        var _display = get_window_display();
        apply_window_scale(min(_mode, largest_window_scale(_display)), _display);
    }
}

if (global.window_restore_steps > 0 && !window_get_fullscreen()) {
    // GameMaker needs time to restore the native window before resizing it.
    --global.window_restore_steps;
    if (global.window_restore_steps == 0) {
        var _restored_display = get_window_display();
        apply_window_scale(min(global.settings.display_mode, largest_window_scale(_restored_display)), _restored_display);
    }
} else if (keyboard_check_pressed(vk_f4)) {
    cycle_display_mode();
}

var _menu = room == rm_options ? instance_find(obj_options_menu, 0) : noone;
var _dresser = room == rm_dresser ? instance_find(obj_dresser_menu, 0) : noone;
var _editor_open = _dresser != noone && !is_undefined(_dresser.custom_editor);
var _music_input_free = !_editor_open && (_menu == noone || !_menu.capturing_key)
    && (room != rm_wow || !wow_login_typing());
var _cd_uses_tab = !_editor_open && game_collectible_music_step(id, _music_input_free);
if (keyboard_check_pressed(vk_tab) && !keyboard_check(vk_alt) && _music_input_free && !_cd_uses_tab) {
    global.debug_overlay_visible = !global.debug_overlay_visible;
}

if (room == rm_intro || room == rm_title) {
    exit;
}

var _escape = keyboard_check_pressed(vk_escape);
var _open_dresser = keyboard_check_pressed(vk_f3);
var _open_trophies = keyboard_check_pressed(vk_f5);
var _keys = global.settings.keys;
if (keyboard_check_pressed(vk_f2) && !game_key_is_bound(_keys, vk_f2)
    && (_menu == noone || !_menu.controls_open)) {
    game_go_to_title();
    exit;
}
if (room == rm_solgryn_ending) {
    exit;
}
if (room == rm_options) {
    if (_escape) {
        if (_menu == noone || !_menu.handle_escape()) {
            game_return_from_menu();
        }
    } else if ((_open_dresser || _open_trophies) && (_menu == noone || !_menu.controls_open)) {
        room_goto(_open_dresser ? rm_dresser : rm_trophies);
    }
    exit;
}

if (room == rm_trophies) {
    if (_escape || keyboard_check_pressed(ord("R"))) {
        game_return_from_menu();
    } else if (_open_dresser) {
        room_goto(rm_dresser);
    }
    exit;
}

if (room == rm_dresser) {
    exit;
}

var _profile = global.profile;
teleporter_rush_step();
game_check_death_achievement(global.run.deaths);
if (++achievement_check_steps == 100) {
    achievement_check_steps = 0;
    game_check_collection_achievements();
}
if (array_length(achievement_notifications) > 0) {
    if (achievement_notification_age == 0) {
        audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
        audio_play_sound(snd_tutorial_achievement_success, 1, false);
    }
    if (++achievement_notification_age == 226) {
        array_delete(achievement_notifications, 0, 1);
        achievement_notification_age = 0;
    }
}
var _save_interval_us = 30000000;
var _last_save_interval = floor(_profile.play_time_us / _save_interval_us);
_profile.play_time_us += delta_time;
if (is_undefined(campaign_slot)) {
    global.practice_play_time_us += delta_time;
} else {
    campaign_slot.play_time_us += delta_time;
}
if (room == rm_desert || room == rm_desert_secret || room == rm_final_path || room == rm_solgryn) {
    if (!struct_exists(global.run, "solgryn_route_seconds")) {
        global.run.solgryn_route_seconds = 0;
    }
    global.run.solgryn_route_seconds += frame_second_tick;
}
// WoW G586 and Cheetah Men G587 share the seconds shown by the Timer item.
if (room == rm_wow || room == rm_cheetah_men) {
    global.run.wow_timer_seconds += frame_second_tick;
}
refresh_window_caption();
_profile.dirty = true;
if (floor(_profile.play_time_us / _save_interval_us) != _last_save_interval) {
    game_profile_save();
}

if (keyboard_check_pressed(vk_f8) && !game_key_is_bound(_keys, vk_f8)) {
    global.settings.show_fps = !global.settings.show_fps;
    fps_sample_total = 0;
    fps_sample_count = 0;
    game_settings_save();
}
if (global.settings.show_fps && fps > 0) {
    fps_sample_total += fps;
    ++fps_sample_count;
}

var _gradius_ship = room == rm_gradius ? instance_find(obj_gradius_player, 0) : noone;
if (_gradius_ship != noone && _gradius_ship.dead) {
    fade_stage_music();
}

var _restart = keyboard_check_pressed(_keys.restart) && (room != rm_wow || !wow_login_typing());
if (_open_dresser || _open_trophies || _escape || _restart) {
    if (teleporter_rush_active()) {
        teleporter_rush_return();
        exit;
    }
    if (instance_exists(obj_player) || (_gradius_ship != noone && !_gradius_ship.dead)) {
        remember_stage_music();
    }

    if (_open_dresser) {
        room_goto(rm_dresser);
    } else if (_open_trophies) {
        room_goto(rm_trophies);
    } else if (_escape) {
        room_goto(rm_options);
    } else {
        global.cd_restart = { room_id: room, position: global.run.music_position };
        var _run = global.run;
        var _restart_run = _run.restart_run;
        if (is_undefined(_restart_run) || _run.has_checkpoint) {
            room_restart();
        } else {
            _restart_run.deaths = _run.deaths;
            _restart_run.world_deaths = _run.world_deaths;
            if (struct_exists(_run, "solgryn_route_seconds")) {
                _restart_run.solgryn_route_seconds = _run.solgryn_route_seconds;
            }
            if (room == rm_cheetah_men && _restart_run.room_id == rm_wow) {
                _restart_run.wow_timer_seconds = _run.wow_timer_seconds;
            }
            if (room == rm_gradius || room == rm_desert || room == rm_desert_secret || room == rm_final_path
                || room == rm_solgryn || room == rm_credits || room == rm_prize_room || room == rm_teleporter
                || struct_exists(_run, "teleporter_entry")) {
                _restart_run.music_position = 0;
            }
            global.run = _restart_run;
            room_goto(_restart_run.room_id);
        }
    }
    exit;
}

if (room != rm_gastly && game_has_item("Gastly")) {
    var _player = instance_find(obj_player, 0);
    if (_player != noone && !_player.dead) {
        gastly_companion_step(_player);
    }
}
