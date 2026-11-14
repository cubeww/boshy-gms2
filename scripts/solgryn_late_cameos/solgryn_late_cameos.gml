enum SolgrynGuest {
    Ryu,
    Hadoken,
    Car,
    CarDebris,
    Kitty,
    KittyLaser,
    SmallMario,
    GiantMario,
    LiuKang,
    LiuKangAttacker,
    Blood,
    MissingNo,
    HydroPump,
    Spider,
    Bomberman,
    Bomb,
    SecondBomb,
    Sonic,
    Fade
}

function solgryn_late_cameos_init() {
    cameo_actors = [];
}

function solgryn_cameo_actor_init() {
    guest_age = 0;
    guest_hsp = 0;
    guest_vsp = 0;
    guest_gravity = 0;
    guest_animation = 0;
    guest_hold_image = false;
    guest_life = 40;
    guest_fade_from = 15;
    guest_fade_end = 26;
    guest_grow = 0;
    guest_streak = 0;
    guest_blend = bm_normal;
    guest_attacker = noone;
    guest_caption = noone;
    image_speed = 0;
}

function solgryn_cameo_spawn(_kind, _sprite, _x, _y, _hazard) {
    var _object = _hazard ? obj_solgryn_late_cameos_hazard : obj_solgryn_late_cameos_effect;
    var _actor = instance_create_layer(_x, _y, "Attack Effects", _object);
    _actor.guest_kind = _kind;
    _actor.sprite_index = _sprite;
    array_push(cameo_actors, _actor);
    return _actor;
}

function solgryn_cameo_pose(_actor, _sprite) {
    if (_actor.sprite_index != _sprite) {
        _actor.sprite_index = _sprite;
        _actor.guest_animation = 0;
        _actor.image_index = 0;
    }
}

function solgryn_cameo_draw() {
    gpu_set_blendmode(guest_blend);
    if (guest_streak >= 1) {
        for (var _trail = 3; _trail >= 1; --_trail) {
            draw_sprite_ext(sprite_index, image_index, x + guest_streak * _trail, y,
                image_xscale, image_yscale, image_angle, image_blend, image_alpha * (0.32 - _trail * 0.06));
        }
    }
    draw_self();
    gpu_set_blendmode(bm_normal);
}

function solgryn_cameo_afterimage(_actor, _sprite, _grow, _fade_steps) {
    var _ghost = solgryn_cameo_spawn(SolgrynGuest.Fade, _sprite, _actor.x, _actor.y, false);
    _ghost.image_index = min(_ghost.image_number - 1, floor(_actor.image_index));
    _ghost.guest_hold_image = true;
    _ghost.image_xscale = _actor.image_xscale;
    _ghost.image_yscale = _actor.image_yscale;
    _ghost.image_angle = _actor.image_angle;
    _ghost.guest_grow = _grow;
    _ghost.guest_life = ceil(_fade_steps);
    _ghost.guest_fade_from = 0;
    _ghost.guest_fade_end = _fade_steps;
}

