function solgryn_late_shield_init() {
    shield_hits = 0;
    shield_overload_age = -1;
    shield_barrier = noone;
    shield_rocket = noone;
    shield_lift_turn_us = 150000;
    shield_lift_move_us = 100000;
    shield_lift_carry_us = 100000;
}

function solgryn_late_shield_try_upper_gate(_player, _old_y) {
    if (fight_age < 5400 || fight_age >= 6020
        || !instance_exists(inst_solgryn_arena_phase_two_entrance)) {
        return false;
    }

    // G1180 fires at the first silhouette contact, also during a fast jump across the upper seam.
    var _gate = inst_solgryn_arena_phase_two_entrance;
    var _end_y = _player.y;
    var _contact = false;
    with (_player) {
        for (var _probe_y = floor(_old_y); _probe_y >= floor(_end_y); --_probe_y) {
            y = _probe_y;
            if (boshy_mask_meeting(_gate)) {
                _contact = true;
                break;
            }
        }
        y = _end_y;
    }
    if (!_contact) {
        return false;
    }
    _player.y += 3330;
    _player.refresh_collision_probes();
    fight_age = 6020;
    view_top = floor(_player.y / 480) * 480 - 2;
    return true;
}

function solgryn_late_shield_move_platforms(_player, _age) {
    // Active 46 and the steel lift use the same Superdown sprite (image 311).
    static _superdown = { left: -8, top: 4, right: 8, bottom: 9 };
    var _alive = instance_exists(_player);
    if (_age >= 5400 && _age <= 5999 && instance_exists(inst_solgryn_arena_shield_lift)) {
        var _lift = inst_solgryn_arena_shield_lift;
        if (_age >= 5500) {
            shield_lift_turn_us -= delta_time;
            if (shield_lift_turn_us <= 0) {
                shield_lift_turn_us += 150000;
                --_lift.image_angle;
                solgryn_shake(10);
            }
        }
        shield_lift_move_us -= delta_time;
        if (shield_lift_move_us <= 0) {
            shield_lift_move_us += 100000;
            ++_lift.y;
        }
        // G786 has its own timer and evaluates the rider after the lift moves.
        if (_alive && _player.probe_overlaps(_superdown, _lift)) {
            shield_lift_carry_us -= delta_time;
            if (shield_lift_carry_us <= 0) {
                shield_lift_carry_us += 100000;
                ++_player.y;
                _player.refresh_collision_probes();
            }
        }
    }

    // G1185 carries the rider once, before either of the pillar movements.
    var _riding = _alive && _player.probe_overlaps(_superdown, obj_solgryn_late_shield_pillar);
    if (_riding) {
        ++_player.y;
        _player.air_jump_available = true;
    }

    with (obj_solgryn_late_shield_pillar) {
        ++y;
        if (fall_age < 80) {
            y += 3;
            ++fall_age;
        }
        var _cutoff = other.fight_age < 6020 ? 540 : 3440;
        if (bbox_top > _cutoff) {
            instance_destroy();
        }
    }

    // Fusion refreshes Superdown after G1188, so the jump uses the pre-carry probe.
    if (_alive && keyboard_check_pressed(global.settings.keys.jump)
        && _player.probe_overlaps(_superdown, obj_solgryn_late_shield_pillar)) {
        _player.vsp = -7;
        _player.grounded = false;
        _player.jumped_this_step = true;
        _player.jump_cut_enabled = true;
    }
    if (_riding) {
        _player.refresh_collision_probes();
    }
}

function solgryn_late_shield_spawn_plasma() {
    for (var _i = 0; _i < 20; ++_i) {
        instance_create_layer(20 + irandom(299), 2920 + irandom(439), "Attack Effects",
            obj_solgryn_late_shield_plasma, { launch_age: 80 + _i * 30 });
    }
}

function solgryn_late_shield_plasma_hits() {
    var _overlap = false;
    var _fired_orb = false;
    var _fired_hit = false;
    var _barrier = shield_barrier;
    with (obj_solgryn_late_shield_plasma) {
        var _touching = place_meeting(x, y, _barrier);
        _overlap = _overlap || _touching;
        _fired_orb = _fired_orb || launched;
        _fired_hit = _fired_hit || (launched && _touching);
    }
    // G811–812 apply their actions once to the selected shield.
    if (_fired_hit) {
        ++shield_hits;
        _barrier.image_alpha = 105 / 255;
        audio_play_sound(snd_solgryn_late_shield_hit, 1, false);
    } else if (_fired_orb && !_overlap) {
        _barrier.image_alpha = 1;
    }
}

