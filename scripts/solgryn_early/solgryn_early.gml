enum SolgrynEarlyShot {
    Projectile,
    ProjectileDecay,
    IceBurst,
    Beam,
    Head,
    Puff,
    Oat,
    Pursuer,
    Particle,
    Explosion
}

function solgryn_early_ordnance_init() {
    shot_kind = undefined;
    shot_age = 0;
    shot_direction = 0;
    shot_speed = 0;
    shot_drift = 0;
    shot_accel = 0;
    shot_hsp = 0;
    shot_phase = 0;
    shot_facing = 1;
    shot_additive = false;
    shot_duration = 0;
    shot_origin_x = x;
    shot_origin_y = y;
}

function solgryn_early_ordnance(_x, _y, _sprite, _kind, _layer, _hazard, _additive = false) {
    var _type = _hazard ? obj_solgryn_early_hazard : obj_solgryn_early_effect;
    var _ordnance = instance_create_layer(_x, _y, _layer, _type);
    _ordnance.sprite_index = _sprite;
    _ordnance.shot_kind = _kind;
    _ordnance.shot_additive = _additive;
    return _ordnance;
}

function solgryn_early_shot(_x, _y, _angle, _speed, _scale = 1, _alpha = 1) {
    var _shot = solgryn_early_ordnance(_x, _y, spr_solgryn_early_shot,
        SolgrynEarlyShot.Projectile, "Attack Effects", true);
    _shot.shot_direction = _angle;
    _shot.shot_speed = _speed;
    _shot.image_angle = _angle;
    _shot.image_xscale = _scale;
    _shot.image_yscale = _scale;
    _shot.image_alpha = _alpha;
    return _shot;
}

function solgryn_early_shot_decay() {
    var _effect = solgryn_early_ordnance(x, y, spr_solgryn_early_shot_decay,
        SolgrynEarlyShot.ProjectileDecay, layer, false);
    _effect.image_angle = image_angle;
    _effect.image_xscale = image_xscale;
    _effect.image_yscale = image_yscale;
    _effect.image_alpha = image_alpha;
    _effect.image_blend = image_blend;
    _effect.image_speed = 0;
    _effect.shot_origin_x = shot_origin_x;
    _effect.shot_origin_y = shot_origin_y;
    _effect.shot_direction = shot_direction;
    _effect.shot_speed = shot_speed;
    _effect.shot_drift = shot_drift;
    _effect.shot_accel = shot_accel;
    // G1027 still writes the scripted position after a Destroy action starts slot 4.
    with (_effect) {
        solgryn_early_move_projectile();
    }
    instance_destroy();
}

function solgryn_early_move_projectile() {
    x = floor(shot_origin_x);
    y = floor(shot_origin_y);
    shot_origin_x += dcos(shot_direction) * shot_speed;
    shot_origin_y += -dsin(shot_direction) * shot_speed + shot_drift;
    shot_drift += shot_accel;
}

function solgryn_early_beam(_x, _y, _layer = "Boss") {
    return solgryn_early_ordnance(_x, _y, spr_solgryn_early_beam, SolgrynEarlyShot.Beam, _layer, true);
}

function solgryn_early_explosion(_x, _y, _layer = "Attack Effects", _hazard = true) {
    var _burst = solgryn_early_ordnance(_x, _y, spr_solgryn_early_explosion,
        SolgrynEarlyShot.Explosion, _layer, _hazard, true);
    _burst.image_speed = 0;
    _burst.shot_phase = irandom(359);
    return _burst;
}

function solgryn_early_finite_effect(_x, _y, _sprite, _angle = 0) {
    var _effect = solgryn_early_ordnance(_x, _y, _sprite, undefined, "Attack Effects", false, true);
    _effect.image_angle = _angle;
    _effect.shot_duration = ceil(sprite_get_number(_sprite) * game_get_speed(gamespeed_fps)
        / sprite_get_speed(_sprite));
}

