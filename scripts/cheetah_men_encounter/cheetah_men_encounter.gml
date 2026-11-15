function cheetah_men_first_phase_step() {
    // G1097–1099: a running jump into the room and the first landing.
    if (fight_age == 9) {
        phase_one.actor_hsp = -5;
        phase_one.actor_vsp = -15;
    }
    if (fight_age >= 10 && fight_age <= 44) {
        phase_one.x += phase_one.actor_hsp;
        phase_one.y += phase_one.actor_vsp;
        ++phase_one.actor_vsp;
    }
    if (fight_age == 45) {
        cheetah_men_first_phase_land(15);
    }

    // G1105–1110 use a shorter interval for the later repeated jumps.
    if (fight_age > 75 && fight_age < 340) {
        var _interval = fight_age < 150 ? 35 : 20;
        if (attack_clock > _interval) {
            phase_one.actor_vsp = -20;
            phase_one.actor_hsp = 0;
            attack_clock = 0;
            audio_play_sound(snd_cheetah_men_jump, 1, false);
        }
        if (attack_clock >= 5) {
            phase_one.x += phase_one.actor_hsp;
            phase_one.y = floor(phase_one.y + phase_one.actor_vsp);
        }
        if (attack_clock >= 8 && attack_clock <= 14) {
            phase_one.actor_vsp *= 0.5;
        } else if (attack_clock == 15) {
            phase_one.actor_vsp = 15;
        } else if (attack_clock == 20) {
            cheetah_men_first_phase_land(10);
        }
    }

    if (fight_age == 380) {
        fight_age = 430;
    }
    if (fight_age > 440 && fight_age <= 468) {
        phase_one.x += phase_one.actor_hsp;
        --phase_one.actor_hsp;
    }
    if (fight_age == 470) {
        phase_one.actor_vsp = -5;
        phase_one.actor_hsp = 2;
        audio_play_sound(snd_cheetah_men_jump, 1, false);
    }
    if (fight_age > 470 && fight_age < 660) {
        phase_one.x += phase_one.actor_hsp;
        phase_one.y = floor(phase_one.y + phase_one.actor_vsp);
        phase_one.actor_vsp += 0.05;
        phase_one.image_angle -= 2;
    }
    if (fight_age > 485 && fight_age <= 680) {
        cheetah_men_spawn(CheetahMenAttack.SpiralShot, phase_one.x, phase_one.y, 0, 0, spiral_direction);
        spiral_direction += 12;
    }
    if (fight_age == 660) {
        phase_one.actor_hsp = 0;
        phase_one.image_angle = 0;
    }
    if (fight_age > 660 && fight_age < 692) {
        phase_one.x += phase_one.actor_hsp;
        phase_one.y = floor(phase_one.y + phase_one.actor_vsp);
        phase_one.actor_vsp += 0.05;
    }
    if (fight_age == 692) {
        phase_one.x = 514;
        phase_one.y = 431;
        phase_one.actor_vsp = 0;
        phase_one.actor_hsp = 0;
    }
    if (fight_age >= 695 && fight_age <= 730) {
        phase_one.y -= 12;
    }
    if (fight_age > 700 && fight_age <= 1000 && attack_clock >= 35) {
        cheetah_men_spawn(CheetahMenAttack.HoppingCharge, 678, 430, -5 - irandom(2));
        attack_clock = 0;
    }
    if (fight_age == 1120) {
        cheetah_men_spawn(CheetahMenAttack.Runner, 130, 449, 4);
    }
    if (fight_age >= 1200 && fight_age <= 1250 && !phase_one_cleared) {
        fight_age = 1199;
    }
}

function cheetah_men_first_phase_land(_shake) {
    phase_one.x = 514;
    phase_one.y = 431;
    phase_one.actor_vsp = 0;
    phase_one.actor_hsp = 0;
    shake_strength = _shake;
    cheetah_men_spawn(CheetahMenAttack.TrackingFlame, phase_one.x, phase_one.y, -8);
}