function solgryn_cameo_ryu(_actor) {
    var _age = _actor.guest_age;
    switch (_age) {
        case 20:
            _actor.x = 711;
            _actor.y = 2817;
            solgryn_cameo_pose(_actor, spr_solgryn_late_cameos_ryu_spin);
            audio_play_sound(snd_ryu_tatsumaki, 1, false);
            break;
        case 100:
        case 130:
            for (var _i = 0; _i < 10; ++_i) {
                var _shot = solgryn_cameo_spawn(SolgrynGuest.Hadoken, spr_solgryn_late_cameos_hadoken,
                    (_age == 100 ? 0 : 32) + _i * 62, 2380, true);
                _shot.guest_age = -1;
                _shot.guest_vsp = 5;
                _shot.image_angle = -90;
            }
            audio_play_sound(snd_solgryn_late_cameos_hadoken, 1, false);
            solgryn_blur(2);
            break;
        case 140:
            _actor.x = 707;
            _actor.y = 2786;
            solgryn_cameo_pose(_actor, spr_solgryn_late_cameos_ryu_spin);
            audio_play_sound(snd_ryu_tatsumaki, 1, false);
            break;
        case 170:
            solgryn_cameo_pose(_actor, spr_solgryn_late_cameos_ryu_idle);
            break;
        case 190:
            solgryn_cameo_pose(_actor, spr_solgryn_late_cameos_ryu_car_pose);
            var _car = solgryn_cameo_spawn(SolgrynGuest.Car, spr_solgryn_late_cameos_car, _actor.x, _actor.y, true);
            _car.depth = _actor.depth + 1;
            _car.guest_age = -1;
            _car.guest_hold_image = true;
            _car.guest_next_x = _car.x;
            _car.guest_next_y = _car.y;
            _car.guest_hsp = -3;
            _car.guest_vsp = -12;
            _car.guest_hit_backdrop = false;
            audio_play_sound(snd_solgryn_late_cameos_car_cue, 1, false);
            break;
        case 370:
            var _kitty = solgryn_cameo_spawn(SolgrynGuest.Kitty, spr_solgryn_late_cameos_kitty, 568, 2337, false);
            _kitty.image_xscale = 4;
            _kitty.image_yscale = 4;
            break;
        case 400:
            solgryn_cameo_pose(_actor, spr_solgryn_late_cameos_ryu_spin);
            audio_play_sound(snd_ryu_tatsumaki, 1, false);
            break;
        case 480:
            var _mario = solgryn_cameo_spawn(SolgrynGuest.SmallMario,
                spr_solgryn_late_cameos_mario_jump, -24, 2627, true);
            _mario.guest_vsp = -10;
            _mario.image_xscale = 3;
            _mario.image_yscale = 3;
            audio_play_sound(snd_mario_lucky, 1, false);
            break;
        case 500:
            instance_destroy(_actor);
            return;
    }

    if ((_age >= 20 && _age < 100) || (_age >= 140 && _age < 170) || _age >= 400) {
        if (_age >= 400) {
            _actor.y -= 10;
        } else {
            _actor.x -= _age < 100 ? 15 : 7;
        }
    }
    if (_actor.sprite_index == spr_solgryn_late_cameos_ryu_car_pose) {
        var _end = ceil(sprite_get_number(spr_solgryn_late_cameos_ryu_car_pose) / 0.4);
        if (_age == 190 + _end) {
            solgryn_cameo_pose(_actor, spr_solgryn_late_cameos_ryu_idle);
        }
    }
    // G1234–G1237 copy the current Ryu pose after his movement.
    solgryn_cameo_afterimage(_actor, _actor.sprite_index, 0.05, 255 / 25);
}

function solgryn_cameo_car(_actor) {
    static _pieces = [
        spr_solgryn_late_cameos_car_debris_0, spr_solgryn_late_cameos_car_debris_1,
        spr_solgryn_late_cameos_car_debris_2, spr_solgryn_late_cameos_car_debris_3,
        spr_solgryn_late_cameos_car_debris_4
    ];
    // Fusion dispatches G1214 on contact before G1213 applies the pending position.
    var _hit_backdrop = _actor.guest_on_backdrop();
    if (_hit_backdrop && !_actor.guest_hit_backdrop) {
        _actor.image_index = min(_actor.image_number - 1, _actor.image_index + 1);
        _actor.guest_vsp *= -0.9;
        repeat (6) {
            var _debris = solgryn_cameo_spawn(SolgrynGuest.CarDebris, _pieces[irandom(4)],
                _actor.x, _actor.y, true);
            _debris.guest_next_x = _debris.x;
            _debris.guest_next_y = _debris.y;
            _debris.guest_hsp = irandom(3) - irandom(3);
            _debris.guest_vsp = -10 - irandom(3);
        }
        audio_play_sound(snd_ryu_car_crash, 1, false);
        solgryn_shake(5);
    }
    _actor.guest_hit_backdrop = _hit_backdrop;
    _actor.x = floor(_actor.guest_next_x);
    _actor.y = floor(_actor.guest_next_y);
    _actor.guest_next_x += _actor.guest_hsp;
    _actor.guest_next_y += _actor.guest_vsp;
    _actor.guest_vsp += 0.3;
    _actor.image_angle -= 2;
    if (_actor.bbox_right < -160 || _actor.bbox_top > 3000) {
        instance_destroy(_actor);
    }
}

function solgryn_cameo_car_debris(_actor, _age) {
    // G1216 faces the move from the previous integer position to the pending fractional position.
    var _previous_x = _age == 1 ? 0 : _actor.x;
    var _previous_y = _age == 1 ? 0 : _actor.y;
    _actor.image_angle = darctan2(_actor.guest_next_x - _previous_x, _actor.guest_next_y - _previous_y) - 90;
    _actor.x = floor(_actor.guest_next_x);
    _actor.y = floor(_actor.guest_next_y);
    _actor.guest_next_x += _actor.guest_hsp;
    _actor.guest_next_y += _actor.guest_vsp;
    _actor.guest_vsp += 0.3;
    if (_actor.bbox_top > 3000 || _actor.bbox_right < -160 || _actor.bbox_left > 800) {
        instance_destroy(_actor);
    }
}