function solgryn_early_splash(_x, _y) {
    solgryn_early_finite_effect(_x, _y, spr_solgryn_early_splash);
}

function solgryn_early_near_edge(_margin) {
    if (sprite_index == -1) {
        return false;
    }
    var _bounds = solgryn_early_view_bounds(sprite_index, floor(image_index));
    var _cos = dcos(image_angle);
    var _sin = dsin(image_angle);
    var _lx = _bounds[0] * image_xscale;
    var _rx = _bounds[2] * image_xscale;
    var _ty = _bounds[1] * image_yscale;
    var _by = _bounds[3] * image_yscale;
    var _left = x + min(_lx * _cos, _rx * _cos) + min(_ty * _sin, _by * _sin);
    var _right = x + max(_lx * _cos, _rx * _cos) + max(_ty * _sin, _by * _sin);
    var _top = y + min(-_lx * _sin, -_rx * _sin) + min(_ty * _cos, _by * _cos);
    var _bottom = y + max(-_lx * _sin, -_rx * _sin) + max(_ty * _cos, _by * _cos);
    var _camera = view_camera[0];
    var _cx = camera_get_view_x(_camera);
    var _cy = camera_get_view_y(_camera);
    return _left <= _cx + _margin || _right >= _cx + camera_get_view_width(_camera) - _margin
        || _top <= _cy + _margin || _bottom >= _cy + camera_get_view_height(_camera) - _margin;
}

function solgryn_early_ordnance_step() {
    shot_age += 1;
    if (shot_duration > 0 && shot_age >= shot_duration) {
        instance_destroy();
        return;
    }

    switch (shot_kind) {
        case SolgrynEarlyShot.Projectile:
            // G734 switches the shot to Disappearing at the near-view margins. G1025–27 keep
            // fractional coordinates separately from the displayed hotspot.
            if (solgryn_early_near_edge(16)) {
                solgryn_early_shot_decay();
                break;
            }
            image_angle = shot_direction;
            solgryn_early_move_projectile();
            break;

        case SolgrynEarlyShot.ProjectileDecay:
            // The original four-frame clip keeps drifting with its last trajectory.
            image_index = (shot_age * 35 - 1) div 100;
            if (image_index >= image_number) {
                instance_destroy();
            } else {
                solgryn_early_move_projectile();
            }
            break;

        case SolgrynEarlyShot.IceBurst:
            // G704–705, G710–711. A right-side launch sheds two pieces per step.
            var _boss = instance_find(obj_solgryn, 0);
            var _splash = _boss != noone && _boss.fight_age < 15000;
            if (_splash) {
                solgryn_early_splash(x + irandom(29) - irandom(29), y + irandom(31) - irandom(31));
                x += shot_facing * 2;
                if (shot_facing < 0) {
                    solgryn_early_splash(x + irandom(29) - irandom(29), y + irandom(31) - irandom(31));
                }
            }
            if (_splash || shot_facing > 0) {
                y = floor(y + shot_drift);
                shot_drift += shot_facing < 0 ? 0.1 : 0.2;
                image_angle -= shot_facing;
            }
            if (solgryn_early_near_edge(0)) {
                instance_destroy();
            }
            break;

        case SolgrynEarlyShot.Beam:
            // G718–720. Extend down from the top origin before narrowing.
            if (shot_age <= 19) {
                image_yscale += 0.06;
            }
            if (shot_age >= 40) {
                image_xscale *= 0.9;
            }
            if (shot_age >= 80) {
                instance_destroy();
            } else if (instance_exists(obj_solgryn) && obj_solgryn.fight_age < 15000) {
                solgryn_early_splash(x + irandom(29) - irandom(29), y + irandom(399));
            }
            break;

        case SolgrynEarlyShot.Head:
            // G722 sweeps the dragon head in an arc up through the platform.
            if (instance_exists(obj_solgryn) && obj_solgryn.hit_points <= 0) {
                instance_destroy();
                break;
            }
            image_angle = shot_phase + 260;
            x = floor(330 + dcos(shot_phase) * 200);
            y = floor(650 - dsin(shot_phase) * 270);
            shot_phase += 3;
            break;

        case SolgrynEarlyShot.Puff:
            // Fusion plays both appearance and disappearance for Active 32.
            if (shot_age == 6) {
                sprite_index = spr_solgryn_early_puff_decay;
                image_index = 0;
                shot_duration = 6 + ceil(image_number / 0.35);
            }
            break;

        case SolgrynEarlyShot.Oat:
            x += shot_hsp;
            y = floor(y + shot_drift);
            shot_drift += 0.7;
            image_angle += shot_hsp * 10;
            if (shot_phase == 0 && place_meeting(x, y, obj_solgryn_late_shield_lift)) {
                shot_drift = -10 - irandom(9);
                shot_phase = 1;
                audio_play_sound(snd_solgryn_early_kill, 1, false);
                with (obj_solgryn) {
                    solgryn_kick(15);
                }
            }
            if (bbox_top > 480) {
                instance_destroy();
            }
            break;

        case SolgrynEarlyShot.Pursuer:
            solgryn_early_pursuer_step();
            break;

        case SolgrynEarlyShot.Particle:
            x = floor(shot_origin_x);
            y = floor(shot_origin_y);
            shot_origin_x += shot_hsp;
            shot_origin_y += shot_drift;
            shot_hsp *= 0.9;
            shot_drift *= 0.9;
            if (round(abs(shot_hsp)) + round(abs(shot_drift)) <= 0 && ++shot_phase >= 10) {
                instance_destroy();
            }
            break;

        case SolgrynEarlyShot.Explosion:
            // G1148–1150. The explosion drifts sideways before fading in scale.
            // Its looping animation restarts on frame 2 after the initial flash.
            var _frame = (shot_age - 1) div 2;
            image_index = _frame < image_number ? _frame : 2 + (_frame - 2) mod (image_number - 2);
            x = floor(shot_origin_x);
            y = floor(shot_origin_y);
            shot_origin_x += dcos(shot_phase * 5) + shot_hsp;
            shot_phase += 1;
            shot_drift -= 0.1 - irandom(9) * 0.01;
            shot_origin_y += shot_drift;
            if (shot_drift < 0) {
                image_xscale -= irandom(49) * 0.0005;
                image_yscale = image_xscale;
                if (image_xscale <= 0) {
                    instance_destroy();
                }
            }
            break;
    }
}

