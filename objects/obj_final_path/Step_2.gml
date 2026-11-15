var _player = instance_find(obj_player, 0);
var _portal = inst_final_path_hub_portal;
if (_player == noone || _player.dead) {
    game_controller.fade_stage_music();
    if (portal_age >= 0) {
        reset_hub_portal(_portal);
    }
    exit;
}

update_view(_player);
if (portal_age >= 0) {
    // G934–939 draw the player into the Teleporter Room's pad while the effect plays.
    with (_player) {
        refresh_collision_probes();
        move_player_horizontal(false);
        move_player_vertical();
    }
    if (_player.x > _portal.x) {
        _player.x -= 5;
    }
    if (_player.x < _portal.x) {
        _player.x += 5;
    }
    if (_player.y > _portal.y - 20) {
        --_player.vsp;
    }
    _player.image_angle += ++portal_age;
    if (_player.touching_hazard() && _player.die()) {
        reset_hub_portal(_portal);
        exit;
    }
    var _pixels = max(1, floor(portal_age * 0.6));
    game_controller.teleport_mosaic_columns = max(1, 640 div _pixels);
    game_controller.teleport_mosaic_rows = max(1, 480 div _pixels);
    if (portal_age >= 80) {
        game_travel_by_teleporter(_portal.destination_room, _portal.destination_x, _portal.destination_y);
    }
    exit;
}

if (_player.input_locked) {
    exit;
}
var _touching = _player.boshy_mask_meeting(_portal);
if (_touching && !_portal.player_touching) {
    portal_age = 0;
    _player.input_locked = true;
    _player.hsp = 0;
    _portal.image_index = 1;
    portal_sound = audio_play_sound(snd_tutorial_teleport, 1, false);
}
_portal.player_touching = _touching;
