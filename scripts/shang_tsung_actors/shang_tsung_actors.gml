function shang_actor_pose(_actor, _sequence) {
    if (!instance_exists(_actor)) {
        return;
    }

    with (_actor) {
        var _sprite = noone;
        var _rate = 0;
        switch (source_handle) {
            case 14: _sprite = spr_shang_tsung_actor_fight_banner; _rate = 0.55; break;
            case 43: _sprite = spr_shang_tsung_actor_mudkip; break;
            case 120: _sprite = spr_shang_tsung_actor_fire_column; _rate = 0.45; break;
            case 122: _sprite = spr_shang_tsung_actor_fireball; _rate = 0.5; break;
            case 193: _sprite = spr_shang_tsung_actor_flying_kick; _rate = 0.4; break;
            case 195: _sprite = spr_shang_tsung_actor_teleport; _rate = 0.4; break;
            case 80:
                switch (_sequence) {
                    case 1: _sprite = spr_shang_tsung_actor_liu_kang_fall; _rate = 0.2; break;
                    case 8: _sprite = spr_shang_tsung_actor_liu_kang_airborne; break;
                    case 12: _sprite = spr_shang_tsung_actor_liu_kang_caught; _rate = 0.1; break;
                    default: _sprite = spr_shang_tsung_actor_liu_kang_idle; _rate = 0.4; break;
                }
                break;
            case 190:
                switch (_sequence) {
                    case 12: _sprite = spr_shang_tsung_actor_liu_kang_torso; _rate = 0.05; break;
                    case 13: _sprite = spr_shang_tsung_actor_liu_kang_legs; break;
                    default: _sprite = spr_shang_tsung_actor_liu_kang_head; break;
                }
                break;
            case 321: _sprite = spr_shang_tsung_actor_blood_burst; _rate = 0.3; break;
            case 322: _sprite = spr_shang_tsung_actor_blood_shard; break;
            case 336: _sprite = spr_shang_tsung_actor_dash_afterimage; break;
            case 337: _sprite = spr_shang_tsung_actor_shadow_victim; _rate = 0.4; break;
            case 338:
                _sprite = spr_shang_tsung_actor_shadow_ball;
                break;
            case 339: _sprite = spr_shang_tsung_actor_spear; break;
            case 340: _sprite = spr_shang_tsung_actor_spear_link; break;
            case 82: _sprite = spr_shang_tsung_actor_caught_spear; break;
            case 335: _sprite = spr_shang_tsung_actor_toasty; break;
            case 186: _sprite = spr_shang_tsung_actor_impact_poof; _rate = 0.8; break;
        }
        if (sprite_index == _sprite && animation == _sequence) {
            return;
        }
        animation = _sequence;
        sprite_index = _sprite;
        animation_rate = _rate;
        animation_loop = source_handle == 122 || source_handle == 193 || source_handle == 80 || source_handle == 190;
        animation_loop_start = source_handle == 80 && _sequence == 1 ? 6
            : (source_handle == 80 && _sequence == 12 ? 2 : 0);
        animation_frame = source_handle == 336 ? clamp(_sequence, 0, 1) : 0;
        image_index = animation_frame;
        animation_finished = false;
    }
}

function shang_spawn_attack(_handle, _x, _y, _overrides = undefined, _layer = "Gameplay") {
    var _danger = _handle == 43 || _handle == 120 || _handle == 122 || _handle == 193
        || _handle == 190 || _handle == 322 || _handle == 338 || _handle == 339 || _handle == 340
        || _handle == 186;
    var _fields = {
        source_handle: _handle, animation: 0, attack_phase: 0,
        vx: _handle == 322 ? -2 : 0, vy: _handle == 43 ? -13 : (_handle == 322 ? -10 : 0),
        angle: 0, base_angle: 0, flight_speed: 5,
        facing: 1, life: -1, lethal: _danger
    };
    if (!is_undefined(_overrides)) {
        var _names = struct_get_names(_overrides);
        for (var _i = 0; _i < array_length(_names); ++_i) {
            var _name = _names[_i];
            struct_set(_fields, _name, struct_get(_overrides, _name));
        }
    }

    return instance_create_layer(_x, _y, _layer, obj_shang_tsung_actor, _fields);
}

function shang_spawn_intro(_player) {
    shang_spawn_attack(43, instance_exists(_player) ? _player.x : 317, 559);
    shang_spawn_attack(14, 226, 208, undefined, "Foreground Effects");
}

