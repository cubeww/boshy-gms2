game_controller = instance_find(obj_game, 0);
portal = noone;
portal_age = 0;
portal_audio = -1;
boss_exit_age = -1;
boss_exit_rearm = true;

reset_portal = function() {
    portal.image_index = 0;
    portal = noone;
    portal_age = 0;
    game_controller.teleport_mosaic_columns = 0;
    game_controller.teleport_mosaic_rows = 0;
    if (portal_audio != -1) {
        audio_stop_sound(portal_audio);
        portal_audio = -1;
    }
};

advance_route = function(_player) {
    var _stage = instance_find(obj_ninja_gaiden, 0);
    if (_player == noone || _player.dead) {
        if (portal != noone) {
            reset_portal();
        }
        if (boss_exit_age >= 0) {
            boss_exit_age = -1;
            _stage.restore_stage_track();
        }
        return;
    }

    if (boss_exit_age >= 0) {
        // G983–984 go to the next frame after 135 steps or a skip.
        ++boss_exit_age;
        if (boss_exit_age >= 135 || keyboard_check_pressed(ord("S"))) {
            // Keep Fusion's channel 2 playing through the frame change.
            global.run.missingno_music_handoff = game_controller.stage_music_instance;
            game_controller.stage_music_instance = -1;
            room_goto(rm_missingno);
        }
        return;
    }

    if (portal != noone) {
        // G953–957 continue movement while drawing the player toward the pad.
        with (_player) {
            refresh_collision_probes();
            move_player_horizontal(false);
            move_player_vertical();
            if (vsp > 7) {
                --vsp;
            }
        }
        if (_player.x > portal.x) {
            _player.x -= 5;
        }
        if (_player.x < portal.x) {
            _player.x += 5;
        }
        if (_player.y > portal.y - 20) {
            --_player.vsp;
        }
        _player.image_angle += ++portal_age;
        if (_player.touching_hazard() && _player.die()) {
            reset_portal();
            return;
        }

        var _pixel_size = max(1, floor(portal_age * 0.6));
        game_controller.teleport_mosaic_columns = max(1, game_controller.render_width div _pixel_size);
        game_controller.teleport_mosaic_rows = max(1, game_controller.render_height div _pixel_size);
        if (portal_age >= 80) {
            game_travel_by_teleporter(portal.destination_room, portal.destination_x, portal.destination_y);
        }
        return;
    }

    if (_player.input_locked) {
        return;
    }

    var _hub = inst_ninja_gaiden_hub_portal;
    var _hub_touching = _player.boshy_mask_meeting(_hub);
    if (_hub_touching && !_hub.player_touching) {
        // G952–957 use the standard teleporter before heading to runtime frame 29.
        _hub.player_touching = true;
        _hub.image_index = 1;
        portal = _hub;
        portal_audio = audio_play_sound(snd_tutorial_teleport, 1, false);
        _player.input_locked = true;
        _player.hsp = 0;
        return;
    }
    _hub.player_touching = _hub_touching;

    // G981's literal handle 36 also resolves to MissingNo. in the shipped storyboard.
    if (_player.boshy_mask_meeting(inst_ninja_gaiden_alternate_boss_exit)) {
        room_goto(rm_missingno);
        return;
    }
    var _strip_touching = false;
    with (obj_ninja_gaiden_exit_strip) {
        var _overlap = _player.boshy_mask_meeting(id);
        _strip_touching = _strip_touching || _overlap;
        // G982 rolls its 1-of-15 chance on a new collision with each tile.
        if (_overlap && !player_touching && other.boss_exit_rearm && irandom(14) == 0) {
            other.boss_exit_rearm = false;
            other.boss_exit_age = 0;
            _player.input_locked = true;
            _player.hsp = 0;
            _player.vsp = 0;
            _stage.set_scene_track(snd_ninja_gaiden_boss_exit_music);
        }
        player_touching = _overlap;
    }
    if (!_strip_touching) {
        boss_exit_rearm = true;
    }
};
