enum SaniczProjectile {
    Lightning,
    OrbShot,
    OrbBurst,
    Pellet
}

function sanicz_attacks_setup() {
    lightning_spawn_steps = 5;
    orb_shot_steps = 100;
    pellet_spawn_steps = 15;
    star_slow_ms = 300;
    star_fast_ms = 150;
    chasing_shake = false;
    sanicz_bumpers_setup();
}

function sanicz_attacks_step(_player) {
    sanicz_arena_hazards_step();
    sanicz_lightning_step(_player);
    sanicz_spawn_attack_trails();
    sanicz_orb_step(_player);
    sanicz_pellets_step(_player);

    // Group 1174 shakes once as the spinning boss approaches the player.
    var _nearby = _player != noone && pose_animation == 14
        && abs(x - _player.x) + abs(y - _player.y) < 200;
    if (_nearby && !chasing_shake) {
        shake_strength = 10;
    }
    chasing_shake = _nearby;
}

function sanicz_attacks_clear_for_victory() {
    // Group 1202 removes these attacks immediately. Eggman's already fired shots finish their paths.
    with (obj_sanicz_orb) {
        instance_destroy();
    }
    with (obj_sanicz_attack_hazard) {
        if (attack_kind == SaniczProjectile.Lightning || attack_kind == SaniczProjectile.Pellet) {
            instance_destroy();
        }
    }
    sanicz_arena_hazards_clear();
}

function sanicz_lightning_step(_player) {
    // Groups 1153–1155 build the orbit and release every bolt toward the player at age 920.
    if (fight_age >= 810 && fight_age < 880 && --lightning_spawn_steps == 0) {
        lightning_spawn_steps = 5;
        instance_create_depth(x - 50, y - 50, depth - 1, obj_sanicz_attack_hazard, {
            attack_kind: SaniczProjectile.Lightning,
            sprite_index: spr_sanicz_lightning,
            image_index: irandom(6),
            launched: false
        });
    }

    var _fire = fight_age == 920 && _player != noone;
    if (_fire) {
        audio_play_sound(snd_stock_sonic_air_jump, 1, false);
    }
    with (obj_sanicz_attack_hazard) {
        if (attack_kind != SaniczProjectile.Lightning || launched) {
            continue;
        }
        if (_fire) {
            var _angle = darctan2(x - _player.x, y - _player.y) + 90 + irandom(2) - irandom(2);
            image_angle = _angle - frac(_angle);
            launched = true;
            travel_x = x;
            travel_y = y;
            velocity_x = dcos(image_angle) * 8;
            velocity_y = -dsin(image_angle) * 8;
        } else {
            orbit_phase += 15;
            var _orbit = orbit_phase div 2;
            x = floor(other.x + dcos(_orbit) * (32 + dsin(_orbit) * 8));
            y = floor(other.y - 20 - dsin(_orbit) * 32);
        }
    }
}

function sanicz_spawn_attack_trails() {
    // Groups 1164 and 1173 each create an additive puff during the chase.
    if (fight_age >= 950 && fight_age < 2500) {
        sanicz_spawn_puff(x, y);
        if (fight_age < 2000 || fight_age >= 2200) {
            sanicz_spawn_puff(x, y);
        }
    }

    // Groups 1186 and 1188 can both fire, with the leftward puff created before the rightward move.
    if (fight_age >= 2800 && fight_age < 2920) {
        var _left_x = fight_age == 2850 ? xprevious - 35 : x - (fight_age >= 2840 ? 35 : 0);
        var _left_y = fight_age == 2850 ? yprevious : y;
        sanicz_spawn_puff(_left_x, _left_y);
    }
    if ((fight_age >= 2550 && fight_age < 2620) || (fight_age >= 2680 && fight_age < 2740)
        || (fight_age >= 2840 && fight_age < 3000)) {
        sanicz_spawn_puff(x, y);
    }
}

function sanicz_spawn_puff(_x, _y) {
    var _scale = 0.5 + irandom(49) * 0.01;
    instance_create_depth(_x, _y, depth - 1, obj_sanicz_attack_effect, {
        sprite_index: spr_sanicz_explosion,
        image_xscale: _scale,
        image_yscale: _scale
    });
}

