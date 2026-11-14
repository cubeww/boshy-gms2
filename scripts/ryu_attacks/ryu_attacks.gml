enum RyuAttackKind {
    OpeningHadoken,
    AimedHadoken,
    FallingHadoken,
    SuperHadoken,
    Car,
    CarDebris
}

function ryu_attacks_setup() {
    ryu_attack_entities = [];
    ryu_cameo_instances = [];
    ryu_attack_clock = 0;
    ryu_attack_hsp = 0;
    ryu_attack_vsp = 0;
    ryu_super_amplitude = 0;
}

function ryu_attack_create(_kind, _sprite, _x, _y, _hsp, _vsp, _angle = 0, _scale = 1) {
    var _actor = instance_create_depth(_x, _y, depth - 1, obj_hazard, {
        sprite_index: _sprite,
        image_speed: _kind == RyuAttackKind.CarDebris ? 1 : 0,
        image_xscale: _scale,
        image_yscale: _scale,
        image_angle: _angle,
        visible: _kind != RyuAttackKind.SuperHadoken
    });
    array_push(ryu_attack_entities, {
        actor: _actor, kind: _kind, hsp: _hsp, vsp: _vsp, age: 0
    });
}

function ryu_attack_overhead(_shift, _shake = true) {
    // Groups 730–731 create 31 shots 60 pixels apart. Only the arena columns are reachable.
    for (var _x = 1274 - _shift; _x <= 1984; _x += 60) {
        ryu_attack_create(RyuAttackKind.FallingHadoken, spr_ryu_projectile_589, _x, -20, 0, 4, 90);
    }
    if (_shake) {
        shake_strength = 20;
    }
    audio_play_sound(snd_stock_yoshi_alt_shoot, 1, false);
}

function ryu_attack_super_wave(_age) {
    // Groups 747–749 fire after animation 20 reaches its held action point.
    var _hand_x = x - 48;
    var _hand_y = y - 4;
    var _wave_x = _hand_x + dsin(_age) * 8;
    var _offset = ryu_super_amplitude * 2 + 40 - dsin(_age * 15) * ryu_super_amplitude;
    ryu_attack_create(RyuAttackKind.SuperHadoken, spr_ryu_hadoken, _wave_x, y, -10, _hand_y - _offset, 180);
    ryu_attack_create(RyuAttackKind.SuperHadoken, spr_ryu_hadoken, _wave_x, y, -10, _hand_y + _offset, 180);
    shake_strength = 10;
}

function ryu_attack_car_debris(_impact_x, _impact_y) {
    // Groups 1007–1008 spawn six pieces with a random clip between 12 and 16.
    static _pieces = [spr_ryu_wheel_12, spr_ryu_wheel_13, spr_ryu_wheel_14, spr_ryu_wheel_15, spr_ryu_wheel_16];
    for (var _i = 0; _i < 6; ++_i) {
        ryu_attack_create(RyuAttackKind.CarDebris, _pieces[irandom(array_length(_pieces) - 1)], _impact_x, _impact_y,
            irandom(3) - irandom(3), -10 - irandom(3));
    }
    audio_play_sound(snd_ryu_car_crash, 1, false);
    shake_strength = 5;
}