function solgryn_cameo_kitty(_actor) {
    var _age = _actor.guest_age;
    _actor.y += _age <= 50 ? 9 : 5;
    if (_age == 56) {
        var _laser = solgryn_cameo_spawn(SolgrynGuest.KittyLaser, spr_solgryn_late_cameos_kitty_laser_thin,
            307, _actor.y, true);
        _laser.guest_blend = bm_add;
        _laser.guest_hold_image = true;
    }
    solgryn_cameo_afterimage(_actor, _actor.sprite_index, 0.05, 255 / 25);
    if (_actor.bbox_top >= 3040) {
        instance_destroy(_actor);
    }
}

function solgryn_cameo_kitty_laser(_actor) {
    var _age = _actor.guest_age;
    // Animation 3 is the long warning, followed by the flashing Stopped beam.
    if (_age <= 50) {
        var _frame = floor(_age * 0.8);
        _actor.image_index = _frame < 10 ? _frame : 5 + (_frame - 5) mod 5;
    } else if (_age <= 60) {
        if (_age == 51) {
            solgryn_cameo_pose(_actor, spr_solgryn_late_cameos_kitty_laser);
            _actor.depth = layer_get_depth("Player") - 1;
            audio_play_sound(snd_hello_kitty_laser, 1, false, 0.4);
        }
        _actor.image_index = (_age - 51) mod _actor.image_number;
        solgryn_shake(10);
        solgryn_blur(2.5);
    } else {
        // Fusion discards collision when an active begins its Disappearing animation.
        var _decay = solgryn_cameo_spawn(SolgrynGuest.Fade, spr_solgryn_late_cameos_kitty_laser_end,
            _actor.x, _actor.y, false);
        _decay.guest_blend = bm_add;
        _decay.guest_life = _decay.image_number + 1;
        _decay.guest_fade_from = _decay.guest_life;
        instance_destroy(_actor);
    }
}

function solgryn_cameo_small_mario(_actor) {
    var _age = _actor.guest_age;
    switch (_age) {
        case 130:
            var _warning = solgryn_cameo_spawn(SolgrynGuest.Fade, spr_solgryn_late_cameos_mario_warning,
                605, 2771, false);
            _warning.image_angle = 90;
            break;
        case 150:
            var _giant = solgryn_cameo_spawn(SolgrynGuest.GiantMario, spr_solgryn_late_cameos_giant_mario,
                825, 2781, true);
            _giant.image_xscale = 3;
            _giant.image_yscale = 3;
            audio_play_sound(snd_solgryn_late_cameos_giant_mario, 1, false);
            break;
        case 250:
            solgryn_cameo_pose(_actor, spr_solgryn_late_cameos_mario_run);
            solgryn_cameo_spawn(SolgrynGuest.LiuKang, spr_solgryn_late_cameos_liu_kang, 501, 2328, true);
            audio_play_sound(snd_solgryn_late_cameos_mario_dash, 1, false);
            break;
    }
    if (_age >= 250) {
        _actor.x += 2 - (_age - 250) * 0.5;
        _actor.y += 1;
        _actor.image_angle = 2;
        _actor.guest_streak = (_age - 250) * 0.15;
        if (_actor.bbox_right < -100) {
            instance_destroy(_actor);
        }
    } else {
        var _old_y = _actor.y;
        _actor.x += 2;
        _actor.y += _actor.guest_vsp;
        _actor.image_angle = _actor.guest_vsp * 2;
        _actor.guest_vsp += 0.4;
        if (_actor.x >= 32 && _actor.x <= 600 && _actor.guest_vsp > 0 && _actor.guest_on_backdrop()) {
            _actor.y = _old_y;
            _actor.guest_vsp = -9;
            solgryn_shake(10);
            solgryn_blur(2);
            audio_play_sound(snd_mario_lucky, 1, false);
        }
    }
}

