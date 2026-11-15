enum CheetahMenAttack {
    TrackingFlame,
    SpiralShot,
    HoppingCharge,
    Runner,
    Bouncer,
    BouncingBird,
    OrbitFire,
    FinisherFlame,
    FallingTornado,
    Blast,
    Debris,
    TornadoTrail,
    Explosion,
    FlyingPlatform
}

function cheetah_men_pixel(_value) {
    return sign(_value) * floor(abs(_value));
}

function cheetah_men_spawn(_kind, _x, _y, _hsp = 0, _vsp = 0, _angle = 0) {
    if (_kind == CheetahMenAttack.FlyingPlatform) {
        return instance_create_layer(_x, _y, "Floor", obj_cheetah_men_air_platform);
    }
    static _sprites = [
        spr_cheetah_men_tracking_tornado, spr_cheetah_men_spiral_shot,
        spr_cheetah_men_hopping_charge, spr_cheetah_men_runner,
        spr_cheetah_men_bouncer, spr_cheetah_men_bouncing_bird,
        spr_cheetah_men_orbit_fire, spr_cheetah_men_finisher_flame,
        spr_cheetah_men_falling_tornado, spr_cheetah_men_blast,
        spr_cheetah_men_debris, spr_cheetah_men_tornado_trail, spr_cheetah_men_explosion
    ];
    var _effect = _kind >= CheetahMenAttack.Debris;
    var _layer = _effect || _kind == CheetahMenAttack.Blast ? "Effects" : "Hazards";
    var _object = _effect ? obj_cheetah_men_attack_effect : obj_cheetah_men_projectile;
    if (_kind == CheetahMenAttack.SpiralShot && _hsp == 0) {
        _hsp = 1;
    }
    return instance_create_layer(_x, _y, _layer, _object, {
        sprite_index: _sprites[_kind], image_angle: _angle,
        attack_kind: _kind, attack_age: 0, flash_age: 0, hits: 0, resting: false,
        travel_x: _hsp, travel_y: _vsp, track_x: _x, track_y: _y, wave_offset: _angle
    });
}

function cheetah_men_break_tile(_tile) {
    if (_tile == noone) {
        return;
    }
    // The native floor impact creates two independent pieces at the panel's hotspot.
    repeat (2) {
        var _piece = cheetah_men_spawn(CheetahMenAttack.Debris, _tile.x, _tile.y,
            (irandom(19) - irandom(19)) * 0.1, -2 - irandom(29) * 0.1, irandom(359));
        _piece.image_xscale = 1 + irandom(49) * 0.01;
        _piece.image_yscale = _piece.image_xscale;
    }
    instance_destroy(_tile);
}

function cheetah_men_runner_flash() {
    if (flash_age > 0) {
        // G1132–1138 hide at ages 2/6 and show at 1/4/8. The collision remains active.
        switch (flash_age) {
            case 2:
            case 6:
                visible = false;
                break;
            case 1:
            case 4:
            case 8:
                visible = true;
                break;
        }
        flash_age = flash_age == 8 ? 0 : flash_age + 1;
    }
}