function ryu_attack_entities_step() {
    ++ryu_attack_clock;
    for (var _i = array_length(ryu_attack_entities) - 1; _i >= 0; --_i) {
        var _attack = ryu_attack_entities[_i];
        var _actor = _attack.actor;
        if (!instance_exists(_actor)) {
            array_delete(ryu_attack_entities, _i, 1);
            continue;
        }

        ++_attack.age;
        _actor.x += _attack.hsp;
        var _previous_y = _actor.y;
        switch (_attack.kind) {
            case RyuAttackKind.SuperHadoken:
                // Group 793 adds a signed nudge based on the target height after easing.
                _actor.y = floor(lerp(_actor.y, _attack.vsp, 0.2) + clamp(_attack.vsp, -1, 1));
                break;
            case RyuAttackKind.Car:
                _actor.y += _attack.vsp;
                _actor.image_angle -= 2;
                _attack.vsp += 0.3;
                var _car_contact = false;
                with (_actor) {
                    _car_contact = place_meeting(x, y, [obj_player_backdrop, obj_ryu_arena_solid]);
                }
                if (_attack.vsp > 0 && _car_contact) {
                    ryu_attack_car_debris(_actor.x, _actor.y);
                    _actor.y = _previous_y;
                    _actor.image_index = min(_actor.image_number - 1, _actor.image_index + 1);
                    _attack.vsp *= -0.9;
                }
                break;
            case RyuAttackKind.CarDebris:
                _actor.y += _attack.vsp;
                _actor.image_angle = point_direction(0, 0, _attack.hsp, _attack.vsp);
                _attack.vsp += 0.3;
                break;
            default:
                _actor.y += _attack.vsp;
                break;
        }

        var _terrain_hit = false;
        if (_attack.kind == RyuAttackKind.AimedHadoken) {
            with (_actor) {
                _terrain_hit = place_meeting(x, y, [obj_player_backdrop, obj_ryu_arena_solid]);
            }
        }
        var _hadoken = _attack.kind != RyuAttackKind.Car && _attack.kind != RyuAttackKind.CarDebris;
        var _expired = _actor.bbox_right < 1024 || _actor.bbox_left > 2176 || _attack.age >= 400;
        if (_hadoken) {
            // The creation step displays frame zero before Fusion advances the 15 fps clip.
            _actor.image_index = max(0, ((_attack.age - 1) * 30 - 1) div 100) mod _actor.image_number;
            _expired = _expired || _actor.y < -150 || _actor.y > 600 || _terrain_hit;
            if (_attack.kind == RyuAttackKind.AimedHadoken || _attack.kind == RyuAttackKind.SuperHadoken) {
                // Group 779 compares the transformed sprite to the arena edges plus 64 pixels.
                _expired = _expired || _actor.bbox_left <= 1216 || _actor.bbox_right >= 1984
                    || _actor.bbox_top <= -64 || _actor.bbox_bottom >= 544;
            }
        } else {
            _expired = _expired || _actor.y > 640;
        }
        if (_expired) {
            if (_hadoken) {
                instance_create_depth(_actor.x, _actor.y, _actor.depth, obj_ryu_combat_disappearance, {
                    image_speed: 1,
                    image_xscale: _actor.image_xscale,
                    image_yscale: _actor.image_yscale,
                    image_angle: _actor.image_angle,
                    additive: _attack.kind == RyuAttackKind.SuperHadoken
                });
            }
            instance_destroy(_actor);
            array_delete(ryu_attack_entities, _i, 1);
        }
    }
}

