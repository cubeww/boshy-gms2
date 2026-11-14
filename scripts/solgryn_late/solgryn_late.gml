function solgryn_late_init() {
    late_floor = noone;
    late_laser = noone;
    late_salvo_clock = 0;
    solgryn_history_alpha = 0;
    solgryn_late_shield_init();
    solgryn_late_cameos_init();
}

function solgryn_late_step(_player, _age) {
    ++late_salvo_clock;
    if (_age < 8210) {
        _age = solgryn_late_shield_step(_player, _age);
    }
    if (_age >= 8100) {
        _age = solgryn_late_cameos_step(_player, _age);
    }
    if (_age >= 15001) {
        solgryn_late_final_step(_player, _age);
    }
    solgryn_late_beam_right_edge(_player);
    return _age;
}

function solgryn_late_take_shot(_shot) {
    if (!instance_exists(late_laser) || late_laser.laser_broken) {
        return false;
    }
    var _laser = late_laser;
    var _blocked = false;
    with (_shot) {
        _blocked = place_meeting(x, y, _laser);
    }
    if (_blocked) {
        ++_laser.laser_hits;
    }
    return _blocked;
}

function solgryn_late_burst(_x, _y) {
    return instance_create_layer(_x, _y, "Attack Effects", obj_solgryn_late_burst);
}

function solgryn_late_beam_right_edge(_player) {
    // G849 places this beam at the top of the cameo and flight screen.
    if (instance_exists(_player) && _player.x >= 540 && _player.y >= 2400 && _player.y < 2880) {
        solgryn_early_beam(_player.x + irandom(31) - irandom(31), 2404 + irandom(51));
    }
}

function solgryn_late_laser_step(_player) {
    if (!instance_exists(late_laser)) {
        return;
    }
    var _has_player = instance_exists(_player);
    var _player_y = _has_player ? _player.y : late_laser.y;
    with (late_laser) {
        ++laser_steps;
        if (laser_broken) {
            var _count = array_length(laser_trail);
            if (_count == 0 || laser_steps - laser_trail[_count - 1].step >= 13) {
                instance_destroy();
            }
        } else {
            // G853 moves the hotspot one pixel left and closes 30% of the vertical distance.
            --x;
            y = floor(y + (_player_y - y) * 0.3);
            var _frame = floor(laser_steps * 0.25);
            image_index = _frame < 18 ? _frame : 11 + (_frame - 11) mod 7;
            if (laser_hits >= 60) {
                solgryn_early_teleport_burst(x, y);
                solgryn_late_burst(x, y);
                audio_play_sound(snd_solgryn_late_long_explosion, 1, false);
                laser_broken = true;
                sprite_index = -1;
            } else {
                // G856 adds edge damage after G855 checks whether the laser breaks.
                if (x < 15) {
                    laser_hits += 10;
                }
                array_push(laser_trail, { x: x, y: y, step: laser_steps, frame: image_index });
                if (array_length(laser_trail) > 13) {
                    array_delete(laser_trail, 0, 1);
                }
                if (_has_player && _player.boshy_mask_meeting(id)) {
                    _player.die();
                }
            }
        }
    }
}

function solgryn_late_clear_shots() {
    with (obj_solgryn_early_hazard) {
        if (shot_kind == SolgrynEarlyShot.Projectile) {
            solgryn_early_shot_decay();
        }
    }
}

function solgryn_late_scatter(_count) {
    repeat (_count) {
        // G863 seeds the accumulators before G1027 applies the randomized position.
        var _shot = solgryn_early_shot(13, 2418, irandom(359), 0, 0.5, 105 / 255);
        _shot.shot_origin_x += irandom(619);
        _shot.shot_origin_y += irandom(454);
        with (_shot) {
            solgryn_early_move_projectile();
        }
    }
}