function sanicz_orb_step(_player) {
    if (!instance_exists(inst_sanicz_orb)) {
        return;
    }
    var _orb = inst_sanicz_orb;
    if (fight_age >= 950 && fight_age < 2500) {
        // Group 1175 repeats the same position as 1173 before the shot action.
        _orb.x = floor(300 + dcos((scene_steps * 20) div 10) * 300);
        _orb.y = floor(100 + dsin((scene_steps * 20) div 3) * 32);
        _orb.visible = true;
    }
    if (fight_age >= 2000 && fight_age < 2200) {
        _orb.x = 823;
        _orb.y = 74;
        _orb.visible = false;
    }

    // The timer begins at the first condition and keeps running after the attack window.
    if (fight_age >= 1100 && --orb_shot_steps == 0) {
        orb_shot_steps = 100;
        if (fight_age < 2000 && _player != noone) {
            sanicz_fire_orb(_orb, _player);
        }
    }
}

function sanicz_fire_orb(_orb, _player) {
    static _offset_x = [-2, -1, 0, -1];
    static _offset_y = [6, 6, 5, 6];
    static _thresholds = [2599, 844, 479, 312, 210, 137, 78, 25, 0];
    static _cosines = [
        256, 251, 236, 212, 181, 142, 97, 49,
        0, -49, -97, -142, -181, -212, -236, -251,
        -256, -251, -236, -212, -181, -142, -97, -49,
        0, 49, 97, 142, 181, 212, 236, 251
    ];
    var _frame = floor(_orb.image_index) mod array_length(_offset_x);
    var _x = _orb.x + _offset_x[_frame];
    var _y = _orb.y + _offset_y[_frame];
    var _dx = _player.x - _x;
    var _dy = _player.y - _y;
    // Fusion's Shoot Toward uses slope thresholds and a fixed-point direction table.
    var _direction = 24;
    if (_dx != 0) {
        var _slope = _dy == 0 ? _thresholds[0] : abs(_dx * 256 / _dy);
        var _index = 0;
        while (_slope < _thresholds[_index]) {
            ++_index;
        }
        _direction = (32 - _index) mod 32;
    }
    if (_dy < 0) {
        _direction = (32 - _direction) mod 32;
    }
    if (_dx < 0) {
        _direction = (48 - _direction) mod 32;
    }
    instance_create_depth(_x, _y, _orb.depth - 1, obj_sanicz_attack_hazard, {
        attack_kind: SaniczProjectile.OrbShot,
        sprite_index: spr_sanicz_orb_warning,
        launched: true,
        velocity_x: _cosines[_direction] * 2.5 / 256,
        velocity_y: _cosines[(_direction + 8) mod 32] * 2.5 / 256
    });
}

function sanicz_pellets_step(_player) {
    if (fight_age >= 3000 && --pellet_spawn_steps == 0) {
        pellet_spawn_steps = 15;
        if (fight_age < 3400 && _player != noone) {
            // Groups 1191 and 1240 fire at the player from the circular flight path.
            var _angle = darctan2(x - _player.x, y - _player.y) + 90;
            _angle -= frac(_angle);
            instance_create_depth(x, y, depth - 1, obj_sanicz_attack_hazard, {
                attack_kind: SaniczProjectile.Pellet,
                sprite_index: spr_sanicz_projectile,
                image_angle: _angle,
                launched: true,
                velocity_x: dcos(_angle) * 2,
                velocity_y: -dsin(_angle) * 2
            });
        }
    }
}

function sanicz_ambient_step() {
    if (instance_exists(inst_sanicz_sky)) {
        return;
    }

    // Group 1212 has independent 300 and 150 ms timer branches with one shared spawn action.
    star_slow_ms -= 20;
    star_fast_ms -= 20;
    var _spawn = star_slow_ms <= 0 || star_fast_ms <= 0;
    if (star_slow_ms <= 0) {
        star_slow_ms += 300;
    }
    if (star_fast_ms <= 0) {
        star_fast_ms += 150;
    }
    if (_spawn) {
        instance_create_depth(40 + irandom(559), 40 + irandom(399), 175, obj_sanicz_attack_effect, {
            sprite_index: spr_sanicz_cameo_still
        });
    }
}
