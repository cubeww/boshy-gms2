function green_greens_events_setup() {
    green_greens_early_traps_setup();
    green_greens_middle_traps_setup();

    green_event_steps = 0;
    green_bridge_voice = -1;
    green_spider_voice = -1;
    green_lift = inst_green_greens_cloud_lift;

    // Active 84 squares launch the player from either side before drifting away.
    green_bounce_blocks = [
        inst_green_greens_bounce_cloud_1,
        inst_green_greens_bounce_cloud_2,
        inst_green_greens_bounce_cloud_3,
        inst_green_greens_bounce_cloud_4,
        inst_green_greens_bounce_cloud_5,
        inst_green_greens_bounce_cloud_6,
        inst_green_greens_bounce_cloud_7,
        inst_green_greens_bounce_cloud_8,
        inst_green_greens_bounce_cloud_9,
        inst_green_greens_bounce_cloud_10,
        inst_green_greens_bounce_cloud_11,
        inst_green_greens_bounce_cloud_12,
        inst_green_greens_bounce_cloud_13,
        inst_green_greens_bounce_cloud_14,
        inst_green_greens_bounce_cloud_15,
        inst_green_greens_bounce_cloud_16,
        inst_green_greens_bounce_cloud_17,
        inst_green_greens_bounce_cloud_18,
        inst_green_greens_bounce_cloud_19,
        inst_green_greens_bounce_cloud_20,
        inst_green_greens_bounce_cloud_21,
        inst_green_greens_bounce_cloud_22,
        inst_green_greens_bounce_cloud_23,
        inst_green_greens_bounce_cloud_24,
        inst_green_greens_bounce_cloud_25,
        inst_green_greens_bounce_cloud_26,
        inst_green_greens_bounce_cloud_27,
        inst_green_greens_bounce_cloud_28,
        inst_green_greens_bounce_cloud_29,
        inst_green_greens_bounce_cloud_30,
        inst_green_greens_bounce_cloud_31,
        inst_green_greens_bounce_cloud_32,
        inst_green_greens_bounce_cloud_33,
        inst_green_greens_bounce_cloud_34
    ];

    green_chasing_kirby = inst_green_greens_chasing_kirby;
    green_late_spider = inst_green_greens_late_spider;
    green_bridge_hand = inst_green_greens_bridge_hand;

    // Fusion sends the moving spikes behind the other actors on the Game layer.
    green_switch_spike_phase = false;
    green_switch_spikes = [
        inst_green_greens_switch_spike_1,
        inst_green_greens_switch_spike_2,
        inst_green_greens_switch_spike_3,
        inst_green_greens_switch_spike_4,
        inst_green_greens_switch_spike_5,
        inst_green_greens_switch_spike_6,
        inst_green_greens_switch_spike_7,
        inst_green_greens_switch_spike_8,
        inst_green_greens_switch_spike_9,
        inst_green_greens_switch_spike_10,
        inst_green_greens_switch_spike_11,
        inst_green_greens_switch_spike_12,
        inst_green_greens_switch_spike_13,
        inst_green_greens_switch_spike_14,
        inst_green_greens_switch_spike_15,
        inst_green_greens_switch_spike_16,
        inst_green_greens_switch_spike_17,
        inst_green_greens_switch_spike_18,
        inst_green_greens_switch_spike_19,
        inst_green_greens_switch_spike_20,
        inst_green_greens_switch_spike_21,
        inst_green_greens_switch_spike_22,
        inst_green_greens_switch_spike_23,
        inst_green_greens_switch_spike_24,
        inst_green_greens_switch_spike_25,
        inst_green_greens_switch_spike_26,
        inst_green_greens_switch_spike_27,
        inst_green_greens_switch_spike_28,
        inst_green_greens_switch_spike_29,
        inst_green_greens_switch_spike_30,
        inst_green_greens_switch_spike_31,
        inst_green_greens_switch_spike_32,
        inst_green_greens_switch_spike_33,
        inst_green_greens_switch_spike_34,
        inst_green_greens_switch_spike_35,
        inst_green_greens_switch_spike_36,
        inst_green_greens_switch_spike_37,
        inst_green_greens_switch_spike_38,
        inst_green_greens_switch_spike_39
    ];
}

function green_greens_player_in_zone(_player, _zone) {
    return _player != noone && point_in_rectangle(_player.x, _player.y, _zone[0], _zone[1], _zone[2], _zone[3]);
}

function green_greens_events_step(_player) {
    var _jumped = _player != noone && _player.jumped_this_step;
    green_greens_early_traps_step(_player);
    if (!instance_exists(_player)) {
        _player = noone;
    }
    green_greens_middle_traps_step(_player);
    if (!instance_exists(_player)) {
        _player = noone;
    }

    ++green_event_steps;
    green_greens_step_lift(_player);
    green_greens_step_bounce_blocks(_player);
    if (green_greens_step_cloud_traps(_player)) {
        _player = noone;
    }
    green_greens_step_chases(_player);
    green_greens_step_switch_spikes(_jumped);
}

function green_greens_step_cloud_traps(_player) {
    var _hit = false;
    with (obj_green_greens_cloud_trap) {
        if (cloud_trap_ticks > 0) {
            // G990's forced animation advances past 100 at speed 40 and loops on its last frame.
            cloud_trap_ticks = min(cloud_trap_ticks + 1, 11);
            image_index = 1 + (cloud_trap_ticks * 40 - 1) div 100;
        }
        if (_player != noone && _player.boshy_mask_meeting(id)) {
            if (cloud_trap_ticks == 0) {
                cloud_trap_ticks = 1;
                image_index = 1;
            }
            _hit = true;
        }
    }
    return _hit && _player.die();
}