function solgryn_cameo_giant_mario(_actor, _player) {
    var _age = _actor.guest_age;
    if (_age <= 36) {
        _actor.x = floor(_actor.x + _actor.guest_hsp);
        _actor.guest_hsp -= 0.8;
        if (_player != noone) {
            _actor.y = _player.y - 25;
        }
    }
    if (_age == 36) {
        _actor.guest_hsp = -2;
    }
    if (_age >= 36 && _age <= 90) {
        _actor.x = floor(_actor.x + _actor.guest_hsp);
        _actor.guest_hsp += 1;
    }
    _actor.guest_streak = abs(_actor.guest_hsp) * 0.5;
    if (_age > 90 && _actor.bbox_left > 700) {
        instance_destroy(_actor);
    }
}

function solgryn_cameo_liu_kang(_actor) {
    var _age = _actor.guest_age;
    if (_age == 50) {
        var _attacker = solgryn_cameo_spawn(SolgrynGuest.LiuKangAttacker,
            spr_solgryn_late_cameos_liu_kang_attacker, -84, 2830, true);
        _attacker.guest_age = -1;
        _actor.guest_attacker = _attacker;
        audio_play_sound(snd_shang_tsung_flying_kick, 1, false);
    }
    if (_age >= 95 && _age <= 170) {
        _actor.y = floor(_actor.y + _actor.guest_vsp);
        _actor.guest_vsp += 0.3;
    }
    if (_age >= 170) {
        _actor.y = floor(_actor.y + _actor.guest_vsp);
        _actor.guest_vsp -= 2;
    }
    if (_age == 150) {
        if (instance_exists(_actor.guest_attacker)) {
            instance_destroy(_actor.guest_attacker);
        }
        var _burst = solgryn_cameo_spawn(SolgrynGuest.Fade, spr_shang_tsung_actor_blood_burst,
            _actor.x - 32, _actor.y - 64, false);
        _burst.guest_life = 40;
        _burst.guest_fade_from = 24;
        for (var _index = 0; _index < 40; ++_index) {
            var _blood = solgryn_cameo_spawn(SolgrynGuest.Blood, spr_solgryn_late_cameos_blood,
                _actor.x - 32, _actor.y - 64, true);
            _blood.guest_blood_x = _blood.x;
            _blood.guest_blood_y = _blood.y;
            _blood.guest_hsp = (_index - 20) * 0.5;
            _blood.guest_vsp = -5 - irandom(4) - irandom(99) * 0.1;
            _blood.guest_gravity = 0.3;
        }
        solgryn_cameo_pose(_actor, spr_solgryn_late_cameos_liu_kang_hit);
        _actor.guest_vsp = 1;
        audio_play_sound(snd_shang_tsung_blood_explode, 1, false);
        solgryn_shake(15);
        solgryn_blur(2.5);
    }
    if (_age == 220) {
        solgryn_cameo_spawn(SolgrynGuest.MissingNo, spr_solgryn_late_cameos_missingno, 524, 2350, true);
        instance_destroy(_actor);
    }
}

function solgryn_cameo_missingno(_actor, _player) {
    var _age = _actor.guest_age;
    var _elapsed = scene_steps * 20;
    if (_elapsed div 50 != (_elapsed - 20) div 50 && _age > 1) {
        solgryn_cameo_afterimage(_actor, spr_solgryn_late_cameos_missingno_trail, 0.1, 128 / 15);
    }
    if (_age >= 10 && _age <= 35) {
        _actor.y += 8;
        _actor.image_xscale = 3;
        _actor.image_yscale = 3;
    }
    if (_age >= 35 && _age <= 210) {
        _actor.y = floor(2550 + dsin(-scene_steps * 20 / 3) * 15);
    }
    if (_age >= 210) {
        _actor.y -= 10;
    }
    switch (_age) {
        case 10:
            var _caption = solgryn_cameo_spawn(SolgrynGuest.Fade,
                spr_solgryn_late_cameos_hydro_pump_caption, 312, 2627, false);
            _caption.guest_life = 340;
            _caption.guest_fade_from = _caption.guest_life;
            _caption.guest_hold_image = true;
            _caption.image_alpha = 0;
            _actor.guest_caption = _caption;
            break;
        case 100:
            audio_play_sound(snd_missingno_hydro_pump, 1, false);
            break;
        case 130:
        case 190:
            if (_player != noone) {
                var _spider = solgryn_cameo_spawn(SolgrynGuest.Spider, spr_solgryn_late_cameos_spider,
                    -101, _player.y, true);
                _spider.image_angle = 90;
                audio_play_sound(snd_kid_icarus_spider_scream, 1, false);
            }
            break;
        case 275:
            var _bomberman = solgryn_cameo_spawn(SolgrynGuest.Bomberman,
                spr_solgryn_late_cameos_bomberman, 499, 2380, true);
            _bomberman.image_xscale = 2;
            _bomberman.image_yscale = 2;
            break;
        case 350:
            instance_destroy(_actor);
            return;
    }
    if (instance_exists(_actor.guest_caption)) {
        // G1287 clears the caption's opacity when the previous afterimage reaches age 1.
        if ((_elapsed - 20) div 50 != (_elapsed - 40) div 50) {
            _actor.guest_caption.image_alpha = 0;
        }
        if (_age <= 100) {
            _actor.guest_caption.image_alpha = min(1, _actor.guest_caption.image_alpha + 25 / 255);
        } else if (_age >= 210) {
            _actor.guest_caption.image_alpha = max(0, _actor.guest_caption.image_alpha - 25 / 255);
        }
    }
    if (_age >= 100 && _age <= 210 && (_age - 100) mod 30 == 0 && _player != noone) {
        var _water = solgryn_cameo_spawn(SolgrynGuest.HydroPump,
            spr_solgryn_late_cameos_hydro_pump, _player.x, 2888, false);
        _water.guest_vsp = -20;
        _water.image_xscale = 4;
        _water.image_yscale = 3;
        _water.guest_blend = bm_add;
    }
}