function cheetah_men_second_phase_step() {
    if (fight_age < 1400 || fight_age >= 3000) {
        return;
    }
    if (fight_age == 1400) {
        phase_two.actor_active = true;
    }

    if (fight_age <= 2200 || (fight_age >= 2300 && fight_age <= 2500)) {
        // G1149–57 and G1164–65 preserve the jump clock across the two motion windows.
        phase_two.x += phase_two.actor_hsp;
        phase_two.y = floor(phase_two.y + phase_two.actor_vsp);
        phase_two.actor_vsp += 0.5;
        ++phase_two_jump_age;
        if (fight_age == 1400) {
            phase_two_jump_age = 0;
        }
        phase_two.attack_pose = phase_two_jump_age >= 1 && phase_two_jump_age <= 10;
        if (phase_two.attack_pose) {
            phase_two.actor_vsp = 0;
        }
        if (phase_two_jump_age == 10) {
            phase_two.actor_vsp = -8;
            audio_play_sound(snd_cheetah_men_jump, 1, false);
        }
        var _jump_again = (fight_age <= 2100 && phase_two.y > 180)
            || (fight_age >= 2330 && phase_two.y > -200);
        if (_jump_again && phase_two_jump_age > 10 && phase_two.actor_vsp > 0) {
            phase_two_jump_age = 0;
        }
        phase_two.update_pose();
    }
    if (fight_age >= 1550 && fight_age <= 2100 && phase_two_jump_age >= 10) {
        phase_two.x += phase_two_move_left ? -2 : 2;
    }
    if (fight_age >= 1550 && fight_age <= 2100) {
        if (phase_two_move_left && phase_two.x <= 100) {
            phase_two_move_left = false;
        } else if (!phase_two_move_left && phase_two.x >= 540) {
            phase_two_move_left = true;
        }
    }
    if (fight_age >= 1500 && fight_age <= 2000 && attack_clock >= 45) {
        cheetah_men_spawn_bee(phase_two.x, phase_two.y);
        attack_clock = 0;
    }
    if (fight_age >= 2100 && fight_age < 2200) {
        phase_two.x = floor(lerp(phase_two.x, 570, 0.25));
    }
    if (phase_two.actor_active) {
        var _tile = noone;
        with (phase_two) {
            _tile = instance_place(x, y, obj_cheetah_men_floor);
        }
        if (_tile != noone) {
            cheetah_men_break_tile(_tile);
        }
    }
    if (fight_age >= 2100 && phase_two.y > 472) {
        phase_two.y = 472;
        phase_two.actor_vsp = 0;
    }
    if (fight_age >= 2200 && fight_age <= 2320) {
        phase_two.x -= 4;
    }
    if (fight_age >= 2220 && fight_age <= 2300 && ++phase_two_platform_age >= 4) {
        cheetah_men_spawn(CheetahMenAttack.FlyingPlatform, phase_two.x, phase_two.y - 32);
        phase_two_platform_age = 0;
    }
    if (fight_age == 2500) {
        phase_two.actor_active = false;
        cheetah_men_spawn(CheetahMenAttack.Bouncer, 316, -23, -8);
    }
    if (fight_age >= 2600 && fight_age <= 2700) {
        // G1178 waits for twenty hits on the bouncing target.
        fight_age = 2650;
    }
}

function cheetah_men_third_phase_step(_player) {
    if (fight_age < 3000 || fight_age >= 4000) {
        return;
    }
    if (fight_age == 3000) {
        phase_three.restore_actor(458, -9);
        phase_three.faces_left = true;
        phase_three.update_pose();
    }
    if (phase_three_break_floor) {
        phase_three.y += 2;
        var _tile = noone;
        with (phase_three) {
            _tile = instance_place(x, y, obj_cheetah_men_air_platform);
        }
        if (_tile != noone) {
            // G1188–89 remove the temporary tiles and send the player upward.
            cheetah_men_break_tile(_tile);
            with (obj_cheetah_men_air_platform) {
                instance_destroy();
            }
            phase_three_break_floor = false;
            if (_player != noone) {
                _player.vsp = -10;
            }
        }
    }
    if (attack_clock >= 30 && phase_three_hits < 50) {
        cheetah_men_phase_three_spawn(CheetahMenPhaseThreeHazard.BounceTarget,
            675, phase_three.y + 16 + irandom(45), -2 - irandom(2));
        attack_clock = 0;
    }
    if (fight_age >= 3250 && fight_age <= 3400) {
        --phase_three.y;
    }
    if (phase_three_hits >= 50) {
        cheetah_men_phase_three_drop();
        audio_pause_sound(game_controller.stage_music_instance);
        audio_play_sound(snd_cheetah_men_phase_clear, 1, false);
        phase_one.actor_active = false;
        phase_two.actor_active = false;
        phase_three.actor_active = false;
        for (var _i = 0; _i < 20; ++_i) {
            cheetah_men_spawn(CheetahMenAttack.FlyingPlatform, 152 + _i * 16, 440);
        }
        inst_cheetah_men_flash.flash_alpha = 1;
        fight_age = 4000;
        exit;
    }
    if (fight_age >= 3250 && phase_three_slide_clock >= 6) {
        cheetah_men_phase_three_shift_drop();
        phase_three_slide_clock = 0;
    }
    if (fight_age >= 3250 && phase_three_hazard_clock >= 200 && _player != noone) {
        cheetah_men_phase_three_spawn(CheetahMenPhaseThreeHazard.FallingTarget, _player.x, -30);
        phase_three_hazard_clock = 0;
        phase_three.attack_pose = true;
        phase_three.update_pose();
    }
    if (fight_age == 3250) {
        cheetah_men_phase_three_arm_drop();
    }
    if (fight_age >= 3900) {
        fight_age = 3950;
    }
}