function green_greens_step_lift(_player) {
    if (_player == noone) {
        return;
    }
    // Groups 983–985. The occupied cloud rises and the empty cloud returns.
    var _lift = green_lift;
    var _riding = !_player.input_locked && _player.x > _lift.x - 7 && _player.x < _lift.x + 71
        && _player.y > _lift.y - 8 && _player.y < _lift.y + 18;
    if (_riding) {
        _lift.y -= 2;
        _player.y -= 2;
    } else {
        _lift.y = min(_lift.y + 1, _lift.ystart);
    }
}

function green_greens_step_bounce_blocks(_player) {
    var _can_bounce = _player != noone && !_player.input_locked;
    var _hit_down = false;
    var _hit_up = false;
    for (var _i = 0; _i < array_length(green_bounce_blocks); ++_i) {
        var _block = green_bounce_blocks[_i];
        if (!instance_exists(_block)) {
            continue;
        }

        if (_block.bounce_age < 0 && _can_bounce) {
            // Fusion groups 986–987 check the two 14 × 2 probes against the cloud silhouette.
            var _from_above = _player.probe_overlaps(_player.down_probe, _block);
            var _from_below = !_from_above && _player.probe_overlaps(_player.up_probe, _block);
            if (_from_above || _from_below) {
                _block.bounce_age = 0;
                _block.bounce_drift = _from_above ? 5 : -5;
                _hit_down = _hit_down || _from_above;
                _hit_up = _hit_up || _from_below;
                audio_play_sound(snd_prehistorik_kick, 1, false);
            }
        }
        if (_block.bounce_age >= 0) {
            // The drift and fade begin on the contact step.
            _block.y = floor(_block.y + _block.bounce_drift);
            _block.bounce_drift *= 0.9;
            ++_block.bounce_age;
            _block.image_alpha = max(0, 1 - _block.bounce_age * 5 / 128);
            if (_block.bounce_age == 50) {
                instance_destroy(_block);
            }
        }
    }

    if (_hit_down || _hit_up) {
        // The Up event follows the Down event when both probes hit separate clouds.
        _player.vsp = _hit_up ? 8 : -8;
    }
}

function green_greens_step_chases(_player) {
    var _kirby = green_chasing_kirby;
    if (instance_exists(_kirby)) {
        if (green_greens_player_in_zone(_player, _kirby.despawn_zone)) {
            instance_destroy(_kirby);
        } else {
            if (green_greens_player_in_zone(_player, _kirby.trigger_zone)) {
                _kirby.chasing = true;
            }
            if (_kirby.chasing) {
                _kirby.image_xscale = 5;
                _kirby.image_yscale = 5;
                _kirby.x -= 4;
            }
        }
    }

    var _spider = green_late_spider;
    if (instance_exists(_spider)) {
        if (_spider.attack_age < 0 && green_greens_player_in_zone(_player, _spider.trigger_zone)) {
            _spider.attack_age = 0;
            green_spider_voice = audio_play_sound(snd_prehistorik_spider_scream, 1, false);
        }
        if (_spider.attack_age >= 0) {
            var _angle = dsin(green_event_steps * 20) * 20;
            _spider.image_xscale = 2;
            _spider.image_yscale = 2;
            if (_spider.attack_age < 250) {
                _spider.y -= 10;
                _spider.image_angle = _angle;
                ++_spider.attack_age;
            }
            if (_spider.attack_age >= 250 && _player != noone) {
                if (_spider.attack_age == 250) {
                    audio_stop_sound(green_spider_voice);
                    green_spider_voice = audio_play_sound(snd_prehistorik_spider_scream, 1, false);
                }
                _spider.y += 40;
                _spider.image_angle = 180 + _angle;
                ++_spider.attack_age;
            }
            // Group 885 increments the counter after the movement events in groups 881–883.
            ++_spider.attack_age;
            if (_spider.y > 2160) {
                instance_destroy(_spider);
            }
        }
    }

    // Groups 1373–1375. The hand shoots up through the bridge for ten steps.
    var _hand = green_bridge_hand;
    if (_hand.rise_steps < 0 && green_greens_player_in_zone(_player, _hand.trigger_zone)) {
        _hand.rise_steps = 10;
        green_bridge_voice = audio_play_sound(snd_green_greens_bridge_hand, 1, false);
    }
    if (_hand.rise_steps > 0) {
        _hand.y -= 32;
        --_hand.rise_steps;
    }
}

function green_greens_step_switch_spikes(_jumped) {
    // Each spike keeps the previous target for this step's move (Fusion groups 907–930).
    if (_jumped) {
        green_switch_spike_phase = !green_switch_spike_phase;
    }
    for (var _i = 0; _i < array_length(green_switch_spikes); ++_i) {
        var _spike = green_switch_spikes[_i];
        // Fusion adds +1 for these positive target coordinates, then rounds the result down.
        _spike.y = floor(_spike.y + (_spike.target_y - _spike.y) * 0.2 + 1);
        _spike.target_y = green_switch_spike_phase ? _spike.second_y : _spike.first_y;
    }
}

function green_greens_events_draw() {
    green_greens_early_traps_draw();
    green_greens_middle_traps_draw();
}

function green_greens_events_cleanup() {
    if (green_spider_voice != -1) {
        audio_stop_sound(green_spider_voice);
    }
    if (green_bridge_voice != -1) {
        audio_stop_sound(green_bridge_voice);
    }
}
