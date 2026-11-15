// Player contact is checked before the boss moves this step, like G46.
var _player = instance_find(obj_player, 0);
if (_player != noone && victory_age < 260 && _player.boshy_mask_meeting(id) && _player.die()) {
    _player = noone;
}

// G641 crops with the shake values calculated at the end of the previous step.
game_controller.scene_shake_x = shake_x;
game_controller.scene_shake_y = shake_y;
++scene_steps;
if (_player == noone) {
    game_controller.fade_stage_music();
}

if (victory_age < 0 && hit_points > 0) {
    // G679 pauses the script while the three sets of Robot Masters are alive.
    if (fight_age != 551 && fight_age != 751 && fight_age != 1501) {
        ++fight_age;
    }
    if (fight_age < 150 && keyboard_check(global.settings.keys.skip)) {
        fight_age = 149;
        intro_cover = 128;
    }

    switch (fight_age) {
        case 150:
            if (_player != noone) {
                x = _player.x;
            }
            y = -40;
            // G681 resets the displayed seconds while G588 keeps its room-wide pulse.
            timer_reset_second = game_controller.frame_seconds;
            audio_play_sound(snd_mega_man_teleport, 1, false);
            break;

        case 174:
            mega_man_set_pose(0, 1);
            break;

        case 200:
        case 230:
        case 260:
        case 290:
            // G688–689 use the original action point rather than the hotspot of the idle pose.
            var _staggered = fight_age == 230 || fight_age == 290;
            for (var _i = 0; _i < 36; ++_i) {
                var _angle = _staggered ? 5 - _i * 10 : _i * 10;
                mega_man_spawn_shot(MegaManHazard.Buster, x, y - 1, _angle, 2);
            }
            audio_play_sound(snd_mega_man_shoot, 1, false);
            break;

        case 310:
            audio_play_sound(snd_mega_man_teleport, 1, false);
            break;

        case 800:
            x = 673;
            y = 438;
            mega_man_set_pose(14, -1);
            audio_play_sound(snd_mega_man_run, 1, false);
            break;

        case 880:
            x = 316;
            y = -44;
            break;
    }

    if (fight_age >= 150 && fight_age < 174) {
        mega_man_set_pose(3, 1);
        y += 20;
    } else if (fight_age >= 310 && fight_age < 400) {
        mega_man_set_pose(3, 1);
        y -= 20;
    } else if (fight_age >= 630 && fight_age < 750) {
        mega_man_set_pose(13, facing);
        x += 10;
        y = floor(80 + dsin(game_controller.frame_elapsed_us div 3000) * 20);
    } else if (fight_age >= 850 && fight_age < 880) {
        x -= 10;
        fight_age -= 0.5;
    } else if (fight_age >= 881 && fight_age < 1150) {
        if (++spiral_sound_steps == 5) {
            spiral_sound_steps = 0;
            audio_play_sound(snd_mega_man_shoot, 1, false);
        }
        mega_man_set_pose(0, facing);
        y += 2;
        spiral_angle = (spiral_angle + 31) mod 360;
        image_angle = spiral_angle;
        mega_man_spawn_shot(MegaManHazard.Buster, x, y, spiral_angle, 1);
    }
}
var _previous_age = fight_age;
mega_man_attacks_step(_player);
if (_previous_age < 552 && fight_age == 552) {
    // G704 prepares the next entrance in the same pass as the first robot's defeat.
    x = -53;
    y = 73;
}
if (victory_age < 0 && hit_points > 0 && final_form) {
    --x;
    mega_man_clear_diving_sparks();
}
if (victory_age < 0 && hit_points <= 0) {
    mega_man_victory_begin(game_controller.frame_seconds - timer_reset_second);
}
if (victory_age >= 0) {
    mega_man_victory_step();
}

if (pose_animation == 15 && ++pose_clock > 4) {
    pose_clock -= 4;
    image_index = 1 - image_index;
}
if (hit_flash_age > 0 && ++hit_flash_age >= 10) {
    hit_flash_age = 0;
}
intro_cover = max(0, intro_cover - 10);

if (shake_strength > 0) {
    --shake_strength;
    shake_x = shake_strength ? irandom_range(-shake_strength, shake_strength - 1) : 0;
    shake_y = shake_strength ? irandom_range(-shake_strength, shake_strength - 1) : 0;
}
blur_strength *= 0.9;
if (blur_strength < 0.001) {
    blur_strength = 0;
}
if (blur_strength == 0) {
    game_controller.directional_blur_x = 0;
    game_controller.directional_blur_y = 0;
} else {
    var _angle = blur_angle == 0 ? irandom(359) : blur_angle;
    game_controller.directional_blur_x = dcos(_angle) * blur_strength * 0.01;
    game_controller.directional_blur_y = dsin(_angle) * blur_strength * 0.01;
}