function solgryn_late_shield_step(_player, _age) {
    var _alive = instance_exists(_player);
    if (_age >= 5150 && _age <= 5400) {
        var _count = 1 + (_age >= 5200) + (_age >= 5250);
        repeat (_count) {
            solgryn_early_explosion(x + irandom(99) - irandom(99), y + irandom(199) - irandom(199));
        }
        if (late_salvo_clock >= 10) {
            late_salvo_clock = 0;
            image_angle = irandom(34) - irandom(34);
            audio_play_sound(snd_green_greens_kracko_explosion, 1, false);
            solgryn_flash();
        }
    }
    if (_age >= 5575 && _age <= 5700) {
        // G787 creates the explosion at a room position by the lower platform.
        solgryn_early_explosion(321 + irandom(99) - irandom(99), 482);
    }

    switch (_age) {
        case 5400:
            image_angle = 0;
            solgryn_music_seek(141.5, true);
            solgryn_shake(40);
            solgryn_blur(blur_strength + 1);
            audio_play_sound(snd_solgryn_late_roar, 1, false);
            instance_create_layer(325, -19, "Platforms", obj_solgryn_late_shield_pillar);
            break;
        case 5430:
            instance_create_layer(266, -125, "Platforms", obj_solgryn_late_shield_pillar);
            instance_create_layer(353, -468, "Platforms", obj_solgryn_late_shield_pillar);
            break;
        case 5460:
            instance_create_layer(321, -222, "Platforms", obj_solgryn_late_shield_pillar);
            break;
        case 5520:
            instance_create_layer(261, -280, "Platforms", obj_solgryn_late_shield_pillar);
            instance_create_layer(249, -500, "Platforms", obj_solgryn_late_shield_pillar);
            break;
        case 6000:
            solgryn_late_shield_move_platforms(_player, 5999);
            return 5999;
        case 6021:
            x = 320;
            y = 2992;
            target_x = x;
            target_y = y;
            break;
        case 6030:
            audio_play_sound(snd_solgryn_late_roar, 1, false);
            with (obj_solgryn_late_shield_pillar) {
                instance_destroy();
            }
            break;
        case 6200:
            late_salvo_clock = 0;
            break;
        case 6201:
            shield_rocket = instance_create_layer(x + 50, y, "Attack Effects", obj_solgryn_late_shield_rocket);
            shield_rocket.image_xscale = 0.1;
            audio_play_sound(snd_solgryn_late_phaser, 1, false);
            break;
        case 6270:
            with (shield_rocket) {
                instance_destroy();
            }
            shield_rocket = instance_create_layer(x - 50, y, "Attack Effects", obj_solgryn_late_shield_rocket);
            shield_rocket.fired = true;
            audio_play_sound(snd_solgryn_late_shield_rocket_launch, 1, false);
            break;
        case 6335:
            shield_barrier = instance_create_layer(x, y, "Attack Effects", obj_solgryn_late_shield_barrier);
            shield_active = true;
            break;
        case 6340:
            target_x = 540;
            solgryn_late_shield_spawn_plasma();
            break;
        case 7670:
            _age = 6339;
            break;
        case 8001:
            x = 310;
            y = 2680;
            target_x = x;
            target_y = y;
            break;
    }

    solgryn_late_shield_move_platforms(_player, _age);

    if (_age >= 5420 && _age <= 5450) {
        target_y -= 17;
        solgryn_shake(25);
    }
    if (_age >= 5400 && _age <= 6000 && _alive
        && solgryn_late_shield_try_upper_gate(_player, _player.y)) {
        return 6020;
    }

    if (_age >= 6045 && _age <= 6180) {
        hit_points = min(60, hit_points + 1);
        solgryn_shake(40);
        solgryn_blur(blur_strength + 0.3);
    }
    // G796–799 ease twice at charge ages 1 and 30, then pause tracking before firing.
    if (_alive && ((_age >= 6201 && _age <= 6260) || _age == 6270)) {
        target_x = 490;
        var _tracking = (_age == 6201 || _age == 6230) ? 0.36 : 0.2;
        target_y += (_player.y - target_y) * _tracking;
    }
    if (instance_exists(shield_rocket)) {
        var _beam = shield_rocket;
        if (_beam.fired) {
            ++_beam.beam_age;
            if (_beam.beam_age > 50) {
                _beam.image_alpha = max(0, _beam.image_alpha - 15 / 255);
            }
            if (_alive && _player.boshy_mask_meeting(_beam) && _player.die()) {
                _alive = false;
            }
            if (_beam.beam_age > 70) {
                with (_beam) {
                    instance_destroy();
                }
            }
        } else {
            if (_age <= 6260) {
                _beam.y = y;
            }
            if (_age >= 6230 && _age <= 6260) {
                solgryn_early_explosion(x - 35, y);
            }
        }
    }

    if (instance_exists(shield_barrier) && shield_overload_age < 0) {
        solgryn_late_shield_plasma_hits();
        if (shield_hits >= (difficulty == 0 ? 175 : 350)) {
            shield_overload_age = 0;
            if (difficulty != 0) {
                audio_play_sound(snd_solgryn_late_roar, 1, false);
            }
        }
    }

    if (_age >= 6340 && _age <= 7100 && instance_exists(shield_barrier) && shield_overload_age <= 1) {
        target_y = 3080 + dsin(_age * 2) * 150;
    }
    if (_age >= 7100 && _age <= 7600) {
        if (late_salvo_clock >= 15) {
            late_salvo_clock = 0;
            audio_play_sound(snd_solgryn_early_shoot, 1, false);
        }
        if (instance_exists(shield_barrier) && shield_hits < 350) {
            var _turn = dsin((_age + 70) * 2) * 37;
            solgryn_early_shot(x, y - 64, 170 + _turn, 3);
            solgryn_early_shot(x, y + 64, 195 + _turn, 3);
        }
    }

    if (instance_exists(shield_barrier)) {
        shield_barrier.x = x;
        shield_barrier.y = y;
        var _room_time_ms = game_controller.frame_elapsed_us div 1000;
        var _scale = 2 + dsin(_room_time_ms) * 0.15 - shield_hits * 0.004;
        shield_barrier.image_xscale = _scale;
        shield_barrier.image_yscale = _scale;
    }

    if (shield_overload_age >= 0 && shield_overload_age < 150) {
        ++shield_overload_age;
        with (obj_solgryn_late_shield_plasma) {
            instance_destroy();
        }
        repeat (2) {
            solgryn_early_explosion(x + irandom(99) - irandom(99), y + irandom(199) - irandom(199));
        }
        if (shield_hits >= 350 && late_salvo_clock >= 8) {
            late_salvo_clock = 0;
            audio_play_sound(snd_green_greens_kracko_explosion, 1, false);
        }
        if (shield_overload_age >= 100) {
            target_y -= 15;
            with (obj_solgryn_late_shield_marker) {
                if (!is_ship_marker) {
                    visible = true;
                }
            }
        }
        if (shield_overload_age == 100) {
            instance_create_layer(281, 2620, "Platforms", obj_solgryn_late_shield_pillar);
            instance_create_layer(353, 2500, "Platforms", obj_solgryn_late_shield_pillar);
        }
        if (shield_overload_age == 150) {
            shield_active = false;
            with (shield_barrier) {
                instance_destroy();
            }
        }
    }

    if (_age >= 8001 && _age <= 8050) {
        solgryn_early_shot(x, y, 290, 15);
        solgryn_early_shot(x, y, 250, 15);
    }
    if (_age >= 8050 && _age <= 8150) {
        var _bend = dsin(100 + _age * 3) * 30;
        solgryn_early_shot(x, y, 300 + _bend, 6);
        solgryn_early_shot(x, y, 240 + _bend, 6);
    }
    if (_age >= 8150 && _age <= 8180) {
        target_y -= 15;
        with (obj_solgryn_early_hazard) {
            if (shot_kind == SolgrynEarlyShot.Projectile) {
                shot_speed += 0.1;
            }
        }
    }

    if (_age < 8000 && instance_exists(_player)
        && instance_exists(inst_solgryn_arena_boss_rush_entrance)
        && _player.boshy_mask_meeting(inst_solgryn_arena_boss_rush_entrance)) {
        // G1205 shifts the player just above the seam before starting the cameo timeline.
        _player.y -= 32;
        _player.refresh_collision_probes();
        target_x = 320;
        return 8000;
    }
    return _age;
}