function cheetah_men_update_projectile(_boss, _player, _timer) {
    ++attack_age;
    switch (attack_kind) {
        case CheetahMenAttack.TrackingFlame:
            // G1100–1104 keep a fractional vertical accumulator and trail behind each tornado.
            x += travel_x;
            y = cheetah_men_pixel(track_y);
            track_y += travel_y;
            if (_player != noone) {
                travel_y += sign(_player.y - y) * 0.07;
            }
            image_angle = dsin(_timer * 0.8) * 15;
            image_xscale = 1.5 + dsin(_timer div 2) * 0.25;
            image_yscale = image_xscale;
            if (bbox_right < 0 || bbox_top >= room_height || bbox_bottom < 0) {
                instance_destroy();
            }
            break;

        case CheetahMenAttack.SpiralShot:
            // G1117 accelerates the radial launch speed from the unmodified one-pixel lead.
            x = cheetah_men_pixel(track_x);
            y = cheetah_men_pixel(track_y);
            if (_boss.fight_age > 620) {
                travel_x += 0.2;
            }
            track_x += dcos(image_angle) * travel_x;
            track_y -= dsin(image_angle) * travel_x;
            break;

        case CheetahMenAttack.HoppingCharge:
            // G1121–1124 start with five horizontal steps, then jump from each floor panel.
            x += travel_x;
            image_angle = dsin(_timer div 2) * 10;
            if (!resting && attack_age >= 5) {
                resting = true;
                travel_y = -3;
            }
            if (resting) {
                y = cheetah_men_pixel(y + travel_y);
                travel_y += 0.2;
            }
            var _tile = instance_place(x, y, obj_cheetah_men_floor);
            if (_tile != noone) {
                resting = false;
                travel_y = 0;
                cheetah_men_break_tile(_tile);
            }
            break;

        case CheetahMenAttack.Runner:
            x = cheetah_men_pixel(x + travel_x);
            if (x >= 532) {
                x = 130;
                travel_x = min(32, travel_x + 0.5);
            }
            cheetah_men_runner_flash();
            break;

        case CheetahMenAttack.Bouncer:
            // G1167 and G1169–1177 apply steering after the platform fails the overlap.
            if (_boss.fight_age <= 2600 && travel_y >= 4) {
                travel_y = 4;
            }
            x = cheetah_men_pixel(x + travel_x);
            y = cheetah_men_pixel(y + travel_y);
            travel_y += 0.5;
            if (travel_y > 0 && place_meeting(x, y, obj_cheetah_men_air_platform)) {
                travel_y = -9;
                travel_x = _player == noone ? 0 : (_player.x - x) * 0.03;
                cheetah_men_spawn_bouncing_bird(x, y - 32);
            }
            if ((x < 152 && travel_x < 0) || (x >= 460 && travel_x > 0)) {
                travel_x = -travel_x;
            }
            if (attack_age >= 500) {
                cheetah_men_spawn_bouncing_bird(x, y - 32);
                image_xscale = 2;
                image_yscale = 2;
            }
            if (_player != noone && abs(travel_x) == 0) {
                travel_x = sign(_player.x - x);
            }
            break;

        case CheetahMenAttack.BouncingBird:
            if (resting) {
                if (++flash_age >= 200) {
                    cheetah_men_spawn(CheetahMenAttack.Explosion, x, y);
                    instance_destroy();
                }
                break;
            }
            x = cheetah_men_pixel(track_x);
            y = cheetah_men_pixel(track_y);
            track_x += travel_x;
            track_y += travel_y;
            travel_y += 0.5;
            image_angle += 4 + irandom(2);
            var _landing_tile = instance_place(x, y, obj_cheetah_men_air_platform);
            if (_landing_tile != noone) {
                resting = true;
                image_angle = 0;
                y = _landing_tile.y - 9;
                image_yscale = 0.8;
            }
            break;

        case CheetahMenAttack.OrbitFire:
            x = cheetah_men_pixel(x + travel_x);
            y = cheetah_men_pixel(y + travel_y);
            travel_y += 0.4;
            image_angle += 4;
            if (place_meeting(x, y, [obj_cheetah_men_floor, obj_cheetah_men_air_platform])) {
                cheetah_men_spawn(CheetahMenAttack.Blast, x, y);
                _boss.shake_strength = 5;
                instance_destroy();
            }
            break;

        case CheetahMenAttack.FinisherFlame:
            y -= 2;
            if (y <= -16) {
                for (var _i = 1; _i <= 5; ++_i) {
                    cheetah_men_spawn(CheetahMenAttack.FallingTornado, 143 + _i * 75, -47,
                        0, 0, irandom(29) * 15);
                }
                instance_destroy();
            }
            break;

        case CheetahMenAttack.FallingTornado:
            x = track_x + dsin(_boss.fight_age * 6 + wave_offset) * 30;
            y += 3;
            image_angle = dsin(_timer div 3 + wave_offset) * 15;
            break;

        case CheetahMenAttack.Blast:
            if (attack_age >= 25) {
                instance_destroy();
            }
            break;
    }

    // Some shots start offscreen. Cull after the object has passed the arena.
    if (bbox_top > room_height + 48
        || (bbox_bottom < -160 && attack_kind == CheetahMenAttack.SpiralShot)
        || (bbox_right < -64 && attack_kind != CheetahMenAttack.Bouncer)
        || (bbox_left > room_width + 75 && attack_kind == CheetahMenAttack.SpiralShot)) {
        instance_destroy();
    }
}

