function sanicz_movement_step(_player) {
    // Groups 1121–1129 cue the music, sky fade, and opening passes.
    switch (fight_age) {
        case 30:
            audio_play_sound(snd_sanicz_too_slow, 1, false);
            if (instance_exists(inst_sanicz_sky)) {
                inst_sanicz_sky.begin_fade();
            }
            break;
        case 40:
            game_controller.start_stage_music(snd_sanicz_music, false, false);
            break;
        case 100:
        case 480:
        case 530:
            audio_play_sound(snd_sanicz_voice_46, 1, false);
            break;
        case 130:
            audio_play_sound(snd_sanicz_voice_30, 1, false);
            break;
        case 430:
        case 490:
            audio_play_sound(snd_sanicz_voice_41, 1, false);
            break;
        case 450:
        case 510:
            audio_play_sound(snd_sanicz_voice_43, 1, false);
            break;
        case 540:
            audio_play_sound(snd_sanicz_voice_41, 1, false);
            audio_play_sound(snd_sanicz_voice_43, 1, false);
            break;
    }

    if (fight_age >= 80 && fight_age < 98) {
        sanicz_set_pose(0, -1);
        x -= 50;
    }
    if (fight_age == 161) {
        x = -53;
        y = 64;
    }
    if (fight_age >= 160 && fight_age < 330) {
        y = floor(50 + dsin((scene_steps * 20) div 3) * 32);
        x += 5;
        sanicz_set_pose(12, 1);
    }
    sanicz_bumpers_spawn();
    if (fight_age >= 450 && fight_age < 510) {
        sanicz_set_pose(12);
        y = 446;
        x -= 30;
        if (fight_age == 480) {
            x = 677;
            y = 447;
        }
    } else if (fight_age >= 510 && fight_age < 540) {
        sanicz_set_pose(12);
        y = 446;
        x += 40;
        if (fight_age == 530) {
            x = -32;
        }
    } else if (fight_age >= 540 && fight_age < 600) {
        sanicz_set_pose(12);
        y = 446;
        x += 30;
    }

    if (fight_age == 610) {
        x = 714;
        y = 419;
        motion_x = -4;
        motion_y = -5;
    }
    if (fight_age >= 610 && fight_age < 800) {
        x = floor(x + motion_x);
        y = floor(y + motion_y);
        motion_y += 0.8;
        var _touching_floor = place_meeting(x, y, inst_sanicz_floor);
        if (_touching_floor && !floor_contact) {
            motion_x = -3 - irandom(3);
            motion_y = -9 - irandom(3);
        }
        floor_contact = _touching_floor;
    }

    // Groups 1145–1151 restart the first phase until its health threshold is reached.
    if (!fight_phase_two && hit_points <= phase_threshold) {
        fight_phase_two = true;
        fight_age = 801;
        x = 308;
        y = 16;
        audio_play_sound(snd_sanicz_show_you, 1, false);
    } else if (fight_age == 800) {
        fight_age = 100;
        floor_contact = false;
    }

    if (fight_age >= 810 && fight_age < 880) {
        sanicz_set_pose(13);
        y += 2;
        inst_sanicz_floor.y -= 1;
        --_player.y;
        _player.refresh_collision_probes();
        shake_strength = 15;
        sanicz_arena_burn();
    }
    if (fight_age == 920) {
        sanicz_set_pose(14);
        motion_x = irandom(14) - irandom(14);
        motion_y = -15;
    }
    if (fight_age >= 950 && fight_age < 2000) {
        // Groups 1164–1172 apply motion, orient the roll, and accelerate toward the player.
        x = floor(x + motion_x);
        y = floor(y + motion_y);
        var _angle = darctan2(x - chase_x, y - chase_y) + 90;
        image_angle = _angle - frac(_angle);
        chase_x = x;
        chase_y = y;
        sanicz_set_pose(14, -1);
        motion_x += 0.6 * sign(_player.x - x);
        motion_y += 0.8 * sign(_player.y - y);
        if ((x > 630 && motion_x > 0) || (x < 10 && motion_x < 0)) {
            motion_x = 0;
        }
        if ((y > 470 && motion_y > 0) || (y < 10 && motion_y < 0)) {
            motion_y = 0;
        }
    }

    // Groups 1178–1193 run the wind-up, orbit, dashes, and aimed rock phase.
    if ((fight_age >= 2550 && fight_age < 2620) || (fight_age >= 2800 && fight_age < 2920)) {
        x -= 35;
    }
    switch (fight_age) {
        case 2000:
            x = 590;
            y = _player.y;
            sanicz_set_pose(14, -1);
            audio_play_sound(snd_stock_select_sonic, 1, false);
            var _wind_up_angle = darctan2(x - _player.x, y - _player.y) - 90;
            image_angle = _wind_up_angle - frac(_wind_up_angle);
            break;
        case 2500:
        case 2740:
            x = 701;
            y = _player.y;
            image_angle = 0;
            sanicz_set_pose(14, -1);
            audio_play_sound(snd_sanicz_voice_13, 1, false);
            break;
        case 2620:
        case 2850:
            x = fight_age == 2620 ? -53 : -95;
            y = _player.y;
            image_angle = 0;
            sanicz_set_pose(14, 1);
            audio_play_sound(snd_sanicz_voice_13, 1, false);
            break;
        case 3000:
            audio_play_sound(snd_sanicz_show_you, 1, false);
            break;
        case 3400:
            x = 858;
            y = 540;
            break;
        case 3520:
            x = 565;
            y = 341;
            image_angle = 0;
            sanicz_set_pose(14, -1);
            break;
    }
    if (fight_age >= 2000 && fight_age < 2200) {
        image_angle = (image_angle + fight_age - 2000) mod 360;
    } else if (fight_age >= 2200 && fight_age < 2500) {
        var _orbit = scene_steps * 100;
        x = floor(_player.x + dcos(_orbit) * 80);
        y = floor(_player.y - dsin(_orbit) * 80);
        var _orbit_angle = darctan2(x - chase_x, y - chase_y) + 90;
        image_angle = _orbit_angle - frac(_orbit_angle);
        chase_x = x;
        chase_y = y;
    }
    if ((fight_age >= 2680 && fight_age < 2740) || (fight_age >= 2840 && fight_age < 3000)) {
        x += 35;
    }
    if (fight_age >= 3000 && fight_age < 3400) {
        var _ellipse = scene_steps * 10;
        x = floor(310 + dcos(_ellipse) * 270);
        y = floor(250 + dsin(_ellipse) * 260);
        var _aim = darctan2(x - _player.x, y - _player.y) - 90;
        image_angle = _aim - frac(_aim);
    }
}