function solgryn_cameo_bomberman(_actor) {
    var _age = _actor.guest_age;
    var _old_y = _actor.y;
    _actor.y += _actor.guest_vsp;
    _actor.guest_vsp += 0.5;
    if (_age >= 290) {
        _actor.y += _actor.guest_vsp;
        _actor.guest_vsp -= 0.5;
    } else if (_actor.guest_vsp > 0 && _actor.guest_on_backdrop()) {
        _actor.y = _old_y;
        _actor.guest_vsp = -5;
    }
    switch (_age) {
        case 35:
        case 80:
        case 150:
        case 200:
        case 245:
            var _bomb = solgryn_cameo_spawn(SolgrynGuest.Bomb,
                spr_solgryn_late_cameos_bomb, _actor.x, _actor.y, true);
            _bomb.guest_hsp = _age == 35 ? -2 : ((_age == 80 || _age == 200) ? -6 : -4);
            _bomb.guest_vsp = _age == 35 ? -9 : ((_age == 80 || _age == 200) ? -11 : -10);
            break;
        case 430:
            var _sonic = solgryn_cameo_spawn(SolgrynGuest.Sonic, spr_solgryn_late_cameos_sonic,
                584, 2343, true);
            _sonic.guest_age = -250;
            _sonic.image_xscale = 2;
            _sonic.image_yscale = 2;
            audio_play_sound(snd_solgryn_late_cameos_sonic, 1, false);
            break;
        case 500:
            instance_destroy(_actor);
            break;
    }
}

function solgryn_cameo_bomb(_actor) {
    _actor.x += _actor.guest_hsp;
    _actor.y += _actor.guest_vsp;
    _actor.guest_vsp += 0.5;
    if (_actor.guest_on_backdrop() && _actor.y > 400) {
        if (_actor.guest_kind == SolgrynGuest.Bomb) {
            for (var _side = -1; _side <= 1; _side += 2) {
                var _bomb = solgryn_cameo_spawn(SolgrynGuest.SecondBomb,
                    spr_solgryn_late_cameos_bomb, _actor.x, _actor.y - 32, true);
                _bomb.guest_hsp = _side * 2;
                _bomb.guest_vsp = -10;
            }
            solgryn_shake(15);
            solgryn_blur(2);
        }
        var _blast = solgryn_cameo_spawn(SolgrynGuest.Fade, spr_solgryn_late_cameos_bomb_blast,
            _actor.x, _actor.y, true);
        _blast.guest_life = ceil(_blast.image_number * 50 / sprite_get_speed(_blast.sprite_index)) + 1;
        _blast.guest_fade_from = _blast.guest_life;
        instance_destroy(_actor);
    } else if (_actor.bbox_top > 3000 || _actor.bbox_right < -100) {
        instance_destroy(_actor);
    }
}

