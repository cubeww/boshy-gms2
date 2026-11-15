global.run.boss_entry_seconds += game_controller.frame_second_tick;
var _player = instance_find(obj_player, 0);
var _portal = inst_mega_man_world_hub_portal;

if (_player == noone || _player.dead) {
    chest_view_update(game_controller, noone, -1);
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
    if (destination_room == noone || !_player.boshy_mask_meeting(id)) {
        continue;
    }
    if (destination_room == rm_pokemon_puzzle) {
        // G770 and G796 both use the same direct puzzle arrival.
        game_travel_by_teleporter(destination_room, destination_x, destination_y, false);
        break;
    }
    room_goto(destination_room);
    break;
}
