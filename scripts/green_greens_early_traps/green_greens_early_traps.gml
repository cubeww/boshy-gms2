function green_greens_early_traps_setup() {
    early_phase_platforms = [
        inst_green_greens_phase_0_platform_1,
        inst_green_greens_phase_0_platform_2,
        inst_green_greens_phase_0_platform_3,
        inst_green_greens_phase_0_platform_4,
        inst_green_greens_phase_0_platform_5,
        inst_green_greens_phase_0_platform_6,
        inst_green_greens_phase_0_platform_7,
        inst_green_greens_phase_1_platform_1,
        inst_green_greens_phase_1_platform_2,
        inst_green_greens_phase_1_platform_3,
        inst_green_greens_phase_1_platform_4,
        inst_green_greens_phase_1_platform_5,
        inst_green_greens_phase_1_platform_6
    ];
    early_phase_steps = 0;
    green_greens_early_set_phase(0);

    early_rider_platforms = [
        inst_green_greens_rider_platform_1,
        inst_green_greens_rider_platform_2,
        inst_green_greens_rider_platform_3,
        inst_green_greens_rider_platform_4,
        inst_green_greens_rider_platform_5,
        inst_green_greens_rider_platform_6
    ];
    early_rider_probe_x = -66;
    early_rider_probe_y = 154;

    early_side_spike = inst_green_greens_early_side_spike;
    early_offset_spike = inst_green_greens_early_offset_spike;
    early_rising_spike = inst_green_greens_early_rising_spike;
    early_kirby = inst_green_greens_early_kirby;
}

function green_greens_early_set_phase(_phase) {
    // Groups 674–679 alternate which platform set has a collision mask.
    early_platform_phase = _phase;
    for (var _i = 0; _i < array_length(early_phase_platforms); ++_i) {
        var _platform = early_phase_platforms[_i];
        _platform.sprite_index = _platform.phase == _phase ? _platform.platform_sprite : -1;
    }
}

function green_greens_early_traps_step(_player) {
    ++early_phase_steps;
    var _phase = (early_phase_steps div 50) mod 2;
    if (_phase != early_platform_phase) {
        green_greens_early_set_phase(_phase);
    }

    if (_player != noone && !_player.input_locked) {
        green_greens_early_move_lifts(_player);
    }
    green_greens_early_step_spikes(_player);
    green_greens_early_step_kirby(_player);
}

function green_greens_early_move_lifts(_player) {
    // Groups 681–688 and 707–712 move the platforms with a rider and reset them when clear.
    // Active 13 uses image 903 and follows the player after the platform events.
    static _rider_probe = { left: -11, top: -23, right: 12, bottom: 2 };
    for (var _i = 0; _i < array_length(early_rider_platforms); ++_i) {
        var _lift = early_rider_platforms[_i];
        var _inside = _player.x > _lift.x && _player.x < _lift.x + _lift.rider_span && _player.y > _lift.y - 8;
        var _riding = _i < 3
            ? _player.probe_overlaps(_rider_probe, _lift, early_rider_probe_x, early_rider_probe_y)
            : _inside && _player.y < _lift.y + 18;
        if (_riding) {
            _lift.y += _lift.ride_dy;
            _player.y += _lift.ride_dy;
        }
        if ((_player.x <= _lift.x || _player.x >= _lift.x + _lift.rider_span || _player.y <= _lift.y - 8)
            && sign(_lift.y - _lift.rest_y) == sign(_lift.ride_dy)) {
            _lift.y -= sign(_lift.ride_dy);
        }
    }
}

function green_greens_early_step_spikes(_player) {
    // Groups 689–693 and 709–710. The offset spike changes position only while triggered.
    if (instance_exists(early_side_spike)) {
        if (green_greens_player_in_zone(_player, early_side_spike.trigger_zone)) {
            early_side_spike.triggered = true;
        }
        if (early_side_spike.triggered) {
            early_side_spike.x += 15;
            if (early_side_spike.x > room_width) {
                instance_destroy(early_side_spike);
            }
        }
    }
    if (green_greens_player_in_zone(_player, early_offset_spike.trigger_zone)) {
        early_offset_spike.x = early_offset_spike.trigger_x;
        early_offset_spike.y = early_offset_spike.trigger_y;
    }
    if (instance_exists(early_rising_spike)) {
        if (green_greens_player_in_zone(_player, early_rising_spike.trigger_zone)) {
            early_rising_spike.triggered = true;
        }
        if (early_rising_spike.triggered) {
            early_rising_spike.y -= 15;
            if (early_rising_spike.y < -640) {
                instance_destroy(early_rising_spike);
            }
        }
    }
}

function green_greens_early_step_kirby(_player) {
    var _kirby = early_kirby;
    if (_player != noone && !_player.input_locked && !_kirby.carrying && !global.debug_invincible) {
        // Groups 699–701 use separate horizontal and vertical suction zones.
        if (point_in_rectangle(_player.x, _player.y, _kirby.x - 100, _kirby.y - 100, _kirby.x, _kirby.y + 5)) {
            _player.x += floor(abs(_player.x - _kirby.x) * 0.05) + 3;
        }
        if (point_in_rectangle(_player.x, _player.y, _kirby.x - 100, _kirby.y - 100, _kirby.x, _kirby.y - 10)) {
            _player.y += floor(abs(_player.y - _kirby.y) * 0.05);
        }
        if (collision_rectangle(_player.bbox_left, _player.bbox_top, _player.bbox_right, _player.bbox_bottom,
            _kirby, true, true) != noone) {
            _player.input_locked = true;
            _player.visible = false;
            _player.hsp = 0;
            _player.vsp = 0;
            _kirby.carrying = true;
            _kirby.sprite_index = spr_green_greens_early_kirby_walk;
            _kirby.image_index = 0;
            _kirby.image_speed = 1;
        } else if (_kirby.vertical_speed >= 0
            && point_in_rectangle(_player.x, _player.y, _kirby.x - 20, _kirby.y - 100, _kirby.x, _kirby.y - 1)) {
            _kirby.vertical_speed = -5;
            _kirby.jumping = true;
        }
    }

    if (_kirby.carrying) {
        // Groups 702–704 carry the hidden player and start a jump at step 30.
        if (_player != noone) {
            _player.x = _kirby.x;
            _player.y = _kirby.y;
            if (_player.bbox_top > 1920 || _player.bbox_left >= room_width) {
                _player.die(true);
            }
        }
        ++_kirby.x;
        ++_kirby.carry_steps;
        if (_kirby.carry_steps == 30) {
            _kirby.vertical_speed = -5;
            _kirby.jumping = true;
        }
    } else {
        var _frame = _kirby.animation_steps div 2;
        _kirby.image_index = _frame == 0 ? 0 : 1 + ((_frame - 1) mod 2);
        ++_kirby.animation_steps;
    }

    if (_kirby.jumping) {
        _kirby.y = floor(_kirby.y + _kirby.vertical_speed);
        _kirby.vertical_speed += 0.2;
        with (_kirby) {
            if (vertical_speed >= 0 && terrain_meeting(x, y)) {
                jumping = false;
            }
        }
    }
}

function green_greens_early_traps_draw() {
    for (var _i = 0; _i < array_length(early_phase_platforms); ++_i) {
        var _platform = early_phase_platforms[_i];
        draw_sprite_ext(_platform.platform_sprite, _platform.phase == early_platform_phase ? 0 : 1,
            _platform.x, _platform.y, _platform.image_xscale, _platform.image_yscale,
            _platform.image_angle, _platform.image_blend, _platform.image_alpha);
    }
}
