enum BombermanAttack {
    SlashRing,
    BounceBomb,
    OrbitStar,
    FireTrail,
    BlueFlame,
    Roller,
    RollerPellet,
    OrbitEmber,
    HomingBat
}

function bomberman_spawn_ordnance(_kind, _x, _y, _angle = 0, _speed = 0, _direction = 1) {
    var _behind_boss = _kind == BombermanAttack.OrbitStar || _kind == BombermanAttack.BlueFlame
        || _kind == BombermanAttack.Roller;
    var _attack = instance_create_layer(_x, _y, _behind_boss ? "Hazards" : "Gameplay", obj_bomberman_ordnance);
    _attack.attack_kind = _kind;
    _attack.travel_angle = _angle;
    _attack.travel_speed = _speed;
    _attack.travel_direction = _direction;
    switch (_kind) {
        case BombermanAttack.SlashRing:
            _attack.sprite_index = spr_bomberman_slash_ring;
            _attack.animation_rate = 35;
            _attack.loop_start = 4;
            break;
        case BombermanAttack.BounceBomb:
            _attack.sprite_index = spr_bomberman_bounce_bomb;
            break;
        case BombermanAttack.OrbitStar:
            _attack.sprite_index = spr_bomberman_orbit_star;
            break;
        case BombermanAttack.FireTrail:
            _attack.sprite_index = spr_bomberman_fire_trail;
            _attack.animation_rate = 25;
            _attack.image_xscale = 0;
            _attack.image_yscale = 0;
            _attack.expires_at = 120;
            break;
        case BombermanAttack.BlueFlame:
            _attack.sprite_index = spr_bomberman_blue_flame;
            _attack.animation_rate = 25;
            _attack.image_xscale = 0;
            _attack.image_yscale = 0;
            _attack.expires_at = 20;
            break;
        case BombermanAttack.Roller:
            _attack.sprite_index = _direction > 0 ? spr_bomberman_roller_right : spr_bomberman_roller_left;
            _attack.animation_rate = 35;
            break;
        case BombermanAttack.RollerPellet:
            _attack.sprite_index = spr_bomberman_roller_pellet;
            _attack.animation_rate = 50;
            break;
        case BombermanAttack.OrbitEmber:
            _attack.sprite_index = spr_bomberman_orbit_ember;
            _attack.animation_rate = 10;
            _attack.image_xscale = 0.5;
            _attack.image_yscale = 0.5;
            break;
        case BombermanAttack.HomingBat:
            _attack.sprite_index = spr_bomberman_homing_bat;
            _attack.animation_rate = 25;
            _attack.loop_start = 3;
            _attack.image_xscale = 0.5;
            _attack.image_yscale = 0.5;
            break;
    }
    return _attack;
}

function bomberman_has_rollers() {
    var _has_roller = false;
    with (obj_bomberman_ordnance) {
        if (attack_kind == BombermanAttack.Roller) {
            _has_roller = true;
            break;
        }
    }
    return _has_roller;
}

function bomberman_ordnance_take_shot(_bullet, _player) {
    if (!instance_exists(_player)) {
        return false;
    }
    // G1251–1252 move the roller away from the player on impact.
    var _hit = false;
    with (_bullet) {
        if (place_meeting(x, y, obj_bomberman_ordnance)) {
            var _overlaps = ds_list_create();
            var _count = instance_place_list(x, y, obj_bomberman_ordnance, _overlaps, false);
            for (var _i = 0; _i < _count; ++_i) {
                var _attack = _overlaps[| _i];
                if (_attack.attack_kind == BombermanAttack.Roller && _attack.x != _player.x) {
                    _attack.velocity_x += sign(_attack.x - _player.x) * 2.4;
                    _hit = true;
                    break;
                }
            }
            ds_list_destroy(_overlaps);
        }
    }
    return _hit;
}

function bomberman_ordnance_animate() {
    frame_clock += animation_rate;
    if (frame_clock > 100) {
        frame_clock -= 100;
        ++frame_index;
        if (frame_index >= image_number) {
            if (launching) {
                launching = false;
                sprite_index = travel_direction > 0 ? spr_bomberman_roller_right : spr_bomberman_roller_left;
                frame_index = 0;
            } else {
                frame_index = loop_start;
            }
        }
    }
    image_index = frame_index;
}

function bomberman_ordnance_impact(_x, _y, _layer) {
    var _effect = instance_create_layer(_x, _y, _layer, obj_bomberman_attack_effect);
    _effect.sprite_index = spr_bomberman_impact_puff;
}

function bomberman_ordnance_projection(_speed, _angle) {
    x = floor(motion_x);
    y = floor(motion_y);
    motion_x += lengthdir_x(_speed, _angle);
    motion_y += lengthdir_y(_speed, _angle);
}

function bomberman_ordnance_bounce(_boss) {
    // G1227–1228 / G1261–1262. Bounds remain tied to the original pixel mask.
    x = floor(motion_x);
    y = floor(motion_y);
    motion_x += velocity_x;
    motion_y += velocity_y;
    velocity_y += 0.35;
    if (attack_kind == BombermanAttack.BounceBomb) {
        image_angle = (image_angle - 2 * velocity_x) mod 360;
    }
    if (velocity_y > 1 && place_meeting(x, y, obj_player_backdrop)) {
        var _floor_bomb = attack_kind == BombermanAttack.BounceBomb;
        velocity_y *= _floor_bomb ? -0.75 : -1;
        with (_boss) {
            bomberman_attack_sound(snd_bomberman_explosion);
        }
        if (_floor_bomb) {
            bomberman_ordnance_impact(x, y + 16, layer);
            if (++bounces > 2) {
                instance_destroy();
            }
        }
    }
}

