if (trophy_steps >= 0 && ++trophy_steps >= 226) {
    trophy_steps = -1;
}
var _player = instance_find(obj_player, 0);
prehistorik_pickups_step(_player);
chest_view_update(game_controller, _player, prehistorik_pickup_slot >= 0 ? prehistorik_pickup_age : -1);
if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
    milon_show_trophy("TRIGGER FINGER!!");
}
var _portal = room == rm_milon ? inst_milon_wow_portal : inst_milon_depths_hub_portal;
if (_player == noone || _player.dead) {
    if (portal_steps >= 0) {
        portal_steps = -1;
        _portal.image_index = 0;
        game_controller.teleport_mosaic_columns = 0;
        game_controller.teleport_mosaic_rows = 0;
        audio_stop_sound(portal_sound);
        portal_sound = -1;
    }
    exit;
}

if (portal_steps < 0 && !_player.input_locked && _player.boshy_mask_meeting(_portal)) {
    // Both native portals start the same lift and mosaic when touched.
    portal_steps = 0;
    _player.input_locked = true;
    _player.hsp = 0;
    _portal.image_index = 1;
    portal_sound = audio_play_sound(snd_tutorial_teleport, 1, false);
}
if (portal_steps >= 0) {
    if (portal_steps > 0) {
        with (_player) {
            refresh_collision_probes();
            move_player_horizontal(false);
            move_player_vertical();
            if (vsp > 7) {
                vsp -= 1;
            }
        }
    }
    ++portal_steps;
    if (_player.x > _portal.x) {
        _player.x -= 5;
    }
    if (_player.x < _portal.x) {
        _player.x += 5;
    }
    if (_player.y > _portal.y - 20) {
        _player.vsp -= 1;
    }
    _player.image_angle += portal_steps;
    portal_frame = min(floor(portal_steps * 0.6), sprite_get_number(spr_tutorial_portal_transition) - 1);
    var _pixel_size = max(1, portal_frame);
    game_controller.teleport_mosaic_columns = game_controller.render_width div _pixel_size;
    game_controller.teleport_mosaic_rows = game_controller.render_height div _pixel_size;
    if (portal_steps >= 80) {
        game_travel_by_teleporter(_portal.destination_room, _portal.destination_x, _portal.destination_y);
    }
    exit;
}

if (room == rm_milon) {
    if (!_player.input_locked && _player.boshy_mask_meeting(inst_milon_depths_exit)) {
        // Main room G822 enters the Metal Gear section at (16, 1673).
        room_goto(rm_milon_depths);
        exit;
    }
} else {
    // G780–783 restart the new clip on a zone change. Clips 12 and 13 share the same frames in reverse order.
    with (obj_milon_pillar) {
        var _open = point_in_rectangle(_player.x, _player.y, open_zone[0], open_zone[1], open_zone[2], open_zone[3]);
        if (_open != pillar_opening) {
            pillar_opening = _open;
            pillar_clip_frame = 0;
        } else {
            pillar_clip_frame = min(pillar_clip_frame + 0.5, image_number - 1);
        }
        var _frame = floor(pillar_clip_frame);
        image_index = pillar_opening ? image_number - 1 - _frame : _frame;
    }
    if (!_player.input_locked) {
        // Depths G498 and G524 check distinct trigger zones and use the current campaign slot.
        if (point_in_rectangle(_player.x, _player.y, 2046, 2833, 2088, 3196)
            && game_has_item("Metal Gear") && game_has_item("Hamster CD") && game_trophy_unlock("World7clear")) {
            milon_show_trophy("World 7 CLEAR!");
        }
        if (point_in_rectangle(_player.x, _player.y, 2263, 2834, 2305, 3197)
            && global.run.world_deaths <= 30 && game_trophy_unlock("World7PROMODE")) {
            milon_show_trophy("World 7 PRO MODE!");
        }
        if (_player.boshy_mask_meeting(inst_milon_depths_castle_return)) {
            // Depths G779 returns through the entrance on the left.
            global.milon_return_position = { x: 8927, y: 895 };
            room_goto(rm_milon);
            exit;
        }
        if (_player.boshy_mask_meeting(inst_milon_depths_boss_exit)) {
            room_goto(rm_mega_man);
            exit;
        }
    }
}
