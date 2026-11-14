function kid_icarus_collect_coins(_x, _y) {
    // G820/G823 run inside the vertical loop, using the Active 50 mask.
    with (obj_kid_icarus_mechanics_probe) {
        if (!place_meeting(_x, _y, obj_kid_icarus_coin)) {
            return;
        }
        var _coins = ds_list_create();
        var _count = instance_place_list(_x, _y, obj_kid_icarus_coin, _coins, false);
        for (var _i = 0; _i < _count; ++_i) {
            var _coin = _coins[| _i];
            if (_coin.sprite_index == spr_kid_icarus_coin) {
                instance_destroy(_coin);
                audio_play_sound(snd_kid_icarus_coin, 1, false);
            }
        }
        ds_list_destroy(_coins);
    }
}

function kid_icarus_koopas_step(_player, _scene_steps) {
    var _needed_for_gate = false;
    var _arc = dcos(_scene_steps * 2) * 64;
    for (var _group = 0; _group < 4; ++_group) {
        with (obj_kid_icarus_koopa) {
            if (koopa_group != _group) {
                continue;
            }

            // G806–813 and G868–874 use opposite phases for the paired groups.
            var _early = _group < 2;
            var _lethal = _group mod 2 == 0;
            y = floor(koopa_start_y + (_lethal ? _arc : -_arc));
            if (_player != noone) {
                var _feet_overlap = _player.probe_overlaps(_player.down_probe, id);
                var _body_overlap = _lethal && _player.boshy_mask_meeting(id);
                var _stomp = _early ? _feet_overlap && !koopa_touching_feet && _player.vsp >= 0
                    : _feet_overlap && _player.vsp > 0;
                koopa_touching_feet = _feet_overlap;
                if (_stomp) {
                    _player.vsp = -7;
                    _player.grounded = false;
                    _player.air_jump_available = true;
                    _player.jump_cut_enabled = false;
                    var _kick = audio_play_sound(snd_prehistorik_kick, 1, false);
                    audio_sound_pitch(_kick, 44000 / 22050);
                    instance_destroy();
                    continue;
                }
                if (_body_overlap && (!_early || !koopa_touching_body) && _player.vsp < 0 && _player.die()) {
                    _player = noone;
                }
                koopa_touching_body = _body_overlap;
            }
            if (_early && x >= 824 && x < 1284 && y >= 7760 && y < 8170) {
                _needed_for_gate = true;
            }
        }
    }
    if (!_needed_for_gate) {
        with (obj_kid_icarus_koopa_gate) {
            instance_destroy();
        }
    }
}

function kid_icarus_coin_walker_step() {
    with (obj_kid_icarus_coin_switch) {
        // G818–819 use a two-frame reaction clip at 15% animation speed.
        if (switch_press_steps > 0 && --switch_press_steps == 0) {
            sprite_index = switch_direction > 0 ? spr_kid_icarus_coin_switch_left : spr_kid_icarus_coin_switch_right;
        }
    }

    var _contacts = ds_list_create();
    with (obj_kid_icarus_coin_walker) {
        x += walker_speed * walker_direction;
        sprite_index = walker_direction > 0 ? spr_kid_icarus_coin_walker_right : spr_kid_icarus_coin_walker_left;
        ds_list_clear(_contacts);
        var _count = instance_place_list(x, y, obj_kid_icarus_coin_switch, _contacts, false);
        var _new_contacts = [];
        for (var _i = 0; _i < _count; ++_i) {
            var _switch = _contacts[| _i];
            if (!array_contains(walker_contacts, _switch)) {
                walker_direction = -walker_direction;
                _switch.sprite_index = _switch.switch_direction > 0
                    ? spr_kid_icarus_coin_switch_left_pressed : spr_kid_icarus_coin_switch_right_pressed;
                _switch.switch_press_steps = 14;
            }
            array_push(_new_contacts, _switch);
        }
        walker_contacts = _new_contacts;

        // G821–825 swap the coin and solid-tile clips with the walker's flag.
        var _direction = walker_direction;
        with (obj_kid_icarus_coin) {
            var _sprite = _direction == coin_direction ? spr_kid_icarus_coin : spr_kid_icarus_coin_block;
            if (sprite_index != _sprite) {
                sprite_index = _sprite;
                image_index = 0;
            }
        }
    }
    ds_list_destroy(_contacts);
}

function kid_icarus_sliding_blocks_step(_player) {
    var _body = instance_find(obj_kid_icarus_mechanics_probe, 0);
    var _can_push = _player != noone && !_player.input_locked;
    var _horizontal = 0;
    var _player_x = 0;
    var _player_y = 0;
    if (_can_push) {
        var _keys = global.settings.keys;
        var _right = keyboard_check(_keys.right);
        var _left = keyboard_check(_keys.left);
        _horizontal = (_right || _left) ? _right - _left : sign(_player.hsp);
        _player_x = floor(_player.x);
        _player_y = floor(_player.y);
    }
    with (obj_kid_icarus_sliding_block) {
        if (_can_push && block_vx == 0 && block_vy == 0) {
            var _from_left = _player_x < bbox_left;
            var _from_right = _player_x > bbox_right;
            var _side_direction = _from_left - _from_right;
            if (_side_direction != 0 && _horizontal == _side_direction) {
                var _side = _from_left ? _player.right_probe : _player.left_probe;
                if (_player.probe_overlaps(_side, id, _player_x, _player_y)) {
                    block_vx = _side_direction * 6.25;
                }
            } else if (_side_direction == 0) {
                // Require a top or bottom approach. A wide body-probe hit can also be a corner graze.
                var _vertical = _player.sliding_block_vertical_direction;
                var _approaching_face = (_vertical > 0 && _player_y <= bbox_top)
                    || (_vertical < 0 && _player_y > bbox_bottom);
                if (_approaching_face) {
                    var _block = id;
                    with (_body) {
                        if (place_meeting(_player_x, _player_y, _block)) {
                            _block.block_vy = _vertical * 6.25;
                        }
                    }
                }
            }
        }
        var _travel = max(abs(block_vx), abs(block_vy));
        if (_travel == 0) {
            continue;
        }
        var _start_x = x;
        var _start_y = y;
        for (var _distance = 1; _distance <= ceil(_travel); ++_distance) {
            var _fraction = min(_distance, _travel) / _travel;
            var _next_x = _start_x + block_vx * _fraction;
            var _next_y = _start_y + block_vy * _fraction;
            if (place_meeting(_next_x, _next_y, obj_kid_icarus_phase_block)) {
                block_vx = 0;
                block_vy = 0;
                break;
            }
            x = _next_x;
            y = _next_y;
            var _gate = instance_place(x, y, obj_kid_icarus_block_gate);
            if (_gate != noone) {
                // G866 stops on a phase block. G867 destroys a matching gate on contact.
                instance_destroy(_gate);
                instance_create_layer(x + 16, y + 16, layer, obj_kid_icarus_block_burst);
                instance_destroy();
                break;
            }
        }
    }
}

function kid_icarus_mechanics_step(_player, _scene_steps) {
    // G798–805 start the counter at -32 and reverse before the move at 32.
    with (obj_kid_icarus_oscillating_spike) {
        if (++oscillation_steps == 32) {
            oscillation_steps = 0;
            oscillation_direction = -oscillation_direction;
        }
        y += oscillation_direction;
    }
    kid_icarus_koopas_step(_player, _scene_steps);
    if (!instance_exists(_player)) {
        _player = noone;
    }
    kid_icarus_coin_walker_step();
    kid_icarus_sliding_blocks_step(_player);
}
