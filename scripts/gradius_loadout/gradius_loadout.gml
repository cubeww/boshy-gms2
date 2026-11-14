enum GradiusShot {
    Normal,
    Laser,
    Missile
}

function gradius_record_option_position() {
    for (var _i = 0; _i < array_length(options); ++_i) {
        var _option = options[_i];
        array_insert(_option.history, 0, [x, y]);
        if (array_length(_option.history) > _option.lag) {
            array_pop(_option.history);
        }
    }
}

function gradius_update_options() {
    // Groups 870–872 use delayed positions from the ship's movement history.
    for (var _i = 0; _i < array_length(options); ++_i) {
        var _option = options[_i];
        var _history = _option.history;
        var _target = array_length(_history) >= _option.lag ? _history[_option.lag - 1] : [0, 0];
        var _delta_x = (_target[0] - _option.x) * 0.4;
        var _delta_y = (_target[1] - _option.y) * 0.4;
        _option.x = floor(_option.x + _delta_x + clamp(_target[0], -1, 1));
        _option.y = floor(_option.y + _delta_y + clamp(_target[1], -1, 1));
        _option.animation_steps = (_option.animation_steps + 1) mod 20;
    }
}

function gradius_spawn_player_shot(_x, _y, _kind) {
    instance_create_depth(_x, _y, depth - 1, obj_gradius_player_shot, { shot_kind: _kind });
}

function gradius_fire_weapons(_pressed) {
    // G873–879 count held input toward the repeat interval. G880 counts only with Laser and an Option.
    --shot_repeat_steps;
    var _repeat = shot_repeat_steps == 0;
    if (_repeat) {
        shot_repeat_steps = 5;
    }
    var _fire_hull = _pressed || _repeat;
    var _fire_options = _fire_hull;
    var _option_count = array_length(options);
    if (laser_enabled && _option_count > 0) {
        --laser_option_repeat_steps;
        _fire_options = _pressed || laser_option_repeat_steps == 0;
        if (laser_option_repeat_steps == 0) {
            laser_option_repeat_steps = 5;
        }
    }
    var _kind = laser_enabled ? GradiusShot.Laser : GradiusShot.Normal;
    if (_fire_hull) {
        gradius_fire_hull(_kind);
    }
    if (_fire_options && _option_count > 0) {
        for (var _i = 0; _i < _option_count; ++_i) {
            var _option = options[_i];
            gradius_spawn_player_shot(_option.x + 20, _option.y + 2 * (_option.animation_steps div 10), _kind);
        }
        audio_play_sound(snd_gradius_shoot, 1, false);
    }
}

function gradius_fire_hull(_kind) {
    // The muzzle is the action point of the ship's current direction frame.
    static _muzzle_offsets = [[10, 3], [9, 1], [10, 2]];
    var _offset = _muzzle_offsets[image_index];
    var _muzzle_x = x + _offset[0] * 2;
    var _muzzle_y = y + _offset[1] * 2;
    // Group 873 accepts both 0 and 1 from Fusion's four-value chance roll.
    if (missiles_enabled && irandom(3) <= 1) {
        gradius_spawn_player_shot(_muzzle_x, _muzzle_y, GradiusShot.Missile);
    }

    if (double_enabled) {
        gradius_spawn_player_shot(_muzzle_x, _muzzle_y - 8, _kind);
        gradius_spawn_player_shot(_muzzle_x, _muzzle_y + 8, _kind);
    } else {
        gradius_spawn_player_shot(_muzzle_x, _muzzle_y, _kind);
    }
    audio_play_sound(snd_gradius_shoot, 1, false);
}

function gradius_spawn_capsule(_x, _y, _alternate = false) {
    var _sprite = _alternate ? spr_gradius_capsule_alternate : spr_gradius_capsule;
    instance_create_depth(_x, _y, 10, obj_gradius_capsule, { sprite_index: _sprite });
}

function gradius_collect_capsules() {
    // Groups 958–959 give both capsule types the same power meter behavior.
    var _ship = id;
    var _pose = image_index;
    image_index = rider_frame;
    with (obj_gradius_capsule) {
        if (place_meeting(x, y, _ship)) {
            ++_ship.pending_upgrade;
            audio_play_sound(snd_gradius_power_up, 1, false);
            instance_destroy();
        }
    }
    image_index = _pose;
}

function gradius_redeem_upgrade() {
    switch (pending_upgrade) {
        case 1:
            if (flight_speed >= 5) {
                return;
            }
            ++flight_speed;
            break;
        case 2:
            missiles_enabled = true;
            break;
        case 3:
            double_enabled = true;
            break;
        case 4:
            laser_enabled = true;
            double_enabled = false;
            break;
        default:
            var _count = array_length(options);
            if (_count >= 4) {
                return;
            }
            array_push(options, { x: 55, y: 54, lag: (_count + 1) * 20, history: [], animation_steps: 0 });
            break;
    }
    pending_upgrade = 0;
}
