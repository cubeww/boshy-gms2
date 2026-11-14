function shang_tsung_attacks_setup() {
    boss_target_x = x;
    boss_target_y = y - 4;
    boss_facing = -1;
    boss_pose = -1;
    boss_pose_clock = 0;
    boss_pose_clip = undefined;
    boss_pose_finished = false;
    floor_transition_started = false;
    awaiting_landing = false;
    fatality_victim = noone;
    fatality_body = noone;
    fatality_head = noone;
    shadow_charge = noone;
    shadow_ball = noone;
    shang_tsung_pose(0);
}

function shang_tsung_pose(_animation) {
    if (boss_pose != _animation || boss_pose_finished) {
        boss_pose = _animation;
        boss_pose_clock = 0;
        boss_pose_finished = false;
        image_index = 0;
    }
    boss_pose_clip = shang_tsung_pose_data(_animation, boss_facing);
    sprite_index = boss_pose_clip.sprite;
    image_speed = 0;
}

function shang_tsung_face(_facing) {
    boss_facing = _facing;
    shang_tsung_pose(boss_pose);
}

function shang_tsung_pose_action_point() {
    return boss_pose_clip.points[clamp(floor(image_index), 0, array_length(boss_pose_clip.points) - 1)];
}

function shang_tsung_pose_step() {
    if (boss_pose_finished) {
        shang_tsung_pose(0);
    }
    // Each Fusion frame advances only when the animation counter exceeds 100.
    boss_pose_clock += boss_pose_clip.rate;
    if (boss_pose_clock <= 100) {
        return;
    }
    boss_pose_clock -= 100;
    if (image_index < image_number - 1) {
        ++image_index;
    } else if (boss_pose_clip.repeats == 0) {
        image_index = boss_pose_clip.loop_frame;
    } else if (boss_pose == 12 && fight_age >= 560 && fight_age <= 751) {
        // G693 runs immediately when the summoning animation finishes.
        shang_tsung_pose(13);
    } else {
        // The final image remains in place until Fusion resumes its default animation.
        boss_pose_finished = true;
    }
}

function shang_tsung_motion_step() {
    // G676 applies the original integer-position easing before the timeline changes its targets.
    x = floor(x + (boss_target_x - x) * 0.2 + sign(boss_target_x));
    y = floor(y + (boss_target_y - y) * 0.2 + sign(boss_target_y));
}

function shang_tsung_attack_shake(_strength, _blur = 0) {
    shake_strength = _strength;
    if (_blur > 0) {
        blur_strength = _blur;
        blur_angle = 0;
    }
}

function shang_tsung_launch_fire(_x, _y, _blur = 0) {
    shang_spawn_attack(120, _x, _y);
    shang_tsung_pose(12);
    audio_play_sound(snd_shang_tsung_launch, 1, false);
    shang_tsung_attack_shake(15, _blur);
}

function shang_tsung_teleport_effect(_offset_x = 0) {
    shang_spawn_attack(195, x + _offset_x, y - 50);
    audio_play_sound(snd_shang_tsung_teleport, 1, false);
}

function shang_tsung_rope(_angle, _speed = 5) {
    var _point = shang_tsung_pose_action_point();
    shang_spawn_attack(339, x + _point[0], y + _point[1], {base_angle: _angle, flight_speed: _speed});
}

function shang_tsung_split_victim(_play_strike) {
    if (!instance_exists(fatality_victim)) {
        return;
    }
    var _x = fatality_victim.x;
    var _y = fatality_victim.y;
    shang_spawn_attack(321, _x, _y, {attack_phase: 1});
    shang_spawn_attack(190, _x, _y - 40, {animation: 12, vx: -8, vy: -3});
    shang_spawn_attack(190, _x, _y + 40, {animation: 13, vx: -12, vy: -2});
    instance_destroy(fatality_victim);
    fatality_victim = noone;
    if (_play_strike) {
        audio_play_sound(snd_shang_tsung_strike, 1, false);
    }
    audio_play_sound(snd_shang_tsung_fatality, 1, false);
    shang_tsung_attack_shake(15, 2.5);
}

