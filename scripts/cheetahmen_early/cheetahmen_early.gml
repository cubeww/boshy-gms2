function cheetahmen_early_setup() {
    cheetah_early_steps = 0;
    cheetah_runners_started = false;
    cheetah_runners = [inst_cheetahmen_early_208, inst_cheetahmen_early_266, inst_cheetahmen_early_267];
    cheetah_breakable_wall = [inst_cheetahmen_early_423, inst_cheetahmen_early_424,
        inst_cheetahmen_early_439, inst_cheetahmen_early_440];
    cheetah_falling_platforms = [inst_cheetahmen_early_576, inst_cheetahmen_early_598,
        inst_cheetahmen_early_600, inst_cheetahmen_early_605, inst_cheetahmen_early_601,
        inst_cheetahmen_early_577, inst_cheetahmen_early_1043, inst_cheetahmen_early_1044,
        inst_cheetahmen_early_1045, inst_cheetahmen_early_1046, inst_cheetahmen_early_1601];
    cheetah_falling_ledge = inst_cheetahmen_early_1406;
    cheetah_spike_columns = [inst_cheetahmen_early_900, inst_cheetahmen_early_901,
        inst_cheetahmen_early_902, inst_cheetahmen_early_903, inst_cheetahmen_early_904,
        inst_cheetahmen_early_906, inst_cheetahmen_early_908, inst_cheetahmen_early_920,
        inst_cheetahmen_early_921, inst_cheetahmen_early_922, inst_cheetahmen_early_923,
        inst_cheetahmen_early_924, inst_cheetahmen_early_926, inst_cheetahmen_early_927,
        inst_cheetahmen_early_917, inst_cheetahmen_early_905, inst_cheetahmen_early_928,
        inst_cheetahmen_early_929, inst_cheetahmen_early_930, inst_cheetahmen_early_919];

    cheetah_archer = inst_cheetahmen_early_1725;
    cheetah_archer_phase = 0;
    cheetah_archer_running = false;
    cheetah_archer_shot_steps = 0;
    cheetah_archer_shot_timer = 0;
    cheetah_arrows = [inst_cheetahmen_early_1789, inst_cheetahmen_early_1865];
    cheetah_critical_steps = 0;
    cheetah_critical_sound = -1;
}

function cheetahmen_early_step(_player) {
    ++cheetah_early_steps;
    cheetahmen_step_runners(_player);
    cheetahmen_step_falling_platforms(_player);

    // Groups 705–708 move the twenty opposing spikes down three pixels each step.
    for (var _i = 0; _i < array_length(cheetah_spike_columns); ++_i) {
        var _spike = cheetah_spike_columns[_i];
        _spike.y = _spike.y + 3 > 368 ? -32 : _spike.y + 3;
    }

    cheetahmen_step_critical_trap(_player);
}

function cheetahmen_step_runners(_player) {
    // Groups 690–696 release the three enemies onto the floor of the second screen.
    if (_player != noone && point_in_rectangle(_player.x, _player.y, 379, 399, 1234, 489)) {
        cheetah_runners_started = true;
    }
    if (!cheetah_runners_started) {
        return;
    }

    for (var _i = 0; _i < array_length(cheetah_runners); ++_i) {
        var _runner = cheetah_runners[_i];
        if (!instance_exists(_runner)) {
            continue;
        }
        _runner.x += 3;
        if (_runner.x >= 1423) {
            instance_destroy(_runner);
            continue;
        }
        if (_i > 0) {
            for (var _j = 0; _j < array_length(cheetah_breakable_wall); ++_j) {
                var _rock = cheetah_breakable_wall[_j];
                if (!instance_exists(_rock)) {
                    continue;
                }
                with (_runner) {
                    if (place_meeting(x, y, _rock)) {
                        instance_destroy(_rock);
                    }
                }
            }
        }
    }
}

function cheetahmen_step_falling_platforms(_player) {
    // Groups 697–700 and 709–713 carry the player down while the tile falls.
    var _ledge = cheetah_falling_ledge;
    for (var _i = 0; _i < array_length(cheetah_falling_platforms); ++_i) {
        var _platform = cheetah_falling_platforms[_i];
        if (!instance_exists(_platform)) {
            continue;
        }
        cheetahmen_step_falling_platform(_platform, _player, _i < 6);
        if (_platform.y >= room_height) {
            instance_destroy(_platform);
            continue;
        }
        if (instance_exists(_ledge) && _platform.sprite_index == spr_cheetahmen_falling_tile) {
            with (_platform) {
                if (place_meeting(x, y, _ledge)) {
                    instance_destroy();
                }
            }
        }
    }
    if (instance_exists(_ledge)) {
        cheetahmen_step_falling_platform(_ledge, _player, false);
        if (_ledge.y >= room_height) {
            instance_destroy(_ledge);
        }
    }
}

function cheetahmen_step_falling_platform(_platform, _player, _snap_rider) {
    // Active 23 uses image 649 and refreshes with the movement probes.
    static _rider_probe = { left: -7, top: -13, right: 8, bottom: 2 };
    var _riding = _player != noone && !_player.input_locked && _player.probe_overlaps(_rider_probe, _platform);
    if (_riding) {
        _platform.drop_active = true;
        if (_snap_rider) {
            _player.y = _platform.y + 2;
        } else {
            _player.y += 2;
        }
    }
    if (_platform.drop_active) {
        _platform.y += 2;
    }
}

