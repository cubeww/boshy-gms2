enum GreenGreensKrackoAttack {
    Lightning,
    Minion,
    FallingStar,
    SwingStar
}

function green_greens_kracko_setup() {
    kracko_boss = noone;
    kracko_gates = [];
    kracko_started = false;
    kracko_shake_steps = 0;
}

function green_greens_kracko_step(_player) {
    // Group 992 closes both sides when the player reaches the middle of the bridge.
    if (!kracko_started && _player != noone && !_player.input_locked
        && point_in_rectangle(_player.x, _player.y, 3356, -5, 3839, 342)) {
        kracko_started = true;
        kracko_gates = [
            instance_create_layer(3169, 1, "Gameplay", obj_solid, {
                sprite_index: spr_green_greens_kracko_gate, visible: false
            }),
            instance_create_layer(3841, -1, "Gameplay", obj_solid, {
                sprite_index: spr_green_greens_kracko_gate
            })
        ];
        kracko_boss = instance_create_depth(3534, -112, depth - 1, obj_green_greens_kracko, {
            stage_controller: id
        });
        game_controller.start_stage_music(snd_green_greens_kracko_music, false, false);
    }

    if (instance_exists(kracko_boss)) {
        with (kracko_boss) {
            green_greens_kracko_boss_step(_player);
        }
    }
}

function green_greens_kracko_draw_health() {
    if (!instance_exists(kracko_boss)) {
        return;
    }
    var _hp = clamp(kracko_boss.hit_points, 0, 15);
    var _frame_count = sprite_get_number(spr_green_greens_kracko_hp);
    var _frame = min(_frame_count - 1, floor(_hp * _frame_count / 15));
    draw_sprite(spr_green_greens_kracko_hp, _frame, 3280, 16);
}

function green_greens_kracko_attack(_kind, _x, _y, _scale = 1, _arm_offset = 0, _angle = 0) {
    instance_create_depth(_x, _y, depth - 1, obj_green_greens_kracko_attack, {
        boss: id,
        attack_kind: _kind,
        attack_scale: _scale,
        arm_offset: _arm_offset,
        image_angle: _angle
    });
}

function green_greens_kracko_lightning(_width_scale, _shake, _angle = 0) {
    green_greens_kracko_attack(GreenGreensKrackoAttack.Lightning, x, y, _width_scale, 0, _angle);
    stage_controller.kracko_shake_steps = _shake;
    audio_play_sound(snd_green_greens_kracko_lightning, 1, false);
}

function green_greens_kracko_explosion(_x, _y, _scale, _play_sound = true) {
    // Fusion uses the same Active 92 explosion as Hello Kitty.
    instance_create_depth(_x, _y, depth - 1, obj_hello_kitty_attack, {
        boss: id,
        attack_kind: HelloKittyAttack.Explosion,
        heading: irandom(359),
        travel_speed: 0,
        draw_scale: _scale
    });
    if (_play_sound) {
        audio_play_sound(snd_green_greens_kracko_explosion, 1, false);
    }
}

function green_greens_kracko_finish() {
    green_greens_kracko_explosion(x, y, 3);
    stage_controller.kracko_shake_steps = 40;
    for (var _i = 0; _i < array_length(stage_controller.kracko_gates); ++_i) {
        instance_destroy(stage_controller.kracko_gates[_i]);
    }
    with (obj_green_greens_kracko_attack) {
        if (boss == other.id) {
            instance_destroy();
        }
    }
    global.run.music_position = 0;
    stage_controller.game_controller.start_stage_music(snd_green_greens_plains);
    instance_destroy();
}

function green_greens_kracko_emit_arcs() {
    // Fusion group 1031 creates three half-scale additive bolts behind the actors.
    if (arc_interval < 10) {
        return;
    }
    arc_interval = 0;
    repeat (3) {
        instance_create_depth(x, y, stage_controller.depth + 1, obj_green_greens_kracko_arc, {
            image_angle: irandom(359),
            image_xscale: 0.5,
            image_yscale: 0.5
        });
    }
}

