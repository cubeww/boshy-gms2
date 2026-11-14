game_controller = instance_find(obj_game, 0);
exit_door = noone;
exit_age = 0;
hub = noone;
hub_age = 0;
hub_audio = -1;
prehistorik_pickup_slot = -1;
prehistorik_pickup_age = 0;
prehistorik_pickup_cue = -1;
trophy_title = "";
trophy_steps = -1;

show_trophy = function(_title) {
    trophy_title = _title;
    trophy_steps = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
};

settle_at_door = function(_player) {
    _player.x = exit_door.x + exit_door.settle_x;
    _player.y = exit_door.y + exit_door.settle_y;
    _player.refresh_collision_probes();
};

reset_hub = function() {
    hub.image_index = 0;
    hub = noone;
    hub_age = 0;
    game_controller.teleport_mosaic_columns = 0;
    game_controller.teleport_mosaic_rows = 0;
    if (hub_audio != -1) {
        audio_stop_sound(hub_audio);
        hub_audio = -1;
    }
};

advance_hub = function(_player) {
    // G925–929 center and turn the player while continuing the vertical physics.
    with (_player) {
        refresh_collision_probes();
        move_player_vertical();
        if (vsp > 7) {
            --vsp;
        }
    }
    if (_player.x > hub.x) {
        _player.x -= 5;
    }
    if (_player.x < hub.x) {
        _player.x += 5;
    }
    if (_player.y > hub.y - 20) {
        --_player.vsp;
    }
    _player.image_angle += ++hub_age;
    if (_player.touching_hazard() && _player.die()) {
        reset_hub();
        return;
    }

    var _pixel_size = max(1, floor(hub_age * 0.6));
    game_controller.teleport_mosaic_columns = max(1, game_controller.render_width div _pixel_size);
    game_controller.teleport_mosaic_rows = max(1, game_controller.render_height div _pixel_size);
    if (hub_age == 80) {
        game_travel_by_teleporter(hub.destination_room, hub.destination_x, hub.destination_y);
    }
};

advance_route = function(_player) {
    if (trophy_steps >= 0 && ++trophy_steps >= 226) {
        trophy_steps = -1;
    }
    prehistorik_pickups_step(_player);
    if (_player == noone || _player.dead) {
        if (hub != noone) {
            reset_hub();
        }
        exit_door = noone;
        exit_age = 0;
        return;
    }
    if (exit_door != noone) {
        // G1044–1045 and G1077–1078 hold the player in the doorway during the fade.
        settle_at_door(_player);
        if (++exit_age == 40) {
            room_goto(exit_door.destination_room);
        }
        return;
    }
    if (hub != noone) {
        advance_hub(_player);
        return;
    }
    if (_player.input_locked) {
        return;
    }

    if (instance_exists(inst_desert_route_hub)) {
        var _hub = inst_desert_route_hub;
        var _overlap = _player.boshy_mask_meeting(_hub);
        if (_overlap && !_hub.player_touching) {
            // G924 starts the shared teleport transition to runtime frame 29.
            _hub.image_index = 1;
            hub = _hub;
            hub_audio = audio_play_sound(snd_tutorial_teleport, 1, false);
            _player.input_locked = true;
            _player.hsp = 0;
        }
        _hub.player_touching = _overlap;
    }
    if (hub != noone) {
        return;
    }

    with (obj_desert_door) {
        if (destination_room != noone && _player.boshy_mask_meeting(id)) {
            other.exit_door = id;
            other.exit_age = 1;
            _player.input_locked = true;
            _player.hsp = 0;
            _player.vsp = 0;
            other.settle_at_door(_player);
            break;
        }
    }
};
