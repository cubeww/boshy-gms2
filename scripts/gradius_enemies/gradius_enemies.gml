enum GradiusEnemy {
    Wave,
    Diver,
    Spinner,
    Gunner
}

function gradius_enemy_setup() {
    static _idle_sprites = [
        spr_gradius_wave_enemy,
        spr_gradius_diver_enemy,
        spr_gradius_spinner_enemy,
        spr_gradius_gunner_enemy
    ];
    static _template_health = [10, 15, 10, 15];
    enemy_hit_points = _template_health[enemy_kind];
    enemy_phase = 0;
    fire_steps = 0;
    enemy_facing = 0;
    sprite_index = _idle_sprites[enemy_kind];
    image_index = 0;
    image_speed = 1;
    // Groups 888, 891, 894, 896 and 971–974 scale every spawned fighter to 200%.
    image_xscale = 2;
    image_yscale = 2;
}

function gradius_spawn_enemy(_kind, _x, _y, _phase_step = 0, _health = undefined) {
    var _enemy = instance_create_depth(_x, _y, 0, obj_gradius_enemy, { enemy_kind: _kind });
    _enemy.enemy_phase = _phase_step;
    if (!is_undefined(_health)) {
        _enemy.enemy_hit_points = _health;
    }
    return _enemy;
}

function gradius_enemy_hits_step() {
    if (!instance_exists(obj_gradius_player_shot)) {
        return;
    }
    // Fusion's static objects check overlap before the event sheet writes new positions.
    static _event_order = [GradiusEnemy.Gunner, GradiusEnemy.Spinner, GradiusEnemy.Diver, GradiusEnemy.Wave];
    var _hits = ds_list_create();
    for (var _i = 0; _i < array_length(_event_order); ++_i) {
        var _kind = _event_order[_i];
        with (obj_gradius_enemy) {
            if (enemy_kind == _kind) {
                gradius_enemy_take_hits(_hits);
            }
        }
    }
    ds_list_destroy(_hits);
}

function gradius_enemies_step() {
    // Group 898 shifts the horizontal formation before the other enemy movement groups.
    with (obj_gradius_enemy) {
        if (enemy_kind == GradiusEnemy.Wave) {
            x -= enemy_phase;
        }
    }

    static _event_order = [GradiusEnemy.Gunner, GradiusEnemy.Spinner, GradiusEnemy.Diver, GradiusEnemy.Wave];
    for (var _i = 0; _i < array_length(_event_order); ++_i) {
        var _kind = _event_order[_i];
        with (obj_gradius_enemy) {
            if (enemy_kind != _kind) {
                continue;
            }
            if (enemy_hit_points <= 0 && gradius_enemy_try_die()) {
                continue;
            }
            gradius_enemy_move();
        }
    }
}

function gradius_enemy_take_hits(_hits) {
    ds_list_clear(_hits);
    var _count = instance_place_list(x, y, obj_gradius_player_shot, _hits, false);
    for (var _i = 0; _i < _count; ++_i) {
        var _shot = _hits[| _i];
        if (!_shot.shot_spent) {
            enemy_hit_points -= _shot.shot_damage;
            _shot.gradius_player_shot_hit();
            audio_play_sound(snd_gradius_hit, 1, false);
        }
    }
}

function gradius_enemy_try_die() {
    // The three chance conditions run in order until the enemy starts disappearing.
    if (irandom(4) > 3) {
        if (irandom(4) <= 1) {
            gradius_spawn_capsule(x, y);
        } else if (irandom(4) <= 1) {
            gradius_spawn_capsule(x, y, true);
        } else {
            return false;
        }
    }

    var _wave = enemy_kind == GradiusEnemy.Wave;
    instance_create_depth(x, y, depth, obj_gradius_enemy_blast, {
        sprite_index: _wave ? spr_gradius_wave_enemy_blast : spr_gradius_enemy_blast,
        image_xscale: image_xscale,
        image_yscale: image_yscale,
        blast_rate: _wave ? 25 : 30
    });
    audio_play_sound(snd_gradius_explode, 1, false);
    instance_destroy();
    return true;
}

function gradius_enemy_move() {
    // Groups 906, 920, 932 and 947 preserve the fighter's state when it crosses the left margin.
    if (x < -32) {
        x = room_width + 32;
    }

    switch (enemy_kind) {
        case GradiusEnemy.Diver:
            // Groups 933–938 alternate climbing and diving on a 40-count cycle.
            enemy_phase += 0.5;
            x -= 2;
            if (enemy_phase <= 15) {
                y -= 2;
            }
            if (enemy_phase >= 20 && enemy_phase <= 35) {
                y += 2;
            }

            if (enemy_phase < 15) {
                sprite_index = spr_gradius_diver_enemy_up;
            } else if (enemy_phase >= 20 && enemy_phase < 35) {
                sprite_index = spr_gradius_diver_enemy_down;
            } else {
                sprite_index = spr_gradius_diver_enemy;
            }
            if (enemy_phase == 40) {
                enemy_phase = 0;
            }
            break;

        case GradiusEnemy.Spinner:
            // Groups 921–923 write the sine offset into the integer position every step.
            ++enemy_phase;
            x -= 5;
            y = floor(y + dsin(enemy_phase * 4) * 3);
            if (y < -32 || y > room_height + 32) {
                y = room_height + 16;
            }
            break;

        case GradiusEnemy.Gunner:
            gradius_gunner_step();
            break;
    }
}

function gradius_gunner_step() {
    ++enemy_phase;
    ++fire_steps;
    --x;
    if (fire_steps > 10 && enemy_phase <= 90) {
        // Groups 908–909 create at the current action point before changing direction.
        if (enemy_phase <= 30) {
            gradius_gunner_fire(160);
            enemy_facing = 24;
            sprite_index = spr_gradius_gunner_enemy_down;
        } else if (enemy_phase <= 60) {
            gradius_gunner_fire(120);
            enemy_facing = 0;
            sprite_index = spr_gradius_gunner_enemy;
        } else {
            // Group 910 changes direction before creating its shot.
            enemy_facing = 8;
            sprite_index = spr_gradius_gunner_enemy_up;
            gradius_gunner_fire(100);
        }
        fire_steps = 0;
    }
    if (enemy_phase >= 150) {
        enemy_phase = 0;
    }
}

function gradius_gunner_fire(_angle) {
    var _muzzle_x = 1;
    var _muzzle_y = -13;
    if (enemy_facing == 8) {
        _muzzle_x = 4;
        _muzzle_y = -14;
    } else if (enemy_facing == 24) {
        _muzzle_x = -1;
        _muzzle_y = -9;
    }

    // The authored creation action uses the current directional frame's scaled action point.
    instance_create_depth(x + _muzzle_x * image_xscale, y + _muzzle_y * image_yscale, depth - 1,
        obj_gradius_enemy_shot, { image_angle: _angle });
}

function gradius_enemy_shots_step() {
    with (obj_gradius_enemy_shot) {
        // Groups 977–978 keep the fractional position in two alterable values.
        x = floor(shot_x);
        y = floor(shot_y);
        shot_x += dcos(image_angle) * 5;
        shot_y -= dsin(image_angle) * 5;
        if (x < -64 || x > room_width + 64 || y < -64 || y > room_height + 64) {
            instance_destroy();
        }
    }
}
