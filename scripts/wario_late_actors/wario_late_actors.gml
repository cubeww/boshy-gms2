function wario_actor_setup(_source_handle) {
    source_handle = _source_handle;
    switch (_source_handle) {
        case 988:
            sprite_index = spr_wario_widget;
            walk_left = false;
            fall_speed = 0;
            break;
        case 997:
            sprite_index = spr_wario_floating_skull;
            image_speed = 0;
            float_speed = 0;
            terrain_contact = false;
            break;
        case 998:
        case 999:
            sprite_index = _source_handle == 998 ? spr_wario_skull_turn_down : spr_wario_skull_turn_up;
            visible = false;
            break;
        case 1013:
        case 1014:
            sprite_index = _source_handle == 1013 ? spr_wario_swing_spike_left : spr_wario_swing_spike_right;
            swing_direction = _source_handle == 1013 ? 1 : -1;
            swing_phase = 0;
            break;
        case 1027:
            sprite_index = spr_wario_finger_spike_left;
            break;
        case 1028:
            sprite_index = spr_wario_finger_spike_right;
            break;
        case 1029:
            sprite_index = spr_wario_finger_laser;
            image_speed = 0;
            finger_armed = false;
            finger_age = 0;
            volley_wait_ms = 250;
            break;
    }
}

function wario_widget_step() {
    // Groups 704–709 use the original point probes to fall and turn at walls and ledges.
    if (collision_point(x, y + 8, obj_player_backdrop, true, true) == noone) {
        y = floor(y + fall_speed);
        fall_speed += 0.1;
    }
    if (fall_speed > 0 && collision_point(x, y + 8, obj_player_backdrop, true, true) != noone) {
        fall_speed = 0;
    }
    if (walk_left && collision_point(x - 8, y, obj_player_backdrop, true, true) != noone) {
        walk_left = false;
    }
    if (!walk_left && collision_point(x + 8, y, obj_player_backdrop, true, true) != noone) {
        walk_left = true;
    }
    if (collision_point(x, y + 9, obj_player_backdrop, true, true) != noone) {
        if (walk_left && collision_point(x - 8, y + 8, obj_player_backdrop, true, true) == noone) {
            walk_left = false;
        }
        if (!walk_left && collision_point(x + 8, y + 8, obj_player_backdrop, true, true) == noone) {
            walk_left = true;
        }
    }
    if (collision_point(x, y + 7, obj_player_backdrop, true, true) != noone) {
        --y;
    }
    x += walk_left ? -1 : 1;
    var _sprite = walk_left ? spr_wario_widget_left : spr_wario_widget;
    if (sprite_index != _sprite) {
        var _frame = image_index;
        sprite_index = _sprite;
        image_index = _frame;
    }

    // Groups 715–716 use the player's body and vertical speed after the enemy moves.
    var _player = instance_find(obj_player, 0);
    if (_player != noone && !_player.dead && _player.boshy_mask_meeting(id)) {
        if (_player.vsp > 0) {
            _player.vsp = -10;
            _player.air_jump_available = true;
            _player.jump_cut_enabled = false;
            instance_destroy();
        } else {
            _player.die();
        }
    }
}

function wario_floating_skull_step() {
    var _camera = view_camera[0];
    var _view_x = camera_get_view_x(_camera);
    var _view_y = camera_get_view_y(_camera);
    // Groups 735–737 only track the player when the skull is within the view margin.
    if (x > _view_x - 8 && x + 32 < _view_x + camera_get_view_width(_camera) + 8
        && y > _view_y - 8 && y + 24 < _view_y + camera_get_view_height(_camera) + 8) {
        y = floor(y + float_speed);
        image_index = 1;
        var _player = instance_find(obj_player, 0);
        if (_player != noone) {
            float_speed += 0.4 * sign(_player.y - 16 - y);
        }
    }

    // Group 738 reacts once on backdrop contact. Groups 739–740 use the authored turn markers.
    var _touching = place_meeting(x, y, obj_player_backdrop);
    if (_touching && !terrain_contact) {
        float_speed *= -0.5;
    }
    terrain_contact = _touching;
    with (obj_wario_late_actor) {
        if (source_handle == 998 && place_meeting(x, y, other.id)) {
            other.y += 5;
            other.float_speed = 1;
        }
    }
    with (obj_wario_late_actor) {
        if (source_handle == 999 && place_meeting(x, y, other.id)) {
            other.y -= 5;
            other.float_speed = -1;
        }
    }
}

function wario_finger_laser_step() {
    if (!finger_armed) {
        var _player = instance_find(obj_player, 0);
        // Group 1185 compares the player hotspot against the trigger zone.
        finger_armed = _player != noone && _player.x >= 3562 && _player.x < 3622
            && _player.y >= 1177 && _player.y < 1209;
        return;
    }

    ++finger_age;
    if (finger_age == 1) {
        audio_play_sound(snd_wario_finger_laser, 1, false);
    }
    if (finger_age <= 90) {
        var _frame = max(0, (finger_age - 2) div 2);
        image_index = _frame < 13 ? _frame : 7 + (_frame - 13) mod 6;
        if (finger_age <= 31) {
            y -= 15;
        }
        if (finger_age > 40) {
            volley_wait_ms -= 20;
            if (volley_wait_ms <= 0) {
                volley_wait_ms += 250;
                wario_fire_finger_beams();
            }
        }
        if (finger_age == 90) {
            y -= 5;
            image_index = 0;
        }
    } else {
        // The disappearing animation holds the original first image for ten frames at 5 FPS.
        if (finger_age > 190) {
            instance_destroy();
        }
    }
}

function wario_fire_finger_beams() {
    // Group 1182 shoots from the current frame's action point.
    var _beam_x = x + (image_index < 9 ? 18 : 22);
    var _beam_y = y + (image_index < 8 ? 43 : 44);
    static _cosines = [97, 142, 181, 212, 236, 251];
    static _sines = [236, 212, 181, 142, 97, 49];
    for (var _frame = 0; _frame < 6; ++_frame) {
        // Fusion's built-in speed 50 uses 6.25 pixels per step and a 32-way direction table.
        instance_create_depth(_beam_x, _beam_y, depth - 1, obj_wario_finger_beam, {
            beam_frame: _frame,
            motion_x: _cosines[_frame] * 6.25 / 256,
            motion_y: _sines[_frame] * 6.25 / 256
        });
    }
}
