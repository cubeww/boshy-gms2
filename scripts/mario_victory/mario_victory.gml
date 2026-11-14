function mario_victory_setup() {
    mario_victory_actor = noone;
    mario_victory_complete = false;
    mario_dance_age = 0;
    mario_dance_encore = false;
    mario_dance_facing = 1;
    mario_dance_hsp = 0;
    mario_dance_vsp = 0;
    mario_final_vsp = 0;
    mario_dance_scale = 2;
    mario_dance_hit_cooldown = 0;
    mario_dance_guest_delay = 25;
    mario_dance_quote_delay = 0;
    mario_dance_guests = [];
    mario_dance_quotes = [];
    mario_dance_seeds = [];
    mario_dance_fire = [];
}

function mario_victory_spawn_guest() {
    // Fusion groups 1006–1012 spawn one of five guests at the right edge.
    var _sprites = [spr_mario_goomba, spr_mario_hammer, spr_mario_plant, spr_mario_koopa, spr_mario_bowser];
    var _positions = [[633, 395], [629, 403], [627, 410], [631, 410], [625, 411]];
    var _choice = irandom(array_length(_sprites) - 1);
    var _position = _positions[_choice];
    var _guest = instance_create_depth(_position[0], _position[1], depth - 1, obj_hazard, {
        sprite_index: _sprites[_choice], vsp: 0, rebound_direction: -1
    });
    array_push(mario_dance_guests, _guest);
}

function mario_victory_step_guests() {
    for (var _index = array_length(mario_dance_guests) - 1; _index >= 0; --_index) {
        var _guest = mario_dance_guests[_index];
        if (instance_exists(_guest)) {
            _guest.y = floor(_guest.y + _guest.vsp);
            _guest.vsp += 0.2;
            _guest.x -= 2;
            _guest.image_angle = dsin(scene_steps * 4) * 30;
            if (_guest.y > 430 && _guest.vsp > 0) {
                _guest.vsp = -5 - irandom(2);
                _guest.rebound_direction = -_guest.rebound_direction;
            }
            _guest.x += _guest.rebound_direction * (1 + irandom(3));
            if (_guest.bbox_right < -480 || _guest.bbox_left > room_width + 480) {
                instance_destroy(_guest);
            }
        }
        if (!instance_exists(_guest)) {
            array_delete(mario_dance_guests, _index, 1);
        }
    }
}

function mario_victory_spawn_quote() {
    var _facing = choose(-1, 1);
    array_push(mario_dance_quotes, {
        x: _facing < 0 ? 665 : -31,
        y: _facing < 0 ? 265 : 257,
        hsp: _facing * (3 + irandom(5)),
        vsp: 1 + irandom(5),
        age: 0, has_dropped: false, facing: _facing
    });
    audio_play_sound(snd_mario_quote_jump, 1, false);
}

function mario_victory_spawn_fire(_x, _direction, _sprite) {
    var _fire = instance_create_depth(_x, 432, depth - 3, obj_mario_victory_fire, {
        sprite_index: _sprite, fire_direction: _direction, fire_age: 0, image_speed: 0, visible: false
    });
    array_push(mario_dance_fire, _fire);
}

function mario_victory_step_fire() {
    for (var _index = array_length(mario_dance_quotes) - 1; _index >= 0; --_index) {
        var _quote = mario_dance_quotes[_index];
        _quote.vsp -= 0.25;
        _quote.x += _quote.hsp;
        _quote.y = floor(_quote.y + _quote.vsp);
        ++_quote.age;
        if (!_quote.has_dropped && _quote.age >= 25 + irandom(19)) {
            array_push(mario_dance_seeds, { x: _quote.x, y: _quote.y, vsp: 0 });
            _quote.has_dropped = true;
        }
        if (_quote.y < -50) {
            array_delete(mario_dance_quotes, _index, 1);
        }
    }
    for (var _index = array_length(mario_dance_seeds) - 1; _index >= 0; --_index) {
        var _seed = mario_dance_seeds[_index];
        var _seed_left = _seed.x - sprite_get_xoffset(spr_mario_victory_fire_seed);
        var _seed_top = _seed.y - sprite_get_yoffset(spr_mario_victory_fire_seed);
        var _seed_right = _seed_left + sprite_get_width(spr_mario_victory_fire_seed) - 1;
        var _seed_bottom = _seed_top + sprite_get_height(spr_mario_victory_fire_seed) - 1;
        if (instance_exists(arena_floor) && collision_rectangle(_seed_left, _seed_top, _seed_right,
            _seed_bottom, arena_floor, false, true) != noone) {
            mario_victory_spawn_fire(_seed.x, -1, spr_mario_victory_fire_front);
            mario_victory_spawn_fire(_seed.x, 1, spr_mario_victory_fire_front);
            array_delete(mario_dance_seeds, _index, 1);
        } else if (_seed_top >= room_height + 300) {
            array_delete(mario_dance_seeds, _index, 1);
        } else {
            _seed.y = floor(_seed.y + _seed.vsp);
            _seed.vsp += 0.25;
        }
    }
    // Fusion updates and propagates Active 8 before processing Active 9.
    mario_victory_step_fire_type(spr_mario_victory_fire_front, spr_mario_victory_fire_trail);
    mario_victory_step_fire_type(spr_mario_victory_fire_trail, spr_mario_victory_fire_front);
}