function cheetahmen_step_archer(_player) {
    var _archer = cheetah_archer;
    if (!instance_exists(_archer)) {
        return;
    }

    // Groups 722–730 alternate volleys with a rapid run into the next screen.
    static _lanes = [[2174, 42, 2549, 338], [2648, 45, 3204, 341], [3211, 46, 3847, 342]];
    static _advance_x = [2488, 3050, 3795];
    static _shoot_limit_x = [2488, 3050, 3784];
    static _stop_x = [3151, 3791];
    static _shot_interval = [200, 30, 150];
    var _phase = cheetah_archer_phase;
    if (_player != noone && _player.x >= _advance_x[_phase]) {
        if (_phase == 2) {
            instance_destroy(_archer);
            return;
        }
        cheetah_archer_running = true;
    }
    if (cheetah_archer_running) {
        _archer.sprite_index = spr_cheetahmen_archer_idle;
        cheetah_archer_shot_steps = 0;
        if (_archer.x >= _stop_x[_phase]) {
            cheetah_archer_running = false;
            cheetah_archer_shot_timer = 0;
            ++cheetah_archer_phase;
        } else {
            _archer.x += 20;
        }
        return;
    }

    if (cheetah_archer_shot_steps > 0 && --cheetah_archer_shot_steps == 0) {
        _archer.sprite_index = spr_cheetahmen_archer_idle_left;
    }
    if (_player == noone) {
        return;
    }
    var _lane = _lanes[_phase];
    if (_player.x < _lane[0] || _player.x >= _lane[2] || _player.y < _lane[1] || _player.y >= _lane[3]) {
        return;
    }
    cheetah_archer_shot_timer += 20;
    var _interval = _shot_interval[_phase];
    if (cheetah_archer_shot_timer < _interval) {
        return;
    }
    cheetah_archer_shot_timer -= _interval;
    if (_player.x >= _shoot_limit_x[_phase]) {
        return;
    }

    var _heading;
    // Groups 723–724 add 32 pixels below the archer's current action point.
    var _arrow_x = _archer.x - 17;
    var _arrow_y = _archer.y - 7;
    var _arrow_speed = 1;
    switch (_phase) {
        case 0:
            _heading = 180 + dsin(cheetah_early_steps * 2) * 50;
            _arrow_x = 2511;
            _arrow_y = 255;
            break;
        case 1:
            // Group 723 creates the arrow before it changes the archer's pose.
            switch (_archer.sprite_index) {
                case spr_cheetahmen_archer_idle:
                    _arrow_x = _archer.x - 1;
                    _arrow_y = _archer.y - 3;
                    break;
                case spr_cheetahmen_archer_idle_left:
                    _arrow_x = _archer.x + 31;
                    _arrow_y = _archer.y - 47;
                    break;
            }
            _heading = darctan2(_player.x - _archer.x, _player.y - _archer.y) - 90;
            _arrow_speed = 50;
            break;
        default:
            _heading = 90 + irandom(179);
            break;
    }
    _archer.sprite_index = spr_cheetahmen_archer_fire;
    cheetah_archer_shot_steps = 20;
    _heading = (360 + sign(_heading) * floor(abs(_heading))) mod 360;
    var _arrow = instance_create_layer(_arrow_x, _arrow_y, "Gameplay", obj_hazard, {
        sprite_index: spr_cheetahmen_arrow, image_angle: _heading,
        arrow_x: _arrow_x, arrow_y: _arrow_y,
        vx: lengthdir_x(_arrow_speed, _heading), vy: lengthdir_y(_arrow_speed, _heading)
    });
    array_push(cheetah_arrows, _arrow);
}

function cheetahmen_step_arrows() {
    for (var _i = array_length(cheetah_arrows) - 1; _i >= 0; --_i) {
        var _arrow = cheetah_arrows[_i];
        if (!instance_exists(_arrow)) {
            array_delete(cheetah_arrows, _i, 1);
            continue;
        }

        // Fusion writes the current accumulators before calculating the next position.
        _arrow.x = sign(_arrow.arrow_x) * floor(abs(_arrow.arrow_x));
        _arrow.y = sign(_arrow.arrow_y) * floor(abs(_arrow.arrow_y));
        _arrow.arrow_x += _arrow.vx;
        _arrow.arrow_y += _arrow.vy;
        if ((_arrow.x < -64 && _arrow.vx <= 0) || (_arrow.x > room_width + 64 && _arrow.vx >= 0)
            || (_arrow.y < -64 && _arrow.vy <= 0) || (_arrow.y > room_height + 64 && _arrow.vy >= 0)) {
            instance_destroy(_arrow);
            array_delete(cheetah_arrows, _i, 1);
        }
    }
}

function cheetahmen_step_critical_trap(_player) {
    var _trap = inst_cheetahmen_early_5161;
    var _message = inst_cheetahmen_early_5176;
    if (_player != noone && _player.boshy_mask_meeting(_trap) && _player.die()) {
        cheetah_critical_steps = 80;
        _message.visible = true;
        cheetah_critical_sound = audio_play_sound(snd_cheetahmen_critical, 1, false);
    }
    if (cheetah_critical_steps > 0) {
        --_message.y;
        if (--cheetah_critical_steps == 0) {
            _message.visible = false;
        }
    }
}

function cheetahmen_early_cleanup() {
    if (cheetah_critical_sound != -1) {
        audio_stop_sound(cheetah_critical_sound);
    }
}