function shang_kill_attacks(_handle) {
    with (obj_shang_tsung_actor) {
        if (source_handle == _handle) {
            instance_destroy();
        }
    }
}

function shang_blood_shards(_x, _y, _count, _lethal = true, _spread = true, _layer = "Gameplay") {
    for (var _i = 0; _i < _count; ++_i) {
        var _vx = _spread ? -2 - irandom(89) * 0.1 : (_count - _i - 20) * 0.5;
        shang_spawn_attack(322, _x, _y, {
            vx: _vx, vy: -5 - irandom(4) - irandom(99) * 0.1, lethal: _lethal
        }, _layer);
    }
}

function shang_actor_animation_step() {
    if (animation_rate == 0 || animation_finished) {
        return;
    }
    animation_frame += animation_rate;
    var _frame = max(0, ceil(animation_frame - 0.000001) - 1);
    var _frames = sprite_get_number(sprite_index);
    if (_frame >= _frames) {
        if (animation_loop) {
            _frame = animation_loop_start + (_frame - _frames) mod (_frames - animation_loop_start);
        } else {
            _frame = _frames - 1;
            animation_finished = true;
        }
    }
    image_index = _frame;
}

function shang_victory_burst_step() {
    // G803 chooses one flagged BloodExplo for its particle emission each step.
    var _bursts = [];
    with (obj_shang_tsung_actor) {
        if (source_handle == 321 && (attack_phase & 4) != 0) {
            array_push(_bursts, id);
        }
    }
    if (array_length(_bursts) > 0) {
        var _burst = _bursts[irandom(array_length(_bursts) - 1)];
        // G803 inherits the foreground emitter's layer, outside the player's G43 collision layer.
        shang_blood_shards(_burst.x, _burst.y, 1, false, true, _burst.layer);
    }
}

function shang_actor_move(_horizontal, _vertical) {
    x = floor(actor_x);
    y = floor(actor_y);
    actor_x += _horizontal;
    actor_y += _vertical;
}

function shang_actor_move_integer(_horizontal, _vertical) {
    // Fusion's direct Set X/Y actions round down the hotspot on every event pass.
    x = floor(x + _horizontal);
    y = floor(y + _vertical);
}

function shang_liu_kang_fall_step() {
    // G753–754 update an airborne Liu Kang before the later summon and capture events.
    if ((attack_phase & 1) == 0) {
        return;
    }
    shang_actor_move_integer(0, vy);
    vy += 0.4;
    if ((attack_phase & 2) == 0) {
        attack_phase |= 2;
        shang_actor_pose(id, 8);
    }
}

function shang_shadow_bounce(_boss) {
    audio_play_sound(snd_shang_tsung_shadow_bounce, 1, false);
    _boss.shake_strength = 15;
    _boss.blur_strength = 2.5;
}

function shang_shadow_ball_step(_boss, _player) {
    var _launched = (attack_phase & 1) != 0;
    if (_player != noone) {
        if (x < -20 && vx < 0) {
            vx = -vx;
            shang_shadow_bounce(_boss);
        }
        if ((y > 960 && vy > 0) || (y < 480 && vy < 0)) {
            vy *= -0.5;
            shang_shadow_bounce(_boss);
        }
    }
    if (!_launched) {
        var _offset;
        with (_boss) {
            _offset = shang_tsung_pose_action_point();
        }
        vx += sign(_boss.x + _offset[0] - x) * 0.5;
        vy += sign(_boss.y + _offset[1] - y) * 0.5;
        shang_actor_move_integer(vx, vy);
    } else if (_player != noone) {
        // G967 moves with the previous velocity. G968–971 steer toward the player afterwards.
        shang_actor_move_integer(vx, vy);
        vx += sign(_player.x - x) * 0.5;
        vy += sign(_player.y - y) * 0.5;
    } else {
        shang_actor_move_integer(vx, vy);
    }
}

function shang_actor_hit_player(_player) {
    if (!instance_exists(_player) || _player.dead) {
        _player = noone;
    }
    with (obj_shang_tsung_actor) {
        // The animation runtime advances before the G43 overlap event.
        shang_actor_animation_step();
        if (_player != noone && lethal && _player.boshy_mask_meeting(id) && _player.die()) {
            _player = noone;
        }
    }
    return _player;
}