function cheetah_men_transform_step(_player) {
    if (fight_age < 4080) {
        return;
    }
    // G1204–08: the fake victory jingle and the three Cheetahs' return.
    switch (fight_age) {
        case 4080:
            phase_three_jingle = audio_play_sound(snd_cheetah_men_victory_music, 1, false);
            break;
        case 4230:
            audio_stop_sound(phase_three_jingle);
            phase_three_jingle = -1;
            break;
        case 4250:
            phase_one.restore_actor(465, -14);
            break;
        case 4275:
            phase_two.restore_actor(512, -16);
            break;
        case 4300:
            phase_three.restore_actor(546, -14);
            phase_three.faces_left = true;
            phase_three.update_pose();
            break;
        case 4450:
            audio_play_sound(snd_cheetah_men_transform, 1, false);
            phase_one.image_index = 0;
            phase_two.image_index = 0;
            phase_three.image_index = 0;
            phase_one.image_speed = 0;
            phase_two.image_speed = 0;
            phase_three.image_speed = 0;
            phase_two.layer = layer_get_id("Effects");
            phase_three.layer = layer_get_id("Effects");
            break;
        case 4600:
            if (_player != noone) {
                audio_resume_sound(game_controller.stage_music_instance);
            }
            hud_max_health = 0;
            break;
    }
    if (fight_age <= 4450) {
        with (obj_cheetah_men_actor) {
            if (actor_active && y < 350) {
                y += 3;
            }
        }
    }
    if (fight_age >= 4450 && fight_age <= 4460) {
        phase_two.giant_form = true;
        phase_two.update_pose();
        phase_two.image_xscale += 0.1;
        phase_two.image_yscale = phase_two.image_xscale;
        phase_two.y += 3;

        phase_one.image_xscale += 0.1;
        phase_one.image_yscale = phase_one.image_xscale;
        phase_one.y -= 6;
        phase_one.image_angle += 4;

        phase_three.image_xscale += 0.1;
        phase_three.image_yscale = phase_three.image_xscale;
        phase_three.y -= 6;
        phase_three.image_angle -= 4;
    }
    if (fight_age >= 4470 && fight_age <= 4480) {
        phase_two.image_xscale += 0.1;
        phase_two.image_yscale = phase_two.image_xscale;
        phase_two.y += 2;

        phase_one.image_angle += 5;
        phase_one.x += 4;
        phase_three.image_angle -= 5;
    }
    if (fight_age >= 4490 && fight_age <= 4500) {
        phase_two.image_xscale += 0.1;
        phase_two.image_yscale = phase_two.image_xscale;
        phase_two.y += 2;

        // G1221 and G1226 raise both arms again as the body grows.
        phase_one.y -= 6;
        phase_one.image_angle += 3;
        phase_one.image_xscale -= 0.025;
        phase_one.image_yscale += 0.1;

        phase_three.y -= 6;
        phase_three.image_angle -= 5;
        phase_three.image_xscale -= 0.025;
        phase_three.image_yscale += 0.1;
    }
    if (fight_age >= 4610 && fight_age <= 5250) {
        phase_one.image_angle = 80 + dcos(fight_age * 5) * 40;
        phase_three.image_angle = (phase_three.image_angle + 359) mod 360;
        if (attack_clock >= 40 && _player != noone) {
            var _origin = phase_one.projectile_origin();
            cheetah_men_spawn(CheetahMenAttack.OrbitFire, _origin.x, _origin.y,
                (_player.x - _origin.x) * 0.02, -4);
            audio_play_sound(snd_cheetah_men_jump, 1, false);
            attack_clock = 0;
        }
        if (phase_three.image_angle == 0) {
            var _origin = phase_three.projectile_origin();
            cheetah_men_spawn(CheetahMenAttack.FinisherFlame, _origin.x, _origin.y);
            shake_strength = 10;
            audio_play_sound(snd_solgryn_late_shield_rocket_launch, 1, false);
        }
    }
    if (fight_age >= 5200 && fight_age < 5250) {
        fight_age = 5225;
    }
}