function green_greens_kracko_boss_step(_player) {
    ++animation_age;
    ++arc_interval;
    if (hit_flash_age >= 0 && ++hit_flash_age >= 10) {
        hit_flash_age = -1;
    }
    image_index = floor(animation_age * 0.15) mod image_number;
    if (_player != noone) {
        eye_angle = point_direction(x, y, _player.x, _player.y);
    }

    if (hit_points == 0) {
        ++target_y;
        y = lerp(y, target_y, 0.2) + dsin(animation_age * 5) * 6;
        // Groups 1025–1026 alternate a small silent burst and a stronger shaking burst.
        if (++defeat_age == 5) {
            green_greens_kracko_explosion(x + irandom(63) - irandom(63), y + irandom(31) - irandom(31), 1, false);
        } else if (defeat_age == 11) {
            defeat_age = 0;
            green_greens_kracko_explosion(x + irandom(79) - irandom(79), y + irandom(31) - irandom(31), 1);
            stage_controller.kracko_shake_steps = 15;
        }
        if (y > 480) {
            green_greens_kracko_finish();
        } else {
            green_greens_kracko_emit_arcs();
        }
        return;
    }

    // Groups 993–1016 use a 1480-step pattern and loop from the first lightning pass.
    ++attack_age;
    ++attack_interval;
    if (attack_age < 45) {
        target_y += 5;
    }
    switch (attack_age) {
        case 115:
            target_x = 3524;
            phase_hits = 0;
            break;
        case 120:
            // The first bolt rotates from its downward orientation toward the player.
            var _angle = _player == noone ? 0 : darctan2(_player.x - x, _player.y - y);
            green_greens_kracko_lightning(1, 20, _angle);
            break;
        case 170:
            target_x = 3224;
            break;
        case 190:
            target_y += 200;
            break;
        case 271:
            target_y -= 200;
            phase_hits = 0;
            break;
        case 580:
            green_greens_kracko_lightning(1, 30);
            break;
        case 1400:
            with (obj_green_greens_kracko_attack) {
                if (boss == other.id && attack_kind == GreenGreensKrackoAttack.SwingStar) {
                    instance_destroy();
                }
            }
            break;
        case 1480:
            attack_age = 95;
            break;
    }

    if (attack_age >= 200 && attack_age < 270) {
        target_x += 8;
    } else if (attack_age >= 300 && attack_age < 400 && attack_interval >= 15) {
        green_greens_kracko_attack(GreenGreensKrackoAttack.Minion, x, y);
        stage_controller.kracko_shake_steps = 10;
        audio_play_sound(snd_green_greens_kracko_throw, 1, false);
        attack_interval = 0;
    } else if (attack_age >= 470 && attack_age < 580) {
        target_x -= 5;
        if (attack_interval >= 30) {
            green_greens_kracko_lightning(0.4, 30);
            attack_interval = 0;
        }
    } else if (attack_age >= 600 && attack_age < 900 && attack_interval >= 9) {
        target_x = 3524 + dsin(attack_age * 2) * 300;
        green_greens_kracko_attack(GreenGreensKrackoAttack.FallingStar, 3210 + irandom(619), -32, 2);
        stage_controller.kracko_shake_steps = 10;
        audio_play_sound(snd_green_greens_kracko_star, 1, false);
        attack_interval = 0;
    } else if (attack_age >= 950 && attack_age < 960) {
        var _offset = attack_age - 949;
        green_greens_kracko_attack(GreenGreensKrackoAttack.SwingStar, x, y, 1, _offset * 60);
        green_greens_kracko_attack(GreenGreensKrackoAttack.SwingStar, x, y, 1, 35 - _offset * 60);
    }
    // The swinging stars reset the same Fusion timer before the arc event runs.
    if (attack_age >= 950 && attack_age <= 1400 && arc_interval >= 6) {
        audio_play_sound(snd_green_greens_kracko_swing, 1, false);
        arc_interval = 0;
    }

    x = lerp(x, target_x, 0.2);
    y = lerp(y, target_y, 0.2) + dsin(attack_age * 5) * 6;
    image_alpha = clamp(image_alpha + (phase_hits >= 6 ? -15 : 10) / 128, 38 / 128, 1);
    green_greens_kracko_emit_arcs();

    // Groups 1021–1022 cap hits per vulnerable phase and double damage in Ez-mode.
    with (obj_bullet) {
        if (other.phase_hits < 6 && other.hit_points > 0 && place_meeting(x, y, other.id)) {
            instance_destroy();
            ++other.phase_hits;
            other.hit_points = max(0, other.hit_points - other.shot_damage);
            if (other.hit_flash_age < 0) {
                other.hit_flash_age = 1;
            }
            if (other.hit_points == 0) {
                other.target_y = other.y;
                var _game = other.stage_controller.game_controller;
                if (_game.stage_music_instance != -1) {
                    audio_stop_sound(_game.stage_music_instance);
                    _game.stage_music_instance = -1;
                }
            }
        }
    }
}