function cheetah_men_spawn_bouncing_bird(_x, _y) {
    var _bird = cheetah_men_spawn(CheetahMenAttack.BouncingBird, _x, _y,
        (irandom(19) - irandom(19)) * 0.1, -11 - irandom(29) * 0.1, irandom(359));
    _bird.image_xscale = 1 + irandom(49) * 0.01;
    _bird.image_yscale = _bird.image_xscale;
}

function cheetah_men_ordnance_step(_player) {
    var _clock = encounter_steps * 20;
    var _tornadoes = [];
    with (obj_cheetah_men_projectile) {
        cheetah_men_update_projectile(other.id, _player, _clock);
        if (attack_kind == CheetahMenAttack.TrackingFlame && bbox_right >= 0
            && bbox_top < room_height && bbox_bottom >= 0) {
            array_push(_tornadoes, id);
        }
    }
    if (array_length(_tornadoes) > 0) {
        // G1104 chooses a single tornado each step for the trail artwork.
        var _tornado = _tornadoes[irandom(array_length(_tornadoes) - 1)];
        cheetah_men_spawn(CheetahMenAttack.TornadoTrail,
            _tornado.x + irandom(15) - irandom(15), _tornado.y - irandom(31), 0, 0, irandom(359));
    }
    with (obj_cheetah_men_attack_effect) {
        ++attack_age;
        switch (attack_kind) {
            case CheetahMenAttack.Debris:
                x = cheetah_men_pixel(track_x);
                y = cheetah_men_pixel(track_y);
                track_x += travel_x;
                track_y += travel_y;
                travel_y += 0.5;
                if (bbox_top > room_height + 32) {
                    instance_destroy();
                }
                break;
            case CheetahMenAttack.TornadoTrail:
                if (attack_age >= 24) {
                    instance_destroy();
                }
                break;
            case CheetahMenAttack.Explosion:
                if (attack_age >= 20) {
                    instance_destroy();
                }
                break;
        }
    }
    cheetah_men_bees_step(_player);
}

function cheetah_men_attacks_take_shot(_shot) {
    if (cheetah_men_phase_three_take_shot(_shot)) {
        return true;
    }
    var _is_player_shot = _shot.object_index == obj_bullet;
    var _step = encounter_steps;
    var _hit = false;
    with (obj_cheetah_men_projectile) {
        if (attack_kind != CheetahMenAttack.Runner
            && (attack_kind != CheetahMenAttack.Bouncer || !_is_player_shot)) {
            continue;
        }
        var _target = id;
        with (_shot) {
            _hit = place_meeting(x, y, _target);
        }
        if (!_hit) {
            continue;
        }

        // G1129 increments the runner once per contact and destroys Bullet 2.
        if (!_is_player_shot) {
            var _new_contact = _shot.cheetah_runner_contact_step < _step - 1;
            _shot.cheetah_runner_contact_step = _step;
            if (!_new_contact) {
                break;
            }
            with (obj_bullet) {
                instance_destroy();
            }
        }

        audio_play_sound(snd_mario_bump, 1, false);
        ++hits;
        if (attack_kind == CheetahMenAttack.Runner) {
            flash_age = 1;
            if (hits >= 70) {
                cheetah_men_spawn(CheetahMenAttack.Explosion, x, y - 28);
                other.phase_one_cleared = true;
                other.fight_age = 1350;
                other.pause_for_phase_clear();
                instance_destroy();
            }
        } else if (hits >= 20) {
            cheetah_men_spawn(CheetahMenAttack.Explosion, x, y);
            other.fight_age = 2999;
            other.pause_for_phase_clear();
            instance_destroy();
        }
        break;
    }
    return _is_player_shot && _hit;
}