function mario_victory_step_fire_type(_sprite, _next_sprite) {
    // Active 8 ages before its expiry check. Active 9 checks expiry first.
    var _last_age = _sprite == spr_mario_victory_fire_front ? 24 : 25;
    for (var _index = array_length(mario_dance_fire) - 1; _index >= 0; --_index) {
        var _fire = mario_dance_fire[_index];
        if (!instance_exists(_fire)) {
            array_delete(mario_dance_fire, _index, 1);
            continue;
        }
        if (_fire.sprite_index != _sprite) {
            continue;
        }
        if (_fire.fire_age >= _last_age || _fire.bbox_right < 0 || _fire.bbox_left >= room_width) {
            instance_destroy(_fire);
            array_delete(mario_dance_fire, _index, 1);
            continue;
        }
        if (_fire.fire_age == 0) {
            mario_victory_spawn_fire(_fire.x + 4 * _fire.fire_direction, _fire.fire_direction, _next_sprite);
        }
        ++_fire.fire_age;
        var _scale = max(0, 1 + dsin(330 + _fire.fire_age * 10) * 1.2);
        _fire.image_xscale = _scale;
        _fire.image_yscale = _scale;
        _fire.image_index = min((_fire.fire_age - 1) div 4, _fire.image_number - 1);
        _fire.visible = true;
    }
}

function mario_victory_set_pose(_sprite) {
    if (mario_victory_actor.sprite_index != _sprite) {
        mario_victory_actor.sprite_index = _sprite;
        mario_victory_actor.image_index = 0;
    }
}

function mario_victory_step() {
    if (victory_age < 150) {
        return;
    }
    if (victory_age == 150) {
        mario_victory_actor = instance_create_depth(665, 400, depth, obj_hazard, {
            sprite_index: spr_mario_idle,
            image_xscale: mario_dance_scale,
            image_yscale: mario_dance_scale,
            image_speed: 0
        });
        game_controller.start_stage_music(snd_mario_dance_music, false, false);
    }
    if (mario_victory_complete || !instance_exists(mario_victory_actor)) {
        mario_victory_step_guests();
        mario_victory_step_fire();
        return;
    }
    var _actor = mario_victory_actor;
    var _age = ++mario_dance_age;
    if (_actor.sprite_index == spr_mario_run || _actor.sprite_index == spr_mario_run_left) {
        _actor.image_index = (_actor.image_index + 0.26) mod _actor.image_number;
    }
    // The opening walk and small hops only run before the lyric clock resets.
    if (!mario_dance_encore && ((_age >= 2 && _age <= 29) || (_age >= 61 && _age <= 89))) {
        _actor.x -= 6;
        mario_dance_facing = -1;
        mario_victory_set_pose(spr_mario_run_left);
    } else if (!mario_dance_encore && ((_age >= 36 && _age <= 39) || (_age >= 41 && _age <= 44)
        || (_age >= 101 && _age <= 104) || (_age >= 111 && _age <= 114))) {
        _actor.y += (_age >= 41 && _age <= 44) || (_age >= 111 && _age <= 114) ? 4 : -4;
        _actor.x -= 4;
        mario_victory_set_pose(spr_mario_jump_left);
    }
    if (_age == 130) {
        mario_dance_scale = 3;
        mario_victory_set_pose(spr_mario_transition);
        mario_dance_hsp = mario_dance_encore ? 3 : -3;
        mario_dance_vsp = -5;
    }
    if (!mario_dance_encore && _age == 950) {
        mario_dance_encore = true;
        mario_dance_age = 0;
        _age = 0;
    }
    if (_age <= 1100 && (_actor.y < 400 || mario_dance_vsp < 0)) {
        _actor.x = floor(_actor.x + mario_dance_hsp);
        _actor.y = floor(_actor.y + mario_dance_vsp);
        mario_dance_vsp += 0.3;
    }
    if (_age <= 1100 && _actor.y >= 400) {
        _actor.y -= 1;
        mario_dance_vsp = 0;
        mario_dance_hsp = 0;
    }
    if (_age >= 190 && _age <= 1000) {
        _actor.image_angle = dsin((scene_steps * 20) div 7) * 25;
        _actor.x = floor(320 + dsin(_age + 25) * 320);
    }
    // Groups 995–1012 keep the same countdown when the dance clock resets.
    var _throwing_guests = mario_dance_encore ? _age < 800 : _age >= 680;
    if (_throwing_guests) {
        if (mario_dance_guest_delay == 0) {
            mario_victory_spawn_guest();
            mario_dance_guest_delay = 25;
        }
        --mario_dance_guest_delay;
    }
    if (mario_dance_encore) {
        switch (_age) {
            case 1000:
                audio_play_sound(snd_mario_dance_encore, 1, false);
                break;
            case 1150:
                _actor.x = 88;
                _actor.y = 398;
                _actor.image_angle = 0;
                mario_dance_facing = 1;
                mario_victory_set_pose(spr_mario_idle);
                game_controller.start_stage_music(snd_mario_celebration_music, true, false);
                break;
        }
        if (_age >= 1150 && _age <= 1165) {
            mario_dance_scale += 0.25;
            _actor.y -= 11;
        }
        if (_age >= 1200 && _age <= 1400 && --mario_dance_quote_delay <= 0) {
            mario_victory_spawn_quote();
            mario_dance_quote_delay = 80;
        }
        if (_age >= 1550) {
            if (mario_dance_scale < 0.5) {
                if (game_controller.stage_music_instance != -1) {
                    audio_stop_sound(game_controller.stage_music_instance);
                    game_controller.stage_music_instance = -1;
                }
                audio_play_sound(snd_mario_thank_you, 1, false);
                mario_victory_blood(_actor.x, _actor.y);
                instance_destroy(_actor);
                mario_victory_complete = true;
                mario_victory_step_guests();
                mario_victory_step_fire();
                return;
            }
            // Groups 1020–1025 use a separate velocity for the final floor rebounds.
            _actor.y = floor(_actor.y + mario_final_vsp);
            mario_final_vsp += 0.5;
            _actor.x = floor(_actor.x + mario_dance_facing * abs(18 - mario_dance_scale * 2) / 2);
            mario_victory_set_pose(mario_dance_facing < 0 ? spr_mario_jump_left : spr_mario_jump);
            if (_actor.x > room_width) {
                mario_dance_facing = -1;
            } else if (_actor.x < 0) {
                mario_dance_facing = 1;
            }
            var _floor = arena_floor;
            var _touching_floor = false;
            with (_actor) {
                _touching_floor = instance_exists(_floor) && place_meeting(x, y, _floor);
            }
            if (_touching_floor) {
                mario_final_vsp = -9;
            }
            // Hold the final jump loop while the player shrinks Mario with shots.
            if (_age >= 1600) {
                mario_dance_age = 1575;
            }
        }
    }
    _actor.image_xscale = mario_dance_scale;
    _actor.image_yscale = mario_dance_scale;
    mario_dance_hit_cooldown = max(0, mario_dance_hit_cooldown - 1);
    _actor.visible = mario_dance_hit_cooldown <= 26
        || (mario_dance_hit_cooldown <= 45 && ((45 - mario_dance_hit_cooldown) div 3) mod 2 == 0);
    mario_victory_step_guests();
    mario_victory_step_fire();
}