function solgryn_early_ordnance_draw() {
    if (shot_additive) {
        gpu_set_blendmode(bm_add);
    }
    draw_self();
    if (shot_additive) {
        gpu_set_blendmode(bm_normal);
    }
}

function solgryn_early_pursuer_step() {
    // G1118–30. Sonic steers for 250 steps and starts rising after step 200.
    var _player = instance_find(obj_player, 0);
    if (shot_age <= 250 && _player != noone) {
        shot_hsp += sign(_player.x - x);
        shot_drift += sign(_player.y - y);
    }
    x += shot_hsp div 2;
    y += shot_drift div 2;
    if (shot_age < 250) {
        shot_hsp = clamp(shot_hsp, -25, 25);
        shot_drift = clamp(shot_drift, -25, 25);
    }
    if (x != shot_origin_x || y != shot_origin_y) {
        image_angle = point_direction(shot_origin_x, shot_origin_y, x, y);
        shot_origin_x = x;
        shot_origin_y = y;
    }
    if (shot_age >= 200) {
        shot_drift -= 1;
    }
    if (y >= 470 && shot_drift > 0) {
        shot_drift = 0;
    }
    if (shot_age mod 2 == 0) {
        var _particle = solgryn_early_ordnance(x, y, spr_solgryn_early_particle,
            SolgrynEarlyShot.Particle, "Attack Effects", false);
        var _angle = irandom(359);
        _particle.image_index = irandom(3);
        _particle.image_speed = 0;
        _particle.shot_hsp = (4 + (irandom(3) - irandom(3)) * 0.8) * dcos(_angle);
        _particle.shot_drift = -(4 + (irandom(3) - irandom(3)) * 0.8) * dsin(_angle);
    }
    if (shot_age >= 250 && bbox_bottom < -32) {
        instance_destroy();
    }
}

