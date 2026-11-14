++stage_steps;
++global.run.boss_entry_steps;
var _player = instance_find(obj_player, 0);
kid_icarus_mechanics_step(_player, stage_steps);
_player = instance_find(obj_player, 0);

var _rewards = instance_find(obj_kid_icarus_rewards, 0);
var _pickup_age = -1;
if (_rewards != noone) {
    _rewards.advance_rewards(_player);
    if (_rewards.prehistorik_pickup_slot >= 0) {
        _pickup_age = _rewards.prehistorik_pickup_age;
    }
}

if (_player != noone) {
    update_view(_player, _pickup_age);
}
kid_icarus_enemies_step(_player, stage_steps);
_player = instance_find(obj_player, 0);
if (_player == noone) {
    if (portal != noone) {
        reset_portal();
    }
    game_controller.fade_stage_music();
    exit;
}

if (portal != noone) {
    // G875–880 and G1229–1234 continue movement while centering and turning the player.
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
        exit;
    }

    var _pixel_size = max(1, floor(portal_age * 0.6));
    game_controller.teleport_mosaic_columns = max(1, game_controller.render_width div _pixel_size);
    game_controller.teleport_mosaic_rows = max(1, game_controller.render_height div _pixel_size);
    if (portal_age >= 80) {
        if (portal.destination_room == rm_teleporter) {
            game_travel_by_teleporter(portal.destination_room, portal.destination_x, portal.destination_y);
        } else {
            room_goto(portal.destination_room);
        }
    }
    exit;
}

if (_player.input_locked) {
    exit;
}
update_cd();

with (obj_kid_icarus_teleporter) {
    var _overlap = _player.boshy_mask_meeting(id);
    if (_overlap && !player_touching && other.portal == noone) {
        other.portal = id;
        other.portal_sound = audio_play_sound(snd_tutorial_teleport, 1, false);
        _player.input_locked = true;
        _player.hsp = 0;
        image_index = 1;
    }
    player_touching = _overlap;
}