function mario_victory_blood(_x, _y) {
    repeat (floor(71 * global.settings.blood_intensity / 100)) {
        instance_create_depth(_x, _y, depth - 2, obj_blood);
    }
}

function mario_victory_take_shot(_bullet) {
    if (mario_dance_encore && mario_dance_age >= 1550 && mario_dance_hit_cooldown == 0
        && instance_exists(mario_victory_actor)) {
        var _actor = mario_victory_actor;
        var _hit = false;
        with (_bullet) {
            _hit = place_meeting(x, y, _actor);
        }
        if (_hit) {
            var _reactions = [snd_mario_lift, snd_mario_ooh, snd_mario_waha, snd_mario_wahoo, snd_mario_crazy];
            mario_dance_scale -= 0.75;
            _actor.image_xscale = mario_dance_scale;
            _actor.image_yscale = mario_dance_scale;
            _actor.visible = false;
            mario_dance_hit_cooldown = 50;
            audio_play_sound(snd_mario_bump, 1, false);
            audio_play_sound(_reactions[irandom(array_length(_reactions) - 1)], 1, false);
            return true;
        }
    }
    for (var _index = array_length(mario_dance_guests) - 1; _index >= 0; --_index) {
        var _guest = mario_dance_guests[_index];
        if (!instance_exists(_guest)) {
            continue;
        }
        var _hit = false;
        with (_bullet) {
            _hit = place_meeting(x, y, _guest);
        }
        if (_hit) {
            mario_victory_blood(_guest.x, _guest.y);
            audio_play_sound(snd_mario_guest_defeat, 1, false);
            instance_destroy(_guest);
            return true;
        }
    }
    return false;
}

function mario_victory_draw() {
    for (var _index = 0; _index < array_length(mario_dance_quotes); ++_index) {
        var _quote = mario_dance_quotes[_index];
        var _sprite = _quote.facing < 0 ? spr_mario_victory_quote_left : spr_mario_victory_quote;
        var _frame = (_quote.age - 1) div 4;
        if (_frame >= sprite_get_number(_sprite)) {
            _frame = 2 + (_frame - 2) mod 2;
        }
        draw_sprite(_sprite, _frame, _quote.x, _quote.y);
    }
    for (var _index = 0; _index < array_length(mario_dance_seeds); ++_index) {
        var _seed = mario_dance_seeds[_index];
        draw_sprite(spr_mario_victory_fire_seed, 0, round(_seed.x), round(_seed.y));
    }
}
