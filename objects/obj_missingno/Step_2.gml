++scene_steps;
if (timer_reset_second >= 0) {
    attempt_steps = max(0, scene_steps - timer_reset_second * 50);
}
var _player = instance_find(obj_player, 0);
var _won_this_step = hit_points <= 0 && victory_age < 0;
if (_won_this_step) {
    missingno_victory_begin(_player, attempt_steps);
}

// The viewport reads the previous shake offsets. G1018 then decrements the impulse.
camera_set_view_pos(view_camera[0], -1 + shake_x, -2 + shake_y);
attack_flash_steps = max(0, attack_flash_steps - 1);

if (victory_age >= 0) {
    if (!_won_this_step) {
        missingno_victory_step();
    }
} else if (_player != noone) {
    ++fight_age;
    if (ninja_gaiden_toggle_cd()) {
        if (global.run.ninja_gaiden_cd > 0 || fight_age >= 780) {
            start_battle_music();
        } else if (game_controller.stage_music_instance != -1) {
            audio_stop_sound(game_controller.stage_music_instance);
            game_controller.stage_music_instance = -1;
        }
    }
    if (fight_age >= 600 && fight_age < 655) {
        target_x += 10;
    }
    switch (fight_age) {
        case 610: set_read_sign("Wild MISSINGO. appeared!"); break;
        case 655: intro_cry = audio_play_sound(snd_missingno_cry, 1, false); break;
        case 677: reset_boss_timer(); break;
    }
    if (fight_age <= 649 && keyboard_check_pressed(ord("S"))) {
        x = 450;
        y = 123;
        target_x = 450;
        fight_age = 680;
        reset_boss_timer();
        missingno_intro_skip();
        missingno_attack_flash();
        intro_cry = audio_play_sound(snd_missingno_cry, 1, false);
    }
} else {
    fight_age = 0;
}
if ((fight_age >= 650 && fight_age <= 800) || hud_opacity > 0) {
    if (hud_opacity < 128) {
        hud_opacity = min(128, hud_opacity + 5);
    }
}

// G734 eases to the two target coordinates and adds the room-clock bob on Y.
x = floor(x + (target_x - x) * 0.2 + sign(target_x));
y = floor(y + (target_y - y) * 0.2 + sign(target_y) + dsin((scene_steps * 20) / 3) * 4);
missingno_pose_step();
if (victory_age < 0 && _player != noone) {
    missingno_attacks_step(_player);
}
missingno_recover_step();
missingno_opening_patterns_step();
_player = instance_find(obj_player, 0);
missingno_water_step(_player);
missingno_pattern_tri_effects_step(_player);
missingno_guard_step();

_player = instance_find(obj_player, 0);
if (_player != noone && visible && _player.boshy_mask_meeting(id) && _player.die()) {
    _player = noone;
}
if (_player == noone) {
    if (victory_age < 0) {
        game_controller.fade_stage_music();
    }
    ++death_age;
    if (death_age == 1) {
        missingno_wrap_clear(noone);
    }
    var _death_track = array_length(game_controller.death_audio) > 0 ? game_controller.death_audio[0] : -1;
    switch (death_age) {
        case 30: set_read_sign("BOSHY fainted!"); break;
        case 120:
            set_read_sign("Enemy MISSINGNO gained 69 EXP. Points!");
            audio_play_sound(snd_missingno_select, 1, false);
            break;
        case 230:
            set_read_sign("Enemy MISSINGNO grew to level 9001!");
            audio_play_sound(snd_missingno_level_up, 1, false);
            audio_play_sound(snd_missingno_select, 1, false);
            enemy_level_up = true;
            if (_death_track != -1) {
                audio_sound_gain(_death_track, 0, 0);
            }
            break;
        case 265:
            if (_death_track != -1) {
                audio_sound_gain(_death_track, 1, 0);
            }
            break;
    }
}
++read_sign_steps;
if (shake_strength > 0) {
    shake_strength = max(0, shake_strength - 1);
    var _spread = floor(shake_strength * 2);
    shake_x = _spread > 0 ? floor(-shake_strength + irandom(_spread - 1)) : 0;
    shake_y = _spread > 0 ? floor(-shake_strength + irandom(_spread - 1)) : 0;
}
blur_strength *= 0.9;
if (blur_strength < 0.05) {
    blur_strength = 0;
}
var _blur_angle = blur_strength > 0 ? irandom(359) : 0;
game_controller.directional_blur_x = lengthdir_x(blur_strength * 0.01, _blur_angle);
game_controller.directional_blur_y = lengthdir_y(blur_strength * 0.01, _blur_angle);
