++scene_steps;
var _player = instance_find(obj_player, 0);
if (_player == noone) {
    mario_projectile_animations_step();
    game_controller.fade_stage_music();
}

if (!defeated) {
    ++fight_age;
    ++spawn_counter;
    var _skip_intro = false;
    if (fight_age < 300 && keyboard_check_pressed(ord("S"))) {
        // Group 707 seeks the theme while skipping the Koopa introduction.
        fight_age = 400;
        _skip_intro = true;
        x = 455;
        y = 413;
        shake_strength = 10;
        if (instance_exists(intro_koopa)) {
            instance_destroy(intro_koopa);
        }
        audio_play_sound(snd_mario_here_i_come, 1, false);
        if (game_controller.stage_music_instance != -1) {
            audio_sound_set_track_position(game_controller.stage_music_instance, 8);
        }
    }
    if (fight_age == 400) {
        // G698 and G707 reset the timer on the room's existing one-second pulse.
        attempt_start_second = game_controller.frame_seconds;
    }
    if (sprite_index == spr_mario_run || sprite_index == spr_mario_run_left) {
        // Fusion uses the midpoint of the 1–51 speed range for this static movement.
        image_index = (image_index + 0.26) mod image_number;
    }
    if (!_skip_intro) {
        mario_attacks_step(_player);
    }
} else {
    ++victory_age;
    if (victory_age >= 30 && victory_age < 150) {
        y = floor(y + vertical_speed);
        vertical_speed += 0.2;
    }
    if (victory_age == 150) {
        sprite_index = -1;
    }
    if (instance_exists(exit_pipe) && mario_victory_complete) {
        if (_player != noone && exit_age < 0 && !_player.input_locked && _player.boshy_mask_meeting(exit_pipe)) {
            exit_age = 0;
            _player.input_locked = true;
            _player.visible = false;
            audio_play_sound(snd_mario_pipe, 1, false);
        }
        if (exit_age >= 0 && ++exit_age >= 50) {
            // Group 783 continues at the opening of VVVVVV.
            if (!teleporter_rush_exit()) {
                global.run.boss_entry_seconds = game_controller.frame_seconds - attempt_start_second;
                room_goto(rm_vvvvvv);
            }
            exit;
        }
    }
    mario_victory_step();
    if (instance_exists(exit_pipe) && mario_victory_complete && exit_pipe.x > 604) {
        exit_pipe.x -= 2;
        exit_pipe.depth = depth - 2;
    }
}
mario_projectiles_step(_player);

for (var _i = array_length(mario_trails) - 1; _i >= 0; --_i) {
    if (scene_steps - mario_trails[_i].birth >= 20) {
        array_delete(mario_trails, _i, 1);
    }
}
if (hit_flash_age >= 0 && ++hit_flash_age >= 10) {
    hit_flash_age = -1;
}
if (trophy_index < array_length(trophy_titles)) {
    if (trophy_steps == 0) {
        audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
        audio_play_sound(snd_tutorial_achievement_success, 1, false);
    }
    if (++trophy_steps >= 226) {
        ++trophy_index;
        trophy_steps = 0;
    }
}

var _camera = view_camera[0];
var _shake_x = 0;
var _shake_y = 0;
if (shake_strength > 0) {
    --shake_strength;
    if (shake_strength > 0) {
        _shake_x = irandom_range(-shake_strength, shake_strength - 1);
        _shake_y = irandom_range(-shake_strength, shake_strength - 1);
    }
}
camera_set_view_pos(_camera, _shake_x, _shake_y);
blur_strength *= 0.9;
if (blur_strength < 0.05) {
    blur_strength = 0;
}
var _blur_angle = blur_strength > 0 ? irandom(359) : 0;
game_controller.directional_blur_x = dcos(_blur_angle) * blur_strength * 0.01;
game_controller.directional_blur_y = dsin(_blur_angle) * blur_strength * 0.01;
