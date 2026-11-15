conveyor_frame = (conveyor_frame + 0.25) mod sprite_get_number(spr_tutorial_conveyor);

if (trigger_finger_age >= 0) {
    ++trigger_finger_age;
    if (trigger_finger_age >= 226) {
        trigger_finger_age = -1;
    }
}

if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
    trigger_finger_age = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
}

var _player = instance_find(obj_player, 0);
if (_player == noone) {
    game_controller.fade_stage_music();
    update_page(noone);
    exit;
}

// Fusion group 819 checks the two-row Down probe against the conveyor tiles.
if (_player.down_probe_overlaps_rectangle(0, 448, 640, 464)) {
    _player.x += 2;
}

if (_player.bbox_bottom >= 480) {
    for (var _i = 0; _i < array_length(recovery_strips); ++_i) {
        var _strip = recovery_strips[_i];
        if (_player.bbox_right >= _strip.left && _player.bbox_left < _strip.right) {
            _player.x = _strip.return_x;
            _player.y = _strip.return_y;
            shake_steps = 25;
            audio_play_sound(snd_tutorial_teleport, 1, false);
            break;
        }
    }
}

var _portal_x = portal.x;
var _portal_y = portal.y;
if (portal_steps < 0 && _player.boshy_mask_meeting(portal)) {
    _player.input_locked = true;
    _player.hsp = 0;
    portal_steps = 0;
    portal.image_index = 1;
    audio_play_sound(snd_tutorial_teleport, 1, false);
}

if (portal_steps >= 0) {
    if (portal_steps > 0) {
        with (_player) {
            move_player_horizontal(false);
            move_player_vertical();
            if (vsp > 7) {
                vsp -= 1;
            }
        }
    }

    ++portal_steps;
    if (_player.x > _portal_x) {
        _player.x -= 5;
    }
    if (_player.x < _portal_x) {
        _player.x += 5;
    }
    // The beam only adds upward acceleration below this point. Momentum continues above it.
    if (_player.y > _portal_y - 20) {
        _player.vsp -= 1;
    }
    _player.image_angle += portal_steps;
    portal_frame = min(floor(portal_steps * 0.6), sprite_get_number(spr_tutorial_portal_transition) - 1);
    // Fusion applies Mosaic.fx to the composed screen, including the black wipe.
    var _pixel_size = max(1, portal_frame);
    game_controller.teleport_mosaic_columns = game_controller.render_width div _pixel_size;
    game_controller.teleport_mosaic_rows = game_controller.render_height div _pixel_size;

    if (portal_steps == portal_duration) {
        global.prehistorik_portal_arrival = true;
        room_goto(rm_prehistorik);
        exit;
    }
}

update_page(_player);
