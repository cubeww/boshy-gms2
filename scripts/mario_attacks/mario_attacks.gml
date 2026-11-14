function mario_attacks_step(_player) {
    var _age = fight_age;
    if (_age < 400) {
        mario_intro_step(_age);
        return;
    }
    // Fusion object expressions read as zero when the player has been destroyed.
    var _has_player = _player != noone;
    var _player_x = _has_player ? floor(_player.x) : 0;

    // Groups 698–724. Mario grows, slams down, rolls, and then tracks the player.
    if (_age == 400) {
        shake_strength = 25;
    }
    if (_age < 470) {
        y -= 15;
        mario_set_pose(spr_mario_jump, spr_mario_jump_left);
    }
    if (_age == 470) {
        audio_play_sound(snd_mario_power_up, 1, false);
        mario_set_scale(3);
        y -= 32;
    }
    if (_age == 490) {
        x = _player_x + irandom(17) - irandom(17);
        y = -669;
    }
    if (_age >= 490 && _age < 525) {
        y += 30;
        mario_set_pose(spr_mario_fall, spr_mario_fall_left);
    }
    if (_age == 525) {
        y = 370;
        mario_set_pose(spr_mario_fall, spr_mario_fall_left);
        shake_strength = 25;
    }
    if (_has_player && _age >= 580 && _age < 800 && roll_direction == 0) {
        roll_direction = sign(_player_x - x);
    }
    if (roll_direction != 0 && _age < 700) {
        image_angle -= roll_direction * 10;
        x = floor(x + roll_direction * ((roll_direction < 0 ? 1 : 2) + abs(x - _player_x) * 0.05));
    }
    if ((roll_direction < 0 && x < 50) || (roll_direction > 0 && x > 600)) {
        fight_age = 800;
        _age = 800;
        image_angle = 0;
        var _player_side = _has_player ? sign(_player_x - x) : 0;
        if (_player_side != 0) {
            facing = _player_side;
        }
        if (roll_direction < 0) {
            mario_set_pose(spr_mario_idle, spr_mario_idle_left);
        } else {
            mario_set_pose(spr_mario_run, spr_mario_run_left);
        }
        y += 16;
        chase_speed = 4 * roll_direction;
        roll_direction = 0;
    }
    if (_has_player && _age >= 800 && _age < 1050) {
        var _trail_count = 0;
        // Fusion checks the right-side event against the X set by the left-side event.
        if (_player_x < x) {
            x = floor(x + chase_speed);
            chase_speed -= 0.5;
            ++_trail_count;
        }
        if (_player_x > x) {
            x = floor(x + chase_speed);
            chase_speed += 0.5;
            ++_trail_count;
        }
        var _target_direction = sign(_player_x - x);
        if (_trail_count > 0) {
            var _run_frame = (sprite_index == spr_mario_run || sprite_index == spr_mario_run_left) ? image_index : 0;
            if (_target_direction != 0) {
                facing = _target_direction;
            }
            mario_set_pose(spr_mario_run, spr_mario_run_left);
            image_index = _run_frame;
            repeat (_trail_count) {
                array_push(mario_trails, {
                    x: x, y: y, sprite: sprite_index, frame: image_index, scale: image_xscale,
                    angle: image_angle, birth: scene_steps
                });
            }
        }
        if (_target_direction != 0 && chase_target_direction != _target_direction) {
            shake_strength = 15;
            blur_strength = 10;
            audio_play_sound(choose(snd_mario_lucky, snd_mario_gotcha, snd_mario_tumtaratum), 1, false);
        }
        chase_target_direction = _target_direction;
    }
    if (_age == 1050) {
        chase_target_direction = 0;
        audio_play_sound(snd_mario_no_problem, 1, false);
    }
    if (_age >= 1050 && _age < 1100) {
        y -= 15;
        mario_set_pose(spr_mario_jump, spr_mario_jump_left);
    }

    // Groups 725–731. Lava waves rise while horizontal fireballs enter from either wall.
    if (_age >= 1100 && _age < 1150) {
        ++lava_amplitude;
        x = -100;
    }
    if (_age >= 1300 && _age < 1380) {
        --lava_amplitude;
    }
    if (_age >= 1350 && _age < 1430) {
        ++lava_amplitude;
    }
    if (_age >= 1400 && _age < 1700) {
        ++mario_wave_steps;
        if (mario_wave_steps mod 150 == 0) {
            mario_spawn_wave(-1, irandom_range(350, 449), false);
        }
        if (mario_wave_steps mod 133 == 0) {
            mario_spawn_wave(1, irandom_range(350, 449), false);
        }
    }
    if (_age >= 1720 && _age < 1770) {
        --lava_amplitude;
    }
    if (_age >= 1800 && _age <= 2300 && spawn_counter >= 40) {
        var _player_y = _has_player ? floor(_player.y) : 0;
        mario_spawn_wave(-1, irandom_range(350, 449), true, _player_y + 8);
        spawn_counter = 0;
    }

    // Groups 732–755. Mario erupts twice, dives through the floor and returns for the final volley.
    switch (_age) {
        case 1800: case 2150:
            audio_play_sound(snd_mario_im_moving_now, 1, false);
            audio_play_sound(snd_mario_power_up, 1, false);
            mario_set_scale(_age == 1800 ? 8 : 10);
            x = _player_x + irandom(79) - irandom(79);
            y = _age == 1800 ? 650 : 700;
            image_angle = 0;
            if (_age == 1800) {
                mario_clear_side_fireballs();
            }
            break;
        case 1900: case 2300:
            vertical_speed = -20;
            audio_play_sound(snd_mario_wooha, 1, false);
            shake_strength = 35;
            break;
        case 2600:
            audio_play_sound(snd_mario_tasty_treat, 1, false);
            audio_play_sound(snd_mario_pipe, 1, false);
            mario_set_scale(4);
            x = 329;
            y = 555;
            arena_floor.set_floor_open(true);
            break;
        case 2700:
            vertical_speed = -10;
            audio_play_sound(snd_mario_phase_jump, 1, false);
            break;
        case 3000:
            arena_floor.set_floor_open(false);
            audio_play_sound(snd_mario_ha, 1, false);
            break;
        case 3600: case 3620: case 3640:
            mario_set_scale(image_xscale - 1);
            if (_age == 3600) {
                audio_play_sound(snd_mario_pipe, 1, false);
            } else if (_age == 3640) {
                audio_play_sound(snd_mario_brothers, 1, false);
            }
            break;
        case 4100:
            image_angle = 0;
            fight_age = 300;
            audio_play_sound(snd_mario_here_i_come, 1, false);
            break;
    }
    if ((_age >= 1850 && _age < 1890) || (_age >= 2200 && _age < 2240)) {
        y -= 2;
    }
    if ((_age >= 1900 && _age <= 2050) || (_age >= 2300 && _age <= 2550)) {
        y = floor(y + vertical_speed);
        vertical_speed += 0.5;
        image_angle += 2;
    }
    if (_age >= 2700 && _age < 2750) {
        y = floor(y + vertical_speed);
        vertical_speed += 0.2;
    }
    if (_age >= 1900 && _age < 2750 && vertical_speed > -15 && vertical_speed < 0) {
        mario_spawn_flame(_age * 15, 2);
        audio_play_sound(snd_mario_fireball, 1, false);
    }
    // Fusion evaluates the Every conditions before these volleys' upper age limits.
    if (_age >= 2700) {
        ++mario_flame_pair_steps;
        if (_age < 2900 && (mario_flame_pair_steps * 20) mod 150 < 20) {
            mario_spawn_flame(image_angle, 5);
            image_angle += 15;
            mario_spawn_flame(image_angle + 180, 5, true);
            audio_play_sound(snd_mario_fireball, 1, false);
        }
    }
    if (_age >= 3100) {
        ++mario_flame_barrage_steps;
        if (_age < 3500) {
            var _turn = (_age - 3100) div 2;
            if (mario_flame_barrage_steps mod 3 == 0) {
                mario_spawn_flame(image_angle + irandom(1) - irandom(1) - _turn, 1);
                image_angle += 30;
                audio_play_sound(snd_mario_fireball, 1, false);
            }
            if (mario_flame_barrage_steps mod 60 == 0) {
                for (var _i = 0; _i < 22; ++_i) {
                    mario_spawn_flame(_i * 16 - _turn, 1.5);
                }
            }
        }
    }
    if (_age >= 3665 && _age <= 3950) {
        if (spawn_counter == 40 || spawn_counter >= 80) {
            mario_spawn_hammer();
        }
        if (spawn_counter >= 80) {
            spawn_counter = 0;
        }
    }
}