function solgryn_late_final_step(_player, _age) {
    switch (_age) {
        case 15001:
            target_x = 540;
            target_y = 2680;
            hit_points *= 15;
            max_health *= 15;
            late_floor = instance_find(obj_solgryn_late_floor, 0);
            break;
        case 15040:
            audio_play_sound(snd_solgryn_late_roar, 1, false);
            break;
        case 15205:
            audio_play_sound(snd_solgryn_late_phaser, 1, false);
            if (instance_exists(late_floor)) {
                late_floor.y -= 30;
            }
            break;
        case 15260:
            target_x = 540;
            target_y = 2680;
            break;
        case 15300:
            late_laser = instance_create_layer(x, y + 16, "Attack Effects", obj_solgryn_late_laser);
            audio_play_sound(snd_solgryn_late_laser, 1, false);
            target_x += 25;
            solgryn_flash();
            solgryn_blur(2.5);
            break;
        case 15660:
            solgryn_late_scatter(110);
            break;
        case 15720:
        case 16050:
            audio_play_sound(snd_solgryn_late_roar, 1, false);
            solgryn_shake(2);
            solgryn_history_alpha = 0.35;
            break;
        case 15780:
        case 16110:
            with (obj_solgryn_early_hazard) {
                if (shot_kind == SolgrynEarlyShot.Projectile) {
                    shot_speed = 1;
                    image_alpha = 1;
                    layer = layer_get_id("Boss");
                }
            }
            break;
        case 15950:
            // The first scatter is still in flight while the second set appears.
            solgryn_late_scatter(100);
            break;
        case 16310:
            target_x = 555;
            target_y = 2650;
            solgryn_history_alpha = 0;
            solgryn_late_clear_shots();
            break;
    }

    if (_age >= 15040 && _age <= 15150) {
        solgryn_blur(2, 0);
        solgryn_shake(25);
    }
    if (_age >= 15120) {
        solgryn_late_ship_step(_player, _age);
    }
    if (_age >= 15120 && _age <= 15305) {
        var _count = 1 + (_age >= 15180) + (_age >= 15250);
        repeat (_count) {
            solgryn_early_explosion(4 + irandom(629), 2891, "Flame Floor");
        }
        if (scene_steps mod 50 == 0) {
            solgryn_late_burst(30 + irandom(609), 2858);
        }
        if (_age >= 15250) {
            solgryn_late_burst(30 + irandom(609), 2932);
        }
        if (_age >= 15290 && instance_exists(late_floor)) {
            --late_floor.y;
        }
    }
    if (_age >= 15210 && _age <= 15260) {
        solgryn_early_explosion(x, y);
        if (_age < 15260) {
            target_x = 540 + irandom(79) - irandom(79);
            target_y = 2680 + irandom(79) - irandom(79);
        }
    }
    solgryn_late_laser_step(_player);

    if ((_age > 15330 && _age < 15500 && late_salvo_clock > 60)
        || (_age > 15650 && _age < 16310)) {
        var _angle = (scene_steps * 20) div 5;
        target_x = 555 + dcos(_angle) * 30;
        target_y = 2650 + dsin(_angle) * 150;
    }
    if (_age > 15350 && _age < 15500) {
        if (late_salvo_clock < 60) {
            solgryn_early_shot(x, y, 180, 4);
        } else if (late_salvo_clock >= 100) {
            late_salvo_clock = 0;
            solgryn_early_shot(x, y, 180, 5);
        }
    }
    if (_age > 15350 && _age < 15610) {
        with (obj_solgryn_early_hazard) {
            if (shot_kind == SolgrynEarlyShot.Projectile) {
                shot_direction = floor(180 + dsin(shot_age * 5) * 60);
            }
        }
    }
    if (_age >= 16340 && _age < 16363) {
        var _slope = (_age - 16340) * 8;
        solgryn_early_shot(x, y - 250 + _slope, 180, 5);
        solgryn_early_shot(x, y + 250 - _slope, 180, 5);
    }
    if (_age >= 16368 && _age <= 16820) {
        solgryn_early_shot(x, y - 64, 180, 5);
        solgryn_early_shot(x, y + 64, 180, 5);
    }
    if (_age >= 16400 && _age <= 17820) {
        target_y = 2650 + dsin(140 + _age * 2) * (150 * dcos(_age));
    }
    if (_age >= 16870 && _age < 800000) {
        // G876–879 alternate seven-shot walls with an offset of half one spacing.
        if (late_salvo_clock == 50 || late_salvo_clock >= 100) {
            var _first_wall = late_salvo_clock == 50;
            var _spawn_x = _first_wall ? 535 : 537;
            var _spawn_y = _first_wall ? 2430 : 2466;
            for (var _lane = 0; _lane < 7; ++_lane) {
                solgryn_early_shot(_spawn_x, _spawn_y + _lane * 64, 180, 5);
            }
        }
        if (late_salvo_clock >= 100) {
            late_salvo_clock = 0;
        }
    }
}
