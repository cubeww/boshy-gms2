++global.run.boss_entry_steps;
exit_notice_steps = max(0, exit_notice_steps - 1);
var _player = instance_find(obj_player, 0);
var _portal = inst_mega_man_world_hub_portal;

if (_player == noone || _player.dead) {
    mega_man_world_route_platform_step(noone);
    game_controller.fade_stage_music();
    if (portal_age >= 0) {
        portal_age = -1;
        _portal.image_index = 0;
        game_controller.teleport_mosaic_columns = 0;
        game_controller.teleport_mosaic_rows = 0;
        audio_stop_sound(portal_sound);
        portal_sound = -1;
    }
    mega_man_world_turnstiles_step();
    exit;
}

mega_man_world_route_platform_step(_player);
update_view(_player);
mega_man_world_turnstiles_step();

if (portal_age >= 0) {
    with (_player) {
        refresh_collision_probes();
        move_player_horizontal(false);
        move_player_vertical();
        if (vsp > 7) {
            vsp -= 1;
        }
    }
    ++portal_age;
    if (_player.x > _portal.x) {
        _player.x -= 5;
    }
    if (_player.x < _portal.x) {
        _player.x += 5;
    }
    if (_player.y > _portal.y - 20) {
        _player.vsp -= 1;
    }
    _player.image_angle += portal_age;
    portal_frame = min(floor(portal_age * 0.6), sprite_get_number(spr_tutorial_portal_transition) - 1);
    var _pixels = max(1, portal_frame);
    game_controller.teleport_mosaic_columns = game_controller.render_width div _pixels;
    game_controller.teleport_mosaic_rows = game_controller.render_height div _pixels;

    if (portal_age >= 80) {
        // G865 exits to the Teleporter Room at (320, 240).
        game_travel_by_teleporter(_portal.destination_room, _portal.destination_x, _portal.destination_y);
    }
    exit;
}

if (_player.input_locked) {
    exit;
}

// G102 selects the Wily CD with 9. Repeating 9 restores the stage track so Tab stays available for debug info.
var _cd_key = ord("9");
if (keyboard_check_pressed(_cd_key) && !game_key_is_bound(global.settings.keys, _cd_key) && game_has_item("Wily CD")) {
    global.run.mega_man_world_wily_cd = !global.run.mega_man_world_wily_cd;
    global.run.music_position = 0;
    set_stage_track(global.run.mega_man_world_wily_cd);
}

var _over_portal = _player.boshy_mask_meeting(_portal);
if (_over_portal && !portal_contact) {
    // G862–867 center, lift and spin the player while the viewport pixelates.
    portal_age = 0;
    portal_frame = 0;
    _player.input_locked = true;
    _player.hsp = 0;
    _portal.image_index = 1;
    portal_sound = audio_play_sound(snd_tutorial_teleport, 1, false);
}
portal_contact = _over_portal;

with (obj_mega_man_world_exit) {
    if (_player.boshy_mask_meeting(id)) {
        if (destination_room != noone) {
            if (destination_room == rm_shang_tsung && global.run.mega_man_world_wily_cd
                && audio_is_playing(other.game_controller.stage_music_instance)) {
                // Shang Tsung G673 leaves an active channel 2 alone.
                global.run.shang_wily_music_handoff = other.game_controller.stage_music_instance;
                other.game_controller.stage_music_instance = -1;
            }
            room_goto(destination_room);
        } else {
            other.show_exit_notice(destination_notice);
        }
    }
}