function shang_tsung_attacks_step(_player) {
    var _age = fight_age;
    // Fusion expressions read zero when the referenced player no longer exists.
    var _player_x = _player == noone ? 0 : _player.x;
    var _player_y = _player == noone ? 0 : _player.y;

    // G692 and G711 apply two bands of the same vertical sine wave.
    if (_age >= 560 && _age <= 752) {
        boss_target_y = 300 + dsin(_age * 5) * 100;
    }
    if (_age > 751 && _age < 1120) {
        boss_target_y = 750 + dsin(_age * 5) * 100;
    }
    if (_age >= 610 && _age <= 730 && _age mod 10 == 0) {
        var _first = _age == 610;
        var _x = (_age - 609) * (_first ? 1 : 5);
        shang_tsung_launch_fire(_x, 484, _age mod 20 == 10 ? 2.5 : 0);
    }
    if (_age >= 1250 && _age < 1450) {
        boss_target_x -= 20;
        shang_tsung_pose(15);
    }
    if (_age >= 1650 && _age < 1695 && instance_exists(fatality_victim)) {
        fatality_victim.image_angle = (fatality_victim.image_angle + 2) mod 360;
    }
    if (_age >= 2570 && _age <= 2598 && (_age - 2570) mod 4 == 0) {
        if (_age == 2570) {
            audio_play_sound(snd_shang_tsung_scorpion, 1, false);
        }
        if (_age == 2570 || _age == 2586) {
            audio_play_sound(snd_shang_tsung_rope, 1, false);
        }
        shang_tsung_rope(120 + (_age - 2570) * 5);
        shang_tsung_attack_shake(5, 2.5);
    }
    if (_age >= 2775 && _age < 2795) {
        var _shift = (_age - 2760) * 0.5;
        if (instance_exists(fatality_victim)) {
            fatality_victim.x = floor(fatality_victim.x + _shift);
        }
        if (instance_exists(fatality_head)) {
            fatality_head.x = floor(fatality_head.x + _shift);
        }
    }

    switch (_age) {
        case 560:
            shang_tsung_pose(13);
            audio_play_sound(snd_shang_tsung_attack_cry, 1, false);
            break;
        case 730:
            audio_play_sound(snd_shang_tsung_well_done, 1, false);
            break;
        case 750:
            if (!floor_transition_started) {
                // G708–710 swap the floor sections and suspend the fight at this age.
                floor_transition_started = true;
                awaiting_landing = true;
                shang_tsung_drop_floor();
            }
            break;
        case 780:
        case 830:
        case 860:
            var _angle = darctan2(x - _player_x, y - _player_y) + 90;
            shang_spawn_attack(193, x, y, {angle: _angle, base_angle: _angle});
            shang_tsung_pose(14);
            shang_tsung_attack_shake(15, 2.5);
            break;
        case 940:
        case 960:
        case 980:
            shang_tsung_launch_fire(_player_x, 950);
            break;
        case 1050:
            audio_play_sound(snd_shang_tsung_finish_him, 1, false);
            break;
        case 1100:
        case 2260:
            shang_tsung_pose(12);
            shang_tsung_teleport_effect();
            break;
        case 1130:
        case 2300:
            shang_tsung_pose(15);
            break;
        case 1135:
        case 1200:
            boss_target_x = _player_x + 55;
            boss_target_y = _player_y + (_age == 1135 ? 50 : 80);
            audio_play_sound(snd_shang_tsung_dash, 1, false);
            shang_tsung_attack_shake(25, 2.5);
            break;
        case 1160:
            boss_target_x = 574;
            shang_tsung_pose(16);
            break;
        case 1300:
        case 1400:
            boss_target_x = 700;
            boss_target_y = _player_y + 50;
            x = boss_target_x;
            y = boss_target_y;
            audio_play_sound(snd_shang_tsung_dash, 1, false);
            shang_tsung_attack_shake(40, 2.5);
            break;
        case 1500:
            x = 700;
            boss_target_x = 571;
            boss_target_y = 800;
            shang_tsung_pose(1);
            break;
        case 1530:
            fatality_victim = shang_spawn_attack(80, x - 80, y);
            shang_tsung_teleport_effect(-80);
            break;
        case 1560:
        case 2430:
            shang_tsung_pose(17);
            break;
        case 1565:
            if (instance_exists(fatality_victim)) {
                shang_actor_pose(fatality_victim, 1);
                var _x = fatality_victim.x;
                var _y = fatality_victim.y - 115;
                shang_spawn_attack(321, _x, _y);
                fatality_body = shang_spawn_attack(190, _x, _y, {vx: -2, vy: -8});
                shang_blood_shards(_x, _y, 40, true, false);
            }
            audio_play_sound(snd_shang_tsung_blood_explode, 1, false);
            audio_play_sound(snd_shang_tsung_victim_cry, 1, false);
            shang_tsung_attack_shake(40, 2.5);
            break;
        case 1635:
            shang_spawn_attack(120, 330, 950);
            shang_tsung_pose(12);
            audio_play_sound(snd_shang_tsung_launch, 1, false);
            audio_play_sound(snd_shang_tsung_fatality, 1, false);
            break;
        case 1650:
        case 2100:
            shang_tsung_pose(18);
            break;
        case 1660:
            shang_blood_shards(321, 726, 40, true, false);
            if (instance_exists(fatality_body)) {
                shang_spawn_attack(321, fatality_body.x, fatality_body.y);
                instance_destroy(fatality_body);
                fatality_body = noone;
            }
            shang_kill_attacks(122);
            audio_play_sound(snd_shang_tsung_blood_explode, 1, false);
            shang_tsung_attack_shake(15, 2.5);
            break;
        case 1720:
            if (instance_exists(fatality_victim)) {
                shadow_charge = shang_spawn_attack(337, fatality_victim.x, fatality_victim.y - 50);
            }
            audio_play_sound(snd_shang_tsung_excellent, 1, false);
            break;
        case 1735:
            shang_kill_attacks(80);
            fatality_victim = noone;
            if (instance_exists(shadow_charge)) {
                shadow_ball = shang_spawn_attack(338, shadow_charge.x, shadow_charge.y, {vx: -3, vy: -4});
                shadow_charge.attack_phase |= 1;
            }
            break;
        case 1800:
            if (instance_exists(shadow_ball)) {
                shadow_ball.attack_phase |= 1;
            }
            shang_tsung_pose(14);
            audio_play_sound(snd_shang_tsung_attack_cry, 1, false);
            audio_play_sound(snd_shang_tsung_shadow_ball, 1, false);
            shang_tsung_attack_shake(15);
            break;
        case 2200:
            shang_kill_attacks(338);
            shadow_ball = noone;
            shang_tsung_pose(19);
            break;
        case 2270:
            // G751 summons this Liu Kang before the first G753 fall update.
            fatality_victim = shang_spawn_attack(80, 514, 465, {attack_phase: 1});
            with (fatality_victim) {
                shang_liu_kang_fall_step();
            }
            break;
        case 2400:
            shang_tsung_pose(0);
            shang_tsung_teleport_effect();
            fatality_victim = shang_spawn_attack(80, 514, 465, {attack_phase: 1});
            break;
        case 2310:
            shang_tsung_split_victim(false);
            break;
        case 2440:
            if (instance_exists(fatality_victim)) {
                var _x = fatality_victim.x;
                var _y = fatality_victim.y;
                shang_actor_pose(fatality_victim, 1);
                fatality_victim.vy = 0;
                shang_spawn_attack(321, _x, _y, {attack_phase: 1});
                shang_spawn_attack(190, _x, _y - 40, {animation: 1, vx: -8, vy: -3});
            }
            audio_play_sound(snd_shang_tsung_fatality, 1, false);
            shang_tsung_attack_shake(15, 2.5);
            break;
        case 2530:
        case 2555:
            shang_tsung_pose(21);
            if (_age == 2530) {
                shang_tsung_teleport_effect();
            }
            break;
        case 2660:
            fatality_victim = shang_spawn_attack(80, 245, 1108, {attack_phase: 1, vy: -19});
            shang_tsung_pose(22);
            audio_play_sound(snd_shang_tsung_scorpion, 1, false);
            break;
        case 2690:
            shang_tsung_pose(21);
            shang_tsung_rope(180, 6);
            audio_play_sound(snd_shang_tsung_rope, 1, false);
            break;
        case 2738:
            audio_play_sound(snd_mario_blood_rip, 1, false);
            shang_kill_attacks(339);
            shang_kill_attacks(340);
            if (instance_exists(fatality_victim)) {
                fatality_head = shang_spawn_attack(82, fatality_victim.x, fatality_victim.y - 60);
                shang_actor_pose(fatality_victim, 12);
                fatality_victim.attack_phase &= ~1;
            }
            shang_tsung_pose(23);
            shang_tsung_attack_shake(25, 2.5);
            break;
        case 2790:
            shang_tsung_pose(24);
            break;
        case 2795:
            shang_kill_attacks(82);
            fatality_head = noone;
            shang_tsung_teleport_effect();
            shang_tsung_split_victim(true);
            break;
        case 2805:
            shang_spawn_attack(335, 344, 596);
            break;
        case 2850:
            shang_tsung_pose(25);
            shang_tsung_teleport_effect();
            break;
        case 2880:
        case 2965:
        case 3055:
            shang_tsung_pose(26);
            if (_age == 2965) {
                shang_tsung_face(1);
            }
            if (_age != 2880) {
                boss_target_x += 100;
            }
            audio_play_sound(snd_shang_tsung_teleport, 1, false);
            shang_tsung_attack_shake(15, 2.5);
            break;
        case 2885:
        case 2970:
        case 3010:
            visible = false;
            boss_target_x = _player_x + 145;
            boss_target_y = _player_y + 20;
            break;
        case 2920:
        case 3020:
        case 3090:
            visible = true;
            shang_tsung_pose(27);
            shang_tsung_face(_age == 3090 ? -1 : 1);
            if (_age != 2920) {
                audio_play_sound(snd_shang_tsung_teleport, 1, false);
            }
            break;
        case 2925:
        case 3025:
            shang_tsung_pose(28);
            shang_tsung_face(1);
            boss_target_x -= 40;
            if (_age == 2925) {
                audio_play_sound(snd_shang_tsung_teleport, 1, false);
            }
            break;
        case 3065:
            visible = false;
            boss_target_x = 571;
            boss_target_y = 800;
            break;
        case 3095:
            shang_tsung_pose(25);
            break;
        case 3150:
            // G799 starts the lower arena sequence again without restoring the floor.
            fight_age = 750;
            shang_tsung_pose(0);
            audio_play_sound(snd_shang_tsung_loop_voice, 1, false);
            shang_spawn_attack(195, x, y - 50);
            break;
    }

    // G747 switches to the recovery pose before G748 reads its action point.
    if (_age >= 2100 && _age < 2200 && instance_exists(shadow_ball)) {
        var _point = shang_tsung_pose_action_point();
        shadow_ball.attack_phase &= ~1;
        shadow_ball.x = floor(shadow_ball.x + abs(x + _point[0] - shadow_ball.x) * 0.1);
        shadow_ball.vx *= 0.5;
        shadow_ball.vy *= 0.9;
    }

    // G737 creates the fixed afterimage behind the fighter during dash animation 15.
    if (boss_pose == 15) {
        var _afterimage = shang_spawn_attack(336, x, y);
        _afterimage.depth = depth + 1;
    }
}
