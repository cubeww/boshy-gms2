function desert_snake_is_mounted() {
    var _snake = instance_find(obj_desert_snake, 0);
    return _snake != noone && _snake.mounted;
}

function desert_snake_sync_player(_player) {
    var _snake = instance_find(obj_desert_snake, 0);
    if (_snake == noone || !_snake.mounted) {
        return noone;
    }
    _snake.sync_rider_position(_player);
    return _snake;
}

function desert_snake_movement() {
    static _movement = { run_speed: 5, acceleration: 0.25, deceleration: 0.1,
        gravity: 0.45, jump_speed: 12 };
    return _movement;
}

function desert_snake_move(_player, _snake) {
    // G832–840 move Active 26 using its own four two-pixel backdrop probes.
    repeat (floor(abs(_player.hsp))) {
        var _left = _player.probe_overlaps(_snake.left_probe, obj_player_backdrop, _snake.x, _snake.y);
        var _right = _player.probe_overlaps(_snake.right_probe, obj_player_backdrop, _snake.x, _snake.y);
        if (_player.hsp < 0 && !_left) {
            --_snake.x;
        } else if (_player.hsp > 0 && !_right) {
            ++_snake.x;
        }
        if (_left || _right) {
            _player.hsp = 0;
        }
        desert_phase_move_x(_player);
    }
    if (_player.vsp != 0) {
        repeat (floor(abs(_player.vsp)) + 1) {
            var _direction = sign(_player.vsp);
            var _probe = _direction < 0 ? _snake.up_probe : _snake.down_probe;
            if (_player.probe_overlaps(_probe, obj_player_backdrop, _snake.x, _snake.y)) {
                _player.vsp = 0;
            } else {
                _snake.y += _direction;
            }
            desert_phase_move_y(_player);
            if (_player.vsp == 0) {
                break;
            }
        }
    }
    _player.grounded = _player.vsp >= 0
        && _player.probe_overlaps(_snake.down_probe, obj_player_backdrop, _snake.x, _snake.y);
    if (_player.grounded) {
        _player.vsp = 0;
    } else {
        var _movement = desert_snake_movement();
        _player.vsp += _movement.gravity;
    }
    _snake.sync_rider_position(_player);

    // G843 creates dust at the snake's feet on the room timer's 150 ms pulses.
    if (_snake.dust_clock < 20 && _player.grounded && (_player.hsp > 0.5 || _player.hsp <= -0.5)) {
        instance_create_depth(_snake.x, _snake.y + 16, _snake.depth - 1, obj_desert_snake_dust);
    }
}

function desert_snake_stomp(_player, _snake) {
    // G860/866/878/884 rebound only on contact with the lower snake probe.
    with (obj_desert_snake_hopper) {
        if (_player.probe_overlaps(_snake.down_probe, id, _snake.x, _snake.y)) {
            _player.vsp = rider_rebound;
            _player.grounded = false;
            _player.jump_cut_enabled = true;
            repeat (71) {
                instance_create_depth(x, y, depth - 1, obj_blood);
            }
            instance_destroy();
        }
    }
}
