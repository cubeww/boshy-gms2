function desert_push_walls_step(_player, _family, _hinge) {
    var _push = 0;
    with (obj_desert_push_wall) {
        if (wall_family != _family) {
            continue;
        }
        // G816/G820/G825 test the current location before taking a one-pixel step.
        if (advancing && !place_meeting(x, y, obj_player_backdrop)) {
            ++x;
        }
        if (_player != noone && _player.probe_overlaps(_player.left_probe, id)) {
            _push = push_strength;
        }
    }
    if (_push > 0) {
        // Active 23 has two coincident instances. The group pushes the selected player once.
        _player.x += 2;
        _player.force_horizontal_speed(_push);
    }
    with (obj_desert_push_wall) {
        if (wall_family != _family) {
            continue;
        }
        if (_player != noone && !spent && _player.x >= wake_zone[0] && _player.x < wake_zone[2]
            && _player.y >= wake_zone[1] && _player.y < wake_zone[3]) {
            advancing = true;
            spent = _family == 2;
        }
    }
    if (_push > 0 && _player.probe_overlaps(_player.right_probe, obj_player_backdrop)
        && _player.die()) {
        return noone;
    }
    if (_family == 2 && _hinge != noone) {
        with (obj_desert_push_wall) {
            if (wall_family == 2 && place_meeting(x, y, _hinge)) {
                // G829 stops the approaching wall and starts the pivot on contact.
                advancing = false;
                _hinge.turning = true;
            }
        }
        if (_push > 0 && _player.probe_overlaps(_player.right_probe, _hinge)) {
            // G942 also stops the pusher when the opposite probe meets the hinge.
            with (obj_desert_push_wall) {
                if (wall_family == 2) {
                    advancing = false;
                }
            }
            if (_player.die()) {
                return noone;
            }
        }
    }
    return _player;
}

function desert_moving_terrain_step(_player) {
    // G831 parks the usual probes while the snake's own probes are in use.
    if (desert_snake_is_mounted()) {
        _player = noone;
    }
    // G814–815 test the Down probe and then accelerate the selected ledge.
    with (obj_desert_crumbling_ledge) {
        if (_player != noone && _player.probe_overlaps(_player.down_probe, id)) {
            crumbling = true;
        }
        if (crumbling) {
            y = floor(y + fall_speed);
            fall_speed += 0.1;
            image_angle += 1;
        }
    }
    var _hinge = instance_find(obj_desert_hinge, 0);
    for (var _family = 0; _family < 3; ++_family) {
        _player = desert_push_walls_step(_player, _family, _hinge);
    }
    if (_player != noone) {
        // The crush checks above use the same probe positions as the wall contact.
        _player.refresh_collision_probes();
    }
    if (_hinge != noone && _hinge.turning && !_hinge.latched) {
        // G943–944 accelerate by half a degree per step until the horizontal stop.
        _hinge.hinge_speed += 0.5;
        _hinge.image_angle -= _hinge.hinge_speed;
        if (_hinge.hinge_speed >= 9) {
            _hinge.image_angle = _hinge.hinge_endpoint;
            _hinge.latched = true;
        }
    }
}

function desert_boost_take_shot(_player) {
    if (_player == noone) {
        return false;
    }
    var _target = instance_place(x, y, obj_desert_shot_target);
    if (_target == noone || _target.cooldown > 0) {
        return false;
    }
    // G999–1010 consume the shot and apply a variable-height launch for each target.
    _player.vsp = _target.launch_speed;
    _player.jump_cut_enabled = true;
    _target.cooldown = 50;
    _target.image_alpha = 55 / 255;
    return true;
}