function solgryn_cameo_sonic(_actor, _player) {
    var _age = _actor.guest_age;
    if (_player != noone && _age <= 250) {
        _actor.guest_hsp += sign(_player.x - _actor.x);
        _actor.guest_vsp += sign(_player.y - _actor.y);
    }
    var _old_x = _actor.x;
    var _old_y = _actor.y;
    _actor.x = floor(_actor.x + _actor.guest_hsp * 0.5);
    _actor.y = floor(_actor.y + _actor.guest_vsp * 0.5);
    if (_age < 250) {
        _actor.guest_hsp = clamp(_actor.guest_hsp, -30, 30);
        _actor.guest_vsp = clamp(_actor.guest_vsp, -30, 30);
    }
    if (_actor.x != _old_x || _actor.y != _old_y) {
        _actor.image_angle = point_direction(_old_x, _old_y, _actor.x, _actor.y);
    }
    if (_age >= 200) {
        _actor.guest_vsp -= 1;
        if (_age == 200) {
            _actor.depth = layer_get_depth("Player") - 1;
        }
    }
    if ((_actor.x < 0 && _actor.guest_hsp < 0) || (_actor.x > 640 && _actor.guest_hsp > 0)) {
        _actor.guest_hsp = 0;
    }
    if (_actor.y > 2880 && _actor.guest_vsp > 0) {
        _actor.guest_vsp = 0;
    }
    if ((_age + 250) mod 2 == 0 && _age > -250) {
        var _spark = solgryn_cameo_spawn(SolgrynGuest.Fade, spr_solgryn_late_cameos_sonic_spark,
            _actor.x, _actor.y, false);
        _spark.guest_life = 12;
        _spark.guest_fade_from = 3;
        _spark.guest_hold_image = true;
        _spark.image_index = irandom(3);
        var _heading = irandom(359);
        var _speed = 4 + (irandom(3) - irandom(3)) * 0.8;
        _spark.guest_hsp = lengthdir_x(_speed, _heading);
        _spark.guest_vsp = lengthdir_y(_speed, _heading);
    }
    var _trail = solgryn_cameo_spawn(SolgrynGuest.Fade, spr_solgryn_late_cameos_sonic_trail,
        _actor.x, _actor.y, false);
    _trail.image_angle = _actor.image_angle;
    _trail.guest_life = 12;
    _trail.guest_fade_from = 12;
    if (_age >= 250 && _actor.bbox_bottom < 2280) {
        instance_destroy(_actor);
    }
}