function solgryn_late_ship_step(_player, _age) {
    var _ship = instance_find(obj_solgryn_late_shield_ship, 0);
    if (!instance_exists(_ship)) {
        return;
    }
    if (_age >= 15120 && _age <= 15165) {
        _ship.x += 4;
        with (obj_solgryn_late_shield_marker) {
            if (is_ship_marker) {
                visible = true;
            }
        }
    }
    if (!instance_exists(_player)) {
        return;
    }
    var _keys = global.settings.keys;
    var _fire_tick = false;
    if (keyboard_check(_keys.shoot) && instance_number(obj_bullet) < 18) {
        // G1361 checks held fire and the bullet cap before advancing its timer.
        _ship.fire_timer_us -= delta_time;
        if (_ship.fire_timer_us <= 0) {
            _ship.fire_timer_us += 50000;
            _fire_tick = true;
        }
    }
    if (!_ship.boarded && _player.boshy_mask_meeting(_ship)) {
        _ship.boarded = true;
        with (obj_solgryn_late_shield_marker) {
            if (is_ship_marker) {
                visible = false;
            }
        }
    }
    if (!_ship.boarded) {
        return;
    }

    // G1352–1358 apply discrete lateral thrust, rounded vertical travel, and damping.
    var _up = keyboard_check(_keys.up);
    var _down = keyboard_check(_keys.down);
    var _held_x = keyboard_check(game_horizontal_key(_keys, true))
        - keyboard_check(game_horizontal_key(_keys, false));
    _ship.image_index = _down ? 2 : (_up ? 1 : 0);
    _ship.x += _held_x * (3 + _ship.flight_speed);
    _ship.vertical_speed += (_down - _up) * _ship.flight_speed;
    _ship.y += floor(_ship.vertical_speed + 0.5);
    _ship.vertical_speed *= 0.6;

    _player.input_locked = true;
    _player.facing = 1;
    _player.hsp = 0;
    _player.vsp = 0;
    _player.x = _ship.x;
    _player.y = _ship.y;
    _player.refresh_collision_probes();

    var _character = _player.character;
    if (_fire_tick) {
        var _shoot_clip = _character.poses[PlayerPose.Shoot];
        _ship.shoot_steps = ceil(array_length(_shoot_clip.frames) / _shoot_clip.rate);
        var _shot = global.settings.special_shot_graphics ? _character.projectile_sprite : spr_boshy_bullet;
        var _bullet = instance_create_depth(_player.x + _character.muzzle_x, _player.y + _character.muzzle_y,
            _player.depth, obj_bullet, {
                travel_direction: 1,
                sprite_index: _shot,
                custom_bullet: custom_character_bullet_clip(_character)
            });
        _bullet.travel_speed = 12.5;
        var _sound = global.settings.special_shoot_sounds ? _character.shoot_sound : snd_shoot;
        if (_sound != noone) {
            audio_play_sound(_sound, 1, false);
        }
    }

    var _pose = _ship.shoot_steps > 0 ? PlayerPose.Shoot : PlayerPose.Idle;
    var _clip = _character.poses[_pose];
    if (_pose != _player.pose) {
        _player.pose = _pose;
        _player.pose_steps = 0;
    } else {
        ++_player.pose_steps;
    }
    var _count = array_length(_clip.frames);
    var _frame = _player.pose_steps * _clip.rate;
    _player.pose_frame = _clip.loop ? _frame mod _count : min(_frame, _count - 1);
    _ship.shoot_steps = max(0, _ship.shoot_steps - 1);

    var _outside = _ship.x + 15 <= 0 || _ship.x - 15 >= room_width
        || _ship.y + 5 <= 0 || _ship.y - 25 >= room_height;
    if (_outside || _player.touching_hazard()) {
        _player.die(_outside);
    }
}
