enum MegaManOrdnance {
    Bomb,
    SecondaryBomb,
    Charge,
    Spinner,
    Explosion
}

function mega_man_spawn_bomb(_x, _y, _vx, _vy = 0) {
    return instance_create_depth(_x, _y, depth - 1, obj_mega_man_ordnance, {
        ordnance_kind: MegaManOrdnance.Bomb,
        ordnance_vx: _vx,
        ordnance_vy: _vy,
        sprite_index: spr_mega_man_ordnance_bomb
    });
}

function mega_man_spawn_charge(_x, _y) {
    // Fusion G709 chooses one of the two downward diagonals at movement speed 30.
    return instance_create_depth(_x, _y, depth - 1, obj_mega_man_ordnance, {
        ordnance_kind: MegaManOrdnance.Charge,
        ordnance_direction: 20 + irandom(1) * 8,
        sprite_index: spr_mega_man_ordnance_charge
    });
}

function mega_man_spawn_spinner(_x, _y, _direction) {
    return instance_create_depth(_x, _y, depth - 1, obj_mega_man_ordnance, {
        ordnance_kind: MegaManOrdnance.Spinner,
        ordnance_direction: _direction,
        ordnance_age: 100,
        sprite_index: spr_mega_man_ordnance_spinner
    });
}

function mega_man_spawn_explosion(_x, _y, _scale = 1, _depth = undefined) {
    if (is_undefined(_depth)) {
        _depth = depth - 1;
    }
    return instance_create_depth(_x, _y, _depth, obj_mega_man_ordnance, {
        ordnance_kind: MegaManOrdnance.Explosion,
        sprite_index: spr_mega_man_victory_blast,
        image_xscale: _scale,
        image_yscale: _scale
    });
}

function mega_man_bomb_ordnance_step() {
    // G862 and G866 apply each position update as an integer.
    // G863–865 and G867 impact only on background contact below Y 400.
    y = floor(y + ordnance_vy);
    ordnance_vy += 0.5;
    x += ordnance_vx;

    if (y > 400 && place_meeting(x, y, obj_player_backdrop)) {
        if (ordnance_kind == MegaManOrdnance.Bomb) {
            instance_create_depth(x, y - 32, depth, obj_mega_man_ordnance, {
                ordnance_kind: MegaManOrdnance.SecondaryBomb,
                ordnance_vx: -5, ordnance_vy: -10, sprite_index: spr_mega_man_ordnance_bomb
            });
            instance_create_depth(x, y - 32, depth, obj_mega_man_ordnance, {
                ordnance_kind: MegaManOrdnance.SecondaryBomb,
                ordnance_vx: 5, ordnance_vy: -10, sprite_index: spr_mega_man_ordnance_bomb
            });
            with (obj_mega_man) {
                shake_strength = 15;
                blur_strength = 2;
            }
        }
        mega_man_spawn_explosion(x, y, 1, depth);
        instance_destroy();
    } else if (bbox_top > room_height || bbox_right < -480 || bbox_left > room_width + 480) {
        instance_destroy();
    }
}

function mega_man_charge_vector(_direction, _distance) {
    // Fusion retains fractional ball movement with 8-bit direction coefficients.
    var _angle = _direction * 11.25;
    var _cosine = dcos(_angle);
    var _sine = dsin(_angle);
    return {
        x: _distance * sign(_cosine) * floor(abs(_cosine) * 256) / 256,
        y: -_distance * sign(_sine) * floor(abs(_sine) * 256) / 256
    };
}

function mega_man_charge_path_clear(_direction) {
    var _probe = mega_man_charge_vector(_direction, 8);
    return !place_meeting(floor(ordnance_x + _probe.x), floor(ordnance_y + _probe.y), obj_player_backdrop);
}

function mega_man_charge_step() {
    var _previous_x = x;
    var _previous_y = y;
    var _motion = mega_man_charge_vector(ordnance_direction, 30 / 8);
    ordnance_x += _motion.x;
    ordnance_y += _motion.y;
    x = floor(ordnance_x);
    y = floor(ordnance_y);

    if (place_meeting(x, y, obj_player_backdrop)) {
        var _wall = place_meeting(x, _previous_y, obj_player_backdrop);
        var _floor = place_meeting(_previous_x, y, obj_player_backdrop);
        var _steps = max(abs(x - _previous_x), abs(y - _previous_y));
        for (var _i = _steps - 1; _i >= 0; --_i) {
            var _ratio = _i / _steps;
            var _try_x = floor(lerp(_previous_x, x, _ratio));
            var _try_y = floor(lerp(_previous_y, y, _ratio));
            if (!place_meeting(_try_x, _try_y, obj_player_backdrop)) {
                _previous_x = _try_x;
                _previous_y = _try_y;
                break;
            }
        }
        ordnance_x += _previous_x - x;
        ordnance_y += _previous_y - y;
        x = _previous_x;
        y = _previous_y;

        // G714 uses the native Ball bounce with 32 directions and randomizer 20.
        var _bounce = ordnance_direction;
        if (_wall) {
            _bounce = 16 - _bounce;
        }
        if (_floor || !_wall) {
            _bounce = -_bounce;
        }
        _bounce = _bounce & 31;
        if (!mega_man_charge_path_clear(_bounce)) {
            var _blocked = true;
            for (var _offset = 4; _offset <= 16; _offset += 4) {
                if (mega_man_charge_path_clear((_bounce - _offset) & 31)) {
                    _bounce = (_bounce - _offset) & 31;
                    _blocked = false;
                    break;
                }
                if (mega_man_charge_path_clear((_bounce + _offset) & 31)) {
                    _bounce = (_bounce + _offset) & 31;
                    _blocked = false;
                    break;
                }
            }
            if (_blocked) {
                ordnance_direction = irandom(31);
                return;
            }
        }
        var _random = irandom(99);
        var _random_direction = ((_random div 4) - 12) & 31;
        if (_random < 20 && mega_man_charge_path_clear(_random_direction)) {
            _bounce = _random_direction;
        }
        if ((_bounce & 7) == 0) {
            if (--ordnance_straight_bounces < 0) {
                var _redirect = (_bounce + (irandom(1) * 2 - 1)) & 31;
                if (mega_man_charge_path_clear(_redirect)) {
                    _bounce = _redirect;
                    ordnance_straight_bounces = 5;
                }
            }
        } else {
            ordnance_straight_bounces = 5;
        }
        ordnance_direction = _bounce;
    }
}