function solgryn_late_cameos_step(_player, _fight_age) {
    // Guests count their own lifetimes after the shield breaks at G836.
    if (_fight_age == 8100 || _fight_age == 8140) {
        var _warning = solgryn_cameo_spawn(SolgrynGuest.Fade, spr_solgryn_late_cameos_ryu_warning,
            x, y - 200, false);
        _warning.guest_fade_from = 14;
        _warning.guest_fade_end = 14 + 255 / 25;
    } else if (_fight_age == 8210) {
        solgryn_cameo_spawn(SolgrynGuest.Ryu, spr_solgryn_late_cameos_ryu_idle, 730, 2812, true);
    }

    var _hydro_contact = false;
    for (var _index = 0; _index < array_length(cameo_actors); ++_index) {
        var _actor = cameo_actors[_index];
        if (!instance_exists(_actor)) {
            array_delete(cameo_actors, _index, 1);
            --_index;
            continue;
        }
        var _age = ++_actor.guest_age;
        switch (_actor.guest_kind) {
            case SolgrynGuest.Ryu:
                solgryn_cameo_ryu(_actor);
                break;
            case SolgrynGuest.Hadoken:
                if (_age > 0) {
                    if (_actor.guest_on_backdrop() || _actor.bbox_top > 3000) {
                        instance_destroy(_actor);
                    } else {
                        _actor.y += _actor.guest_vsp;
                    }
                }
                break;
            case SolgrynGuest.Car:
                if (_age > 0) {
                    solgryn_cameo_car(_actor);
                }
                break;
            case SolgrynGuest.CarDebris:
                solgryn_cameo_car_debris(_actor, _age);
                break;
            case SolgrynGuest.Blood:
                // G1284 measures the fractional position from the previous integer hotspot.
                var _blood_previous_x = _age == 1 ? 0 : _actor.x;
                var _blood_previous_y = _age == 1 ? 0 : _actor.y;
                _actor.image_angle = darctan2(_actor.guest_blood_x - _blood_previous_x,
                    _actor.guest_blood_y - _blood_previous_y) - 90;
                _actor.x = floor(_actor.guest_blood_x);
                _actor.y = floor(_actor.guest_blood_y);
                _actor.guest_blood_x += _actor.guest_hsp;
                _actor.guest_blood_y += _actor.guest_vsp;
                _actor.guest_vsp += _actor.guest_gravity;
                if (_actor.bbox_top > 3000 || _actor.bbox_right < -160 || _actor.bbox_left > 800) {
                    instance_destroy(_actor);
                }
                break;
            case SolgrynGuest.Kitty:
                solgryn_cameo_kitty(_actor);
                break;
            case SolgrynGuest.KittyLaser:
                solgryn_cameo_kitty_laser(_actor);
                break;
            case SolgrynGuest.SmallMario:
                solgryn_cameo_small_mario(_actor);
                break;
            case SolgrynGuest.GiantMario:
                solgryn_cameo_giant_mario(_actor, _player);
                break;
            case SolgrynGuest.LiuKang:
                solgryn_cameo_liu_kang(_actor);
                break;
            case SolgrynGuest.LiuKangAttacker:
                // G1275 applies the previous displacement before sampling this step's angle.
                if (_age > 0) {
                    _actor.x += _actor.guest_hsp;
                    _actor.y += _actor.guest_vsp;
                    _actor.guest_hsp = dcos(_actor.image_angle) * 5;
                    _actor.guest_vsp = -dsin(_actor.image_angle) * 5;
                    _actor.image_angle = dsin((_age - 1) * 5) * 30;
                }
                break;
            case SolgrynGuest.MissingNo:
                solgryn_cameo_missingno(_actor, _player);
                break;
            case SolgrynGuest.HydroPump:
                _actor.y = floor(_actor.y + _actor.guest_vsp);
                _actor.guest_vsp += 0.5;
                if (_actor.guest_vsp >= 30) {
                    instance_destroy(_actor);
                }
                break;
            case SolgrynGuest.Spider:
                _actor.x += 10;
                if (_age >= 100) {
                    instance_destroy(_actor);
                }
                break;
            case SolgrynGuest.Bomberman:
                solgryn_cameo_bomberman(_actor);
                break;
            case SolgrynGuest.Bomb:
            case SolgrynGuest.SecondBomb:
                solgryn_cameo_bomb(_actor);
                break;
            case SolgrynGuest.Sonic:
                solgryn_cameo_sonic(_actor, _player);
                if (_age == 230) {
                    _fight_age = 15000;
                }
                break;
            case SolgrynGuest.Fade:
                if (_age >= _actor.guest_life) {
                    instance_destroy(_actor);
                } else {
                    if (_actor.sprite_index != spr_solgryn_late_cameos_hydro_pump_caption) {
                        _actor.image_alpha = 1 - clamp((_age - _actor.guest_fade_from)
                            / max(1, _actor.guest_fade_end - _actor.guest_fade_from), 0, 1);
                    }
                    _actor.image_xscale += _actor.guest_grow;
                    _actor.image_yscale += _actor.guest_grow;
                    _actor.x += _actor.guest_hsp;
                    _actor.y += _actor.guest_vsp;
                    _actor.guest_hsp *= 0.9;
                    _actor.guest_vsp *= 0.9;
                }
                break;
        }
        if (!instance_exists(_actor)) {
            continue;
        }
        if (!_actor.guest_hold_image) {
            var _frame = floor(_actor.guest_animation);
            if (_actor.sprite_index == spr_solgryn_late_cameos_mario_run) {
                _actor.guest_animation += 0.5;
            } else {
                _actor.guest_animation += sprite_get_speed(_actor.sprite_index) / 50;
            }
            var _one_shot = _actor.sprite_index == spr_solgryn_late_cameos_ryu_car_pose
                || _actor.sprite_index == spr_solgryn_late_cameos_giant_mario
                || _actor.sprite_index == spr_shang_tsung_actor_blood_burst;
            _actor.image_index = _one_shot ? min(_frame, _actor.image_number - 1) : _frame mod _actor.image_number;
        }
        if (_actor.guest_kind == SolgrynGuest.HydroPump && !_hydro_contact && _player != noone) {
            _hydro_contact = _player.boshy_mask_meeting(_actor);
        }
    }
    // G1302 selects the player once, even when several water columns overlap.
    if (_hydro_contact) {
        --_player.vsp;
    }
    return _fight_age;
}