function solgryn_early_init() {
    solgryn_early_teleport_init();
    early_burst_clock = 0;
    early_bomb_clock = 0;
    early_shot_timer = 0;
    early_cloud_timer = 0;
}

function solgryn_early_hit(_player) {
    if (instance_exists(_player)) {
        audio_play_sound(snd_solgryn_early_shoot, 1, false);
        solgryn_early_shot(x, y, point_direction(x, y, _player.x, _player.y) - 5, 2);
    }
}

function solgryn_early_explosion_wave() {
    // G738/G739 and G743/G745 spawn at the rotated action point.
    var _point = solgryn_actor_action_point();
    for (var _shot = 0; _shot < 10; ++_shot) {
        solgryn_early_shot(_point[0], _point[1], 180 + _shot * 20, 5);
    }
    solgryn_early_finite_effect(_point[0], _point[1], spr_solgryn_early_cloud, 90);
    audio_play_sound(snd_king_dedede_explosion, 1, false);
}

function solgryn_early_step(_player, _age) {
    early_burst_clock += 1;
    early_bomb_clock += 1;
    if (_age >= 3300) {
        solgryn_early_teleport_step(_age);
        return;
    }
    if (_age < 2080) {
        return;
    }

    // G701–711. Spawn from the current side before changing direction on a cue.
    if (_age >= 2100 && _age <= 2200) {
        target_y = floor(250 + dsin(_age * 10) * 200);
        if (early_burst_clock >= 10) {
            early_burst_clock = 0;
            var _right = target_x == 530;
            var _burst = solgryn_early_ordnance(x, y,
                _right ? spr_solgryn_early_ice_burst_left : spr_solgryn_early_ice_burst,
                SolgrynEarlyShot.IceBurst, "Attack Effects", true, true);
            _burst.shot_facing = _right ? -1 : 1;
            audio_play_sound(snd_solgryn_early_shoot, 1, false);
            solgryn_kick(15, 1);
            solgryn_flash();
        }
        switch (_age) {
            case 2125:
            case 2190:
                target_x = 50;
                break;
            case 2160:
                target_x = 530;
                break;
        }
    }
    if (_age == 2230) {
        target_x = 530;
        target_y = 600;
    }

    // G712–732. The ice beams aim at the player's sampled X at creation.
    switch (_age) {
        case 2280:
        case 2310:
        case 2365:
            if (instance_exists(_player)) {
                var _beam = solgryn_early_beam(floor(_player.x), -3, "Attack Effects");
                // G717–718 and G735 also process this beam on its creation frame.
                _beam.shot_age = 1;
                _beam.image_yscale += 0.06;
                solgryn_early_splash(_beam.x + irandom(29) - irandom(29), _beam.y + irandom(399));
                audio_play_sound(snd_missingno_hyper_beam, 1, false);
                solgryn_kick(0, 5);
            }
            break;

        case 2420:
            solgryn_early_finite_effect(x, y, spr_solgryn_early_cloud);
            audio_play_sound(snd_solgryn_early_shoot, 1, false);
            if (instance_exists(_player)) {
                solgryn_early_shot(x, y, point_direction(x, y, _player.x, _player.y) - 5, 15);
            }
            break;

        case 2450:
            // G722 updates the arc from (530,650) immediately after Create.
            var _head = solgryn_early_ordnance(530, 650, spr_solgryn_early_head,
                SolgrynEarlyShot.Head, "Attack Effects", true);
            _head.image_angle = 260;
            _head.shot_phase = 3;
            audio_play_sound(snd_solgryn_early_eat, 1, false);
            break;

        case 2550:
            with (obj_solgryn_early_hazard) {
                if (shot_kind == SolgrynEarlyShot.Head) {
                    instance_destroy();
                }
            }
            break;

        case 2600:
        case 2620:
        case 2640:
            for (var _i = 0; _i < 45; ++_i) {
                solgryn_early_shot(x, y, _i * 10, 5);
            }
            var _sound = snd_skeleton_king_rocket_explosion;
            if (_age == 2600) {
                _sound = snd_biollante_explosion_final;
            } else if (_age == 2620) {
                _sound = snd_king_dedede_explosion;
            }
            audio_play_sound(_sound, 1, false);
            solgryn_kick(0, 3);
            break;

        case 3210:
            solgryn_early_beam(210, -3, "Attack Effects");
            solgryn_early_beam(450, -3, "Attack Effects");
            audio_play_sound(snd_missingno_hyper_beam, 1, false);
            solgryn_kick(0, 2);
            break;
    }
    if (_age >= 2480 && _age <= 2600 && ++early_cloud_timer mod 20 == 0) {
        solgryn_early_finite_effect(x, y, spr_solgryn_early_cloud);
    }
    if (_age >= 2500 && _age <= 2590) {
        solgryn_early_shot(x, y, 200 + dsin(_age * 25) * 60, 6);
        if (++early_shot_timer mod 5 == 0) {
            audio_play_sound(snd_solgryn_early_shoot, 1, false);
        }
    }
    if (_age >= 2250 && _age <= 2650) {
        target_y = floor(250 + dsin(_age * 5) * 30);
        image_angle = floor(dsin(_age * 8) * 20);
    }
    if (_age >= 2650) {
        target_y = floor(80 + dsin(_age * 5) * 15);
        target_x = floor(280 + dsin(_age * 2) * 150);
        image_angle = floor(dsin(_age * 8) * 20 - 90);
    }

    // G737–747. Above the platform the opened box drops tumbling oats.
    if (_age > 2700 && _age < 3000) {
        if (early_burst_clock > 20) {
            early_burst_clock = 0;
            var _point = solgryn_actor_action_point();
            var _oat = solgryn_early_ordnance(_point[0], _point[1], spr_solgryn_early_oat,
                SolgrynEarlyShot.Oat, "Attack Effects", true);
            _oat.image_index = irandom(2);
            var _puff = solgryn_early_ordnance(_point[0], _point[1], spr_solgryn_early_puff,
                SolgrynEarlyShot.Puff, "Attack Effects", false, true);
            _puff.image_angle = 90;
            _puff.image_xscale = 0.5;
            _puff.image_yscale = 0.5;
            audio_play_sound(snd_solgryn_early_swosh, 1, false);
        }
        if (early_bomb_clock > 70) {
            early_bomb_clock = 0;
            solgryn_early_explosion_wave();
        }
    }
    if (_age == 3000) {
        early_bomb_clock = 0;
        early_shot_timer = 0;
    }
    if (_age > 3000) {
        if (early_burst_clock > -40 && early_burst_clock <= 10) {
            solgryn_early_shot(x, y, 280 + dsin(_age * 25) * 60, 10);
            if (++early_shot_timer mod 5 == 0) {
                audio_play_sound(snd_solgryn_early_shoot, 1, false);
            }
        }
        if (early_burst_clock == 50) {
            solgryn_early_explosion_wave();
        }
        if (early_burst_clock == 100) {
            var _point = solgryn_actor_action_point();
            var _pursuer = solgryn_early_ordnance(_point[0], _point[1], spr_solgryn_early_pursuer,
                SolgrynEarlyShot.Pursuer, "Attack Effects", true);
            _pursuer.shot_origin_x = 0;
            _pursuer.shot_origin_y = 0;
            with (_pursuer) {
                solgryn_early_ordnance_step();
            }
            audio_play_sound(snd_sanicz_voice_13, 1, false);
        }
        if (early_burst_clock >= 110) {
            solgryn_early_explosion_wave();
            early_burst_clock = -150;
        }
    }
}