function shang_actor_step(_player) {
    var _boss = id;
    var _live_player = instance_exists(_player) && !_player.dead ? _player : noone;

    shang_victory_burst_step();

    with (obj_shang_tsung_actor) {
        if (source_handle == 122 || source_handle == 340) {
            continue;
        }
        ++actor_age;
        switch (source_handle) {
            case 14:
            case 195:
            case 186:
                if (animation_finished) { instance_destroy(); }
                break;

            case 43:
                shang_actor_move_integer(0, vy);
                vy += 0.2;
                image_angle = (image_angle + 5) mod 360;
                break;

            case 120:
                // G925 spawns a rising fireball as the column finishes reaching up.
                if (image_index == 6 && !child_spawned) {
                    child_spawned = true;
                    // Original frame 2943 has action point (+2, -104) from its hotspot.
                    shang_spawn_attack(122, x + 2, y - 120, { lethal: lethal });
                }
                if (animation_finished) { instance_destroy(); }
                break;

            case 193:
                // G945 integrates five pixels along the previous angle. Its gravity input (E) stays at zero.
                shang_actor_move(lengthdir_x(flight_speed, image_angle), lengthdir_y(flight_speed, image_angle));
                image_angle = base_angle + dsin((actor_age - 1) * 5) * 30;
                break;

            case 190:
                shang_actor_move_integer(vx, vy);
                vy += 0.2;
                image_angle = (image_angle + 15) mod 360;
                if (y > 400 && place_meeting(x, y, obj_player_backdrop)) {
                    shang_spawn_attack(186, x, y);
                    instance_destroy();
                }
                break;

            case 321:
                if ((attack_phase & 1) != 0 && image_index < 3) {
                    shang_blood_shards(x, y, 1);
                }
                if (animation_finished) { instance_destroy(); }
                break;

            case 322:
                // G959 measures the accumulator against the previous integer position.
                var _previous_x = actor_age == 1 ? 0 : x;
                var _previous_y = actor_age == 1 ? 0 : y;
                image_angle = darctan2(actor_x - _previous_x, actor_y - _previous_y) - 90;
                shang_actor_move(vx, vy);
                vy += 0.3;
                break;

            case 336:
                image_alpha = max(0, 1 - (40 + actor_age * 5) / 128);
                if (actor_age >= 40) { instance_destroy(); }
                break;

            case 337:
                if ((attack_phase & 1) != 0) {
                    shang_actor_move_integer(0, vy);
                    vy += 0.5;
                }
                if (animation_finished && y > room_height + 160) { instance_destroy(); }
                break;

            case 338:
                shang_shadow_ball_step(_boss, _live_player);
                break;

            case 339:
                // G973 advances along the previous angle. The spear's gravity input stays at zero.
                shang_actor_move(lengthdir_x(flight_speed, image_angle), lengthdir_y(flight_speed, image_angle));
                image_angle = base_angle + dsin((actor_age - 1) * 15) * 30;
                shang_spawn_attack(340, x, y, { angle: image_angle, lethal: lethal });
                break;

            case 335:
                if (actor_age == 1) {
                    var _camera = view_camera[0];
                    x = camera_get_view_x(_camera) + camera_get_view_width(_camera) + 80;
                    // G985 anchors Toasty to the logical page bottom, below the two-pixel crop.
                    y = camera_get_view_y(_camera) + camera_get_view_height(_camera) + 2;
                }
                if (actor_age < 10) {
                    x -= 10;
                } else if (actor_age > 30) {
                    x += 10;
                }
                if (actor_age > 60) { instance_destroy(); }
                break;

        }

        if (life >= 0 && actor_age >= life) {
            instance_destroy();
        }
        // Mudkip, the chunks and Liu Kang can arc back into the arena from above the camera.
        var _above_room = bbox_bottom < -256 && source_handle != 43 && source_handle != 322 && source_handle != 193;
        if (source_handle != 338 && (bbox_right < -256 || bbox_left > room_width + 256
            || _above_room || bbox_top > room_height + 256)) {
            instance_destroy();
        }
    }

    // G926 and G974 run after their creation events, including on the creation step.
    with (obj_shang_tsung_actor) {
        if (source_handle == 122) {
            ++actor_age;
            shang_actor_move_integer(0, vy);
            vy -= 0.5;
            if (bbox_bottom < -256) { instance_destroy(); }
        } else if (source_handle == 340 && ++actor_age >= 35) {
            instance_destroy();
        }
    }
}