function ryu_attacks_step(_player, _age) {
    // Groups 699 and 709–766 use one repeating timeline at 50 steps per second.
    switch (_age) {
        case 1080:
            ryu_set_pose(12, -1);
            ryu_attack_create(RyuAttackKind.OpeningHadoken, spr_ryu_projectile_589, x - 29, y + 1, -5, 0, 0, 10);
            shake_strength = 30;
            blur_strength = 15;
            audio_play_sound(snd_stock_yoshi_alt_shoot, 1, false);
            break;
        case 1200:
            ryu_attack_hsp = -4;
            ryu_attack_vsp = -10;
            ryu_set_pose(7, -1);
            audio_play_sound(snd_ryu_jump, 1, false);
            break;
        case 1340:
            ryu_set_pose(0, 1);
            image_angle = 0;
            ryu_attack_overhead(0);
            break;
        case 1400:
            ryu_attack_hsp = 10;
            ryu_set_pose(13, 1);
            audio_play_sound(snd_ryu_tatsumaki, 1, false);
            break;
        case 1450:
            ryu_set_pose(13, 1, true);
            audio_play_sound(snd_ryu_super_tatsumaki, 1, false);
            break;
        case 1550:
        case 1730:
        case 1790:
            ryu_attack_overhead(0);
            break;
        case 1700:
            ryu_set_pose(13, 1);
            audio_play_sound(snd_ryu_tatsumaki, 1, false);
            break;
        case 1760:
        case 1820:
            ryu_attack_overhead(32);
            break;
        case 1900:
        case 2000:
        case 2100:
            audio_play_sound(snd_stock_yoshi_alt_jump, 1, false);
            break;
        case 1925:
        case 2025:
        case 2125:
            if (instance_exists(_player)) {
                x = _player.x;
            }
            if (_age == 2125) {
                ryu_attack_overhead(0, false);
            }
            break;
        case 2300:
            ryu_set_pose(20, 1);
            audio_play_sound(snd_ryu_super_charge, 1, false);
            break;
        case 2375:
            // Group 746 turns Ryu left at release without restarting the charge animation.
            ryu_set_pose(20, -1);
            audio_play_sound(snd_ryu_super_hadoken, 1, false);
            audio_play_sound(snd_ryu_super_flash, 1, false);
            arena_flash = 1;
            blur_strength = 15;
            break;
        case 2650:
        case 2730:
            ryu_set_pose(21, -1);
            shake_strength = 15;
            audio_play_sound(_age == 2650 ? snd_ryu_exit : snd_ryu_transform, 1, false);
            break;
        case 2660:
        case 2740:
            ryu_attack_create(RyuAttackKind.Car, spr_ryu_car, x, y - 90, _age == 2660 ? -4 : -2, -12);
            break;
        case 2780:
            ryu_attack_vsp = 0;
            ryu_set_pose(13, -1);
            audio_play_sound(snd_ryu_tatsumaki, 1, false);
            break;
    }

    if (_age >= 1200 && _age < 1340) {
        x = floor(x + ryu_attack_hsp);
        y = floor(y + ryu_attack_vsp);
        ryu_attack_vsp += 0.15;
        if (instance_exists(_player)) {
            var _heading = point_direction(x, y, _player.x, _player.y);
            // Group 710 uses Atan2(ryu.x - player.x, ryu.y - player.y) - 90.
            image_angle = _heading + 180;
            var _air_age = _age - 1200;
            // At 50 Hz, 150 ms alternates between seven and eight steps.
            if ((_air_age * 2) mod 15 < 2) {
                var _shot_heading = _heading + irandom(29) - irandom(29);
                ryu_attack_create(RyuAttackKind.AimedHadoken, spr_ryu_hadoken, x, y,
                    lengthdir_x(2, _shot_heading), lengthdir_y(2, _shot_heading), _shot_heading);
                shake_strength = 10;
            }
            if (_air_age mod 35 == 0) {
                audio_play_sound(snd_stock_yoshi_alt_shoot, 1, false);
            }
        }
    }

    if (_age >= 1400 && _age < 1690) {
        x = floor(x + ryu_attack_hsp);
    }
    if (_age >= 1400 && ((x >= 1920 && ryu_attack_hsp > 0) || (x < 1275 && ryu_attack_hsp < 0))) {
        ryu_attack_hsp *= -0.9;
        // Group 716 requests another Tatsumaki when the active pass reaches an edge.
        ryu_set_pose(13, ryu_pose_facing);
    }
    if ((_age >= 1450 && _age < 1600) || (_age >= 1700 && _age < 1800)) {
        y = floor(y + ryu_attack_vsp);
        ryu_attack_vsp += (_age <= 1500 || _age >= 1700) ? -0.8 : 0.2;
    }
    if (_age >= 1950 && _age < 2244) {
        y = floor(y + ryu_attack_vsp);
        ryu_attack_vsp += 0.5;
    }
    if (_age >= 2780 && _age < 3150) {
        y = floor(y + ryu_attack_vsp);
        ryu_attack_vsp += _age < 2850 ? -0.5 : 0.5;
    }

    switch (_age) {
        case 1600:
            x = 2024;
            y = 382;
            ryu_attack_hsp = -10;
            ryu_attack_vsp = 0;
            ryu_set_pose(13, 1);
            audio_play_sound(snd_ryu_tatsumaki, 1, false);
            break;
        case 1950:
        case 2050:
        case 2150:
            y = 560;
            ryu_attack_vsp = -15;
            ryu_set_pose(15, 1);
            shake_strength = 10;
            audio_play_sound(snd_ryu_jump, 1, false);
            break;
        case 2200:
            x = 1862;
            y = -51;
            ryu_attack_vsp = 0;
            break;
        case 2900:
            x = 1856;
            y = 607;
            ryu_attack_vsp = 0;
            break;
        case 3050:
            x = 1837;
            y = -79;
            ryu_attack_vsp = 20;
            break;
        case 3150:
            x = 1849;
            y = 390;
            ryu_set_pose(13, -1);
            audio_play_sound(snd_ryu_tatsumaki, 1, false);
            break;
        case 4500:
            x = 1849;
            y = 390;
            image_angle = 0;
            _age = 1079;
            break;
    }

    if (_age >= 2376 && _age < 2600) {
        ryu_attack_super_wave(_age);
    }
    if (_age >= 2375 && _age < 2600) {
        ryu_super_amplitude = 20 - dsin(_age * 12) * 20;
    }
    if (_age >= 2376 && _age <= 3150 && instance_exists(_player)
        && point_in_rectangle(_player.x, _player.y, 1848, -1, 1931, 452)) {
        _player.die();
    }

    if (_age >= 3050 && _age <= 3500) {
        ryu_attack_vsp -= 0.8;
        // Group 759 reasserts Tatsumaki each step, holding its last frame after the descent.
        ryu_set_pose(13, -1);
    }
    if (_age >= 3150 && _age <= 3200) {
        x = 1849;
        y -= 15;
    }
    if ((x < 1300 && ryu_attack_hsp < 0) || (x >= 1910 && ryu_attack_hsp > 0)) {
        ryu_attack_hsp = -ryu_attack_hsp;
    }

    ryu_cameos_spawn(_age);
    return _age;
}

function ryu_attacks_draw() {
    gpu_set_blendmode(bm_add);
    for (var _i = 0; _i < array_length(ryu_attack_entities); ++_i) {
        var _attack = ryu_attack_entities[_i];
        if (_attack.kind == RyuAttackKind.SuperHadoken && instance_exists(_attack.actor)) {
            var _actor = _attack.actor;
            draw_sprite_ext(_actor.sprite_index, _actor.image_index, _actor.x, _actor.y,
                1, 1, _actor.image_angle, c_white, 1);
        }
    }
    gpu_set_blendmode(bm_normal);
}