function mario_intro_step(_age) {
    var _has_koopa = instance_exists(intro_koopa);
    if (_has_koopa) {
        // Fusion advances static movement animations and dispatches collision events
        // before evaluating the regular opening events for this step.
        intro_koopa.image_speed = 0;
        intro_koopa.image_index = (max(0, ((_age - 1) * 21 - 1) div 200)) mod intro_koopa.image_number;
        if (koopa_squash_age < 0 && place_meeting(x, y, intro_koopa)) {
            mario_set_pose(spr_mario_idle, spr_mario_idle_left);
            intro_koopa.image_yscale = 0.6;
            intro_koopa.image_xscale = 1.7;
            intro_koopa.y += 3;
            koopa_squash_age = 0;
            audio_play_sound(snd_mario_mmm, 1, false);
        }
        if (_age <= 220) {
            --intro_koopa.x;
        }
    }
    if (_age > 130 && _age <= 200) {
        x -= 2;
        facing = -1;
        mario_set_pose(spr_mario_run, spr_mario_run_left);
    }
    if (_age == 200) {
        vertical_speed = -5;
        audio_play_sound(snd_mario_jump, 1, false);
    }
    if (_age >= 200 && _age <= 252) {
        // Group 690 writes an integer Y before the next velocity update.
        y = floor(y + vertical_speed);
        vertical_speed += 0.2;
    }
    if (_age >= 200 && _age <= 250) {
        x -= 2;
        facing = -1;
        mario_set_pose(spr_mario_jump, spr_mario_jump_left);
    }
    if (_has_koopa && koopa_squash_age >= 0) {
        ++koopa_squash_age;
        // Group 693 fires every 150 ms, alternating seven- and eight-step intervals.
        if ((koopa_squash_age * 20) mod 150 < 20) {
            intro_koopa.image_xscale += 0.02;
            intro_koopa.image_yscale -= 0.05;
            ++intro_koopa.y;
            ++y;
        }
        if (koopa_squash_age == 40) {
            repeat (floor(360 * global.settings.blood_intensity / 100)) {
                instance_create_depth(intro_koopa.x, intro_koopa.y, depth - 1, obj_blood);
            }
            instance_destroy(intro_koopa);
            y += 4;
            shake_strength = 25;
            audio_play_sound(snd_mario_blood_rip, 1, false);
        }
    }
    if (_age == 300) {
        audio_play_sound(snd_mario_here_i_come, 1, false);
    }
    if (_age == 130) {
        audio_play_sound(snd_mario_wooha, 1, false);
    }
}
