++scene_steps;
if (solgryn_history_alpha == 0) {
    history_valid = false;
}
var _player = instance_find(obj_player, 0);
if (_player != noone && _player.dead) {
    _player = noone;
}

var _fighting = victory_age < 0;
solgryn_actor_update_orbit();
if (_fighting) {
    ++fight_age;
    // G695 places the box before the movement and attack events.
    if (fight_age == 1450) {
        x = 320;
        y = 200;
        target_x = 530;
        target_y = 200;
        fight_age = 2080;
        solgryn_flash();
    }
}

// G696 eases the hotspot before the current attack changes its target.
if (fight_age >= 2000) {
    x = floor(x + (target_x - x) * 0.2 + clamp(target_x, -1, 1));
    y = floor(y + (target_y - y) * 0.2 + clamp(target_y, -1, 1));
}

solgryn_actor_advance_pose(fight_age);
if (_fighting) {
    if (fight_age >= 5020) {
        fight_age = solgryn_late_step(_player, fight_age);
    } else {
        solgryn_early_step(_player, fight_age);
        if (hit_points <= 0 && !first_form_defeated) {
            first_form_defeated = true;
            fight_age = 5020;
            if (game_controller.stage_music_instance != -1) {
                audio_pause_sound(game_controller.stage_music_instance);
            }
        } else if (fight_age == 5000) {
            fight_age = 4040;
        }
    }
} else {
    solgryn_late_ship_step(_player, fight_age);
    _player = instance_find(obj_player, 0);
    solgryn_late_beam_right_edge(_player);
    solgryn_late_laser_step(_player);
    _player = instance_find(obj_player, 0);
    solgryn_victory_step(_player);
}

_player = instance_find(obj_player, 0);
solgryn_actor_advance_hit_flash();
if (_player != noone) {
    if (solgryn_actor_player_contact(_player) && _player.die()) {
        _player = noone;
    } else if (_fighting && fight_age > 15300 && hit_points <= 0) {
        solgryn_victory_begin();
    }
}

if (_player == noone) {
    game_controller.fade_stage_music();
}

// G885 skips the advert after G696 has already evaluated this step.
if (_fighting && fight_age < 2000 && keyboard_check_pressed(ord("S"))) {
    x = 320;
    y = 200;
    target_x = 530;
    target_y = 200;
    fight_age = 2080;
    solgryn_flash();
    solgryn_music_seek(29.2);
}

// G985 advances the flash after the encounter events can trigger it.
flash_ink = min(128, flash_ink + 10);

// G640 follows the active 480 px page. G1009 picks offsets for the following step.
if (_player != noone) {
    view_top = floor(_player.y / 480) * 480 - 2;
}
camera_set_view_pos(view_camera[0], view_left + shake_x, view_top + shake_y);
shake_strength = max(0, shake_strength - 1);
shake_x = shake_strength > 0 ? -shake_strength + irandom(shake_strength * 2 - 1) : 0;
shake_y = shake_strength > 0 ? -shake_strength + irandom(shake_strength * 2 - 1) : 0;

// G1142–1144 leave a settled picture once the native blur strength reaches one.
var _blur_was_active = blur_strength > 1;
if (_blur_was_active) {
    blur_strength *= 0.9;
}
if (blur_strength <= 1) {
    game_controller.directional_blur_x = 0;
    game_controller.directional_blur_y = 0;
} else if (arrival_age != 0) {
    var _angle = blur_angle == 0 ? irandom(359) : blur_angle;
    game_controller.directional_blur_x = dcos(_angle) * blur_strength * 0.01;
    game_controller.directional_blur_y = dsin(_angle) * blur_strength * 0.01;
}

if (arrival_age >= 0) {
    ++arrival_age;
    arrival_frame = arrival_age * 60 div 100;
    var _grid = 0;
    if (arrival_frame >= sprite_get_number(spr_tutorial_portal_transition)) {
        arrival_age = -1;
    } else if (!_blur_was_active) {
        // G611 uses the incoming clip's forward frame number. G1142–1144 override it while settling.
        _grid = arrival_frame * 31;
    }
    game_controller.teleport_mosaic_columns = _grid;
    game_controller.teleport_mosaic_rows = _grid;
}