function bomberman_ordnance_fire() {
    // Both flames grow from scale 0. G1235–46 keep them at their spawn positions.
    if (age < expires_at) {
        image_xscale = min(1, image_xscale + 0.1);
    } else {
        image_xscale = max(0, image_xscale - 0.05);
    }
    image_yscale = image_xscale;
    if (image_xscale == 0 || age >= expires_at + 40) {
        instance_destroy();
    }
}

function bomberman_ordnance_roller(_boss) {
    // G1248–1259. The launch animation precedes the periodic pellet.
    ++pulse;
    x = floor(motion_x);
    motion_x += velocity_x;
    velocity_x += (travel_direction * 0.5 - velocity_x) * 0.1;
    if (pulse == 70) {
        sprite_index = travel_direction > 0 ? spr_bomberman_roller_launch_right : spr_bomberman_roller_launch_left;
        launching = true;
        frame_index = 0;
        frame_clock = 0;
        image_index = 0;
    }

    if (!landed && !falling) {
        y = min(312, floor(motion_y));
        motion_y += velocity_y;
        velocity_y += 0.75;
        if (y == 312) {
            landed = true;
            with (_boss) {
                shake_strength = 5;
            }
            bomberman_ordnance_impact(x, y, layer);
        }
    }
    if (landed && !place_meeting(x, y, obj_player_backdrop)) {
        landed = false;
        falling = true;
        motion_y = y;
        velocity_y = 0;
    }
    if (falling) {
        y = floor(motion_y);
        motion_y += velocity_y;
        ++velocity_y;
    }
    if (y >= 550) {
        instance_destroy();
    }
}

function bomberman_emit_roller_pellet(_roller) {
    var _offset_x = _roller.launching && _roller.frame_index < 3 ? 15 : 17;
    var _offset_y = _roller.launching ? (_roller.frame_index < 3 ? -9 : -8) : -4;
    var _pellet = bomberman_spawn_ordnance(BombermanAttack.RollerPellet,
        _roller.x + _offset_x * _roller.travel_direction, _roller.y + _offset_y);
    // G1249 uses (Dir - 8) * -0.25 in Fusion. The pellet travels toward the muzzle.
    _pellet.velocity_x = 2 * _roller.travel_direction;
    _pellet.velocity_y = -4;
    _roller.pulse = 0;
}

function bomberman_ordnance_step(_player) {
    var _boss = id;
    var _roller = noone;
    var _roller_count = 0;
    var _ember = noone;
    var _ember_count = 0;

    with (obj_bomberman_ordnance) {
        ++age;
        bomberman_ordnance_animate();
        switch (attack_kind) {
            case BombermanAttack.SlashRing:
                bomberman_ordnance_projection(travel_speed, travel_angle);
                image_xscale = 1.25 + dcos(other.scene_steps * 20) * 0.25;
                image_yscale = image_xscale;
                break;
            case BombermanAttack.BounceBomb:
            case BombermanAttack.RollerPellet:
                bomberman_ordnance_bounce(_boss);
                break;
            case BombermanAttack.OrbitStar:
            case BombermanAttack.OrbitEmber:
                travel_angle += 4;
                travel_speed += attack_kind == BombermanAttack.OrbitStar ? 1.15 : 1;
                x = floor(motion_x + lengthdir_x(travel_speed, travel_angle));
                y = floor(motion_y + lengthdir_y(travel_speed, travel_angle));
                if (attack_kind == BombermanAttack.OrbitStar) {
                    image_angle = (image_angle + 15) mod 360;
                    pulse += 1 + travel_speed * 0.1;
                    if (pulse >= 100) {
                        pulse = 0;
                        bomberman_spawn_ordnance(BombermanAttack.FireTrail, x, y);
                    }
                } else if (age >= expires_at && irandom(++_ember_count - 1) == 0) {
                    _ember = id;
                }
                if (travel_angle >= 1800) {
                    instance_destroy();
                }
                break;
            case BombermanAttack.FireTrail:
            case BombermanAttack.BlueFlame:
                bomberman_ordnance_fire();
                break;
            case BombermanAttack.Roller:
                bomberman_ordnance_roller(_boss);
                if (pulse >= 80 && irandom(++_roller_count - 1) == 0) {
                    _roller = id;
                }
                break;
            case BombermanAttack.HomingBat:
                bomberman_ordnance_projection(travel_speed, travel_angle);
                travel_speed += 0.15;
                break;
        }
        // The source culls bomb sprites outside a 32px margin. Unbounded shots
        // are also retired once their trajectory carries them clear of the arena.
        if ((attack_kind == BombermanAttack.SlashRing || attack_kind == BombermanAttack.HomingBat
                || attack_kind == BombermanAttack.BounceBomb || attack_kind == BombermanAttack.RollerPellet)
            && (bbox_left <= -32 || bbox_right >= 671 || bbox_top <= -32 || bbox_bottom >= 511)) {
            instance_destroy();
        }
    }

    if (instance_exists(_roller)) {
        bomberman_emit_roller_pellet(_roller);
    }
    if (_player != noone && instance_exists(_ember)) {
        // CND_EXTCHOOSE fires one eligible ember per frame.
        var _angle = point_direction(_ember.x, _ember.y, _player.x, _player.y);
        bomberman_spawn_ordnance(BombermanAttack.HomingBat, _ember.x, _ember.y, _angle, 1);
        instance_destroy(_ember);
        bomberman_attack_sound(snd_bomberman_teleport_warning);
    }

    with (obj_bomberman_attack_effect) {
        // Both finite effects use their on-create clips at 25% speed.
        ++effect_age;
        var _frame = max(0, (effect_age - 1) div 4);
        if (_frame >= image_number) {
            instance_destroy();
        } else {
            image_index = _frame;
        }
    }
}
