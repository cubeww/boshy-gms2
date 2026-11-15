++scene_steps;
var _player = instance_find(obj_player, 0);
if (_player == noone) {
    game_controller.fade_stage_music();
}
if (!victory_hide_boss) {
    biollante_advance_pose();
}
if (rotation_step == 0) {
    view_rotation = rotation_target;
}
game_controller.screen_rotation = view_rotation;
view_rotation = (view_rotation + rotation_step) mod 360;

if (victory_age < 0) {
    ++fight_age;
    if (fight_age == 150) {
        audio_play_sound(snd_biollante_roar, 1, false);
    }
    if (fight_age == 250 && !game_controller.stage_music_is_playing()) {
        biollante_start_music();
    }
    if (fight_age >= 300 && fight_age < 700) {
        --y;
    }
    if (fight_age == 800) {
        biollante_set_pose(spr_biollante_anim_14_left);
    }
    if (fight_age < 830 && keyboard_check_pressed(global.settings.keys.skip)) {
        // Groups 697–698 restart the theme and skip to the raised pose.
        biollante_start_music();
        y = 346;
        fight_age = 830;
        biollante_set_pose(spr_biollante_anim_14_left);
        intro_flash_steps = 13;
    }
    if (fight_age == 830) {
        timer_reset_second = game_controller.frame_seconds;
    }
    if (fight_age == 830 || fight_age == 1500) {
        audio_play_sound(snd_biollante_roar, 1, false);
    }
    if (fight_age == 860) {
        shake_strength = 50;
        blur_strength = 35;
    }
    if (fight_age == 1300) {
        audio_play_sound(snd_biollante_roar, 1, false);
        biollante_set_pose(spr_biollante_anim_14_left);
    }
    if (fight_age == 1480 || (fight_age > 1480 && fight_age < 1780 && shield_reaction == 0)) {
        biollante_set_pose(spr_biollante_anim_13_left);
    }
    if (fight_age == 1800) {
        biollante_set_pose(spr_biollante_idle_left);
    }
    if ((fight_age == 2700 || fight_age == 2850) && _player != noone) {
        // Groups 729 and 735 aim the left-facing body by ATan2 of the source coordinate deltas.
        var _aim = darctan2(x - _player.x, y - _player.y) - 90;
        image_angle = _aim - frac(_aim);
    }
    if (fight_age >= 2750 && fight_age < 2773) {
        x -= fight_age - 2749;
    } else if (fight_age >= 2775 && fight_age < 2800) {
        x += fight_age - 2774;
    } else if (fight_age >= 2900 && fight_age < 2924) {
        x -= fight_age - 2899;
    } else if (fight_age >= 2933 && fight_age < 2952) {
        x += fight_age - 2932;
    }
    if (fight_age == 2760 || fight_age == 2910) {
        biollante_set_pose(spr_biollante_anim_12_left);
        audio_play_sound(snd_biollante_roar_alt, 1, false);
        shake_strength = 30;
        blur_strength = 8;
    }
    var _tracking = (fight_age >= 2750 && fight_age < 2775) || (fight_age >= 2900 && fight_age < 2933);
    if (_tracking && _player != noone) {
        // The second Fusion event compares the Y coordinate after the first move.
        if (y > _player.y) {
            y -= 5;
        }
        if (y < _player.y) {
            y += 5;
        }
    }

    if (fight_age >= 2960) {
        y += sign(346 - y);
        x += sign(506 - x);
    }
    if (fight_age == 3300) {
        // Group 745's second condition branch resets the fight regardless of position.
        fight_age = 830;
        x = 506;
        y = 346;
        image_angle = 0;
        biollante_set_pose(spr_biollante_anim_14_left);
        audio_play_sound(snd_biollante_roar, 1, false);
    }
    biollante_attacks_step(_player, fight_age, scene_steps, shield_reaction);
    if (shield_reaction > 0) {
        shield_reaction = shield_reaction == 180 ? 0 : shield_reaction + 1;
    }
    // Groups 647–648 display the accumulator before groups 747–750 change the rotation mode.
    if (fight_age == 1500 || fight_age == 1700) {
        rotation_step = 5;
    } else if (fight_age == 1536 || fight_age == 1736) {
        rotation_step = 0;
        rotation_target = fight_age == 1536 ? 180 : 0;
    }
} else {
    // Group 712 still attaches disappearing beams during the victory sequence.
    biollante_beams_step(-1, 0);
    biollante_victory_step(_player);
    if (victory_hide_boss) {
        sprite_index = -1;
    }
}

if (hit_flash_age >= 0 && ++hit_flash_age > 10) {
    hit_flash_age = -1;
}
if (intro_flash_steps > 0) {
    --intro_flash_steps;
}

// Groups 645–646 use the previous shake offsets and omit them while zoomed in.
if (_player != noone) {
    var _camera = view_camera[0];
    var _width = round(view_width / 4) * 4;
    var _height = _width * 3 / 4;
    var _zoomed = victory_age >= 0 && victory_zoom_width < 640;
    var _offset_x = _zoomed ? 0 : shake_x;
    var _offset_y = _zoomed ? 0 : shake_y;
    camera_set_view_size(_camera, _width, _height);
    camera_set_view_pos(_camera, round(view_center_x - _width / 2 + _offset_x),
        round(view_center_y - _height / 2 + _offset_y));
}
// Group 902 leaves the stored offsets alone when a beam sets the strength below zero.
if (shake_strength > 0) {
    --shake_strength;
    shake_x = shake_strength > 0 ? irandom_range(-shake_strength, shake_strength - 1) : 0;
    shake_y = shake_strength > 0 ? irandom_range(-shake_strength, shake_strength - 1) : 0;
}
blur_strength *= 0.9;
if (blur_strength < 0.05) {
    blur_strength = 0;
}
var _blur_angle = blur_strength > 0 ? irandom(359) : 0;
game_controller.directional_blur_x = dcos(_blur_angle) * blur_strength * 0.01;
game_controller.directional_blur_y = dsin(_blur_angle) * blur_strength * 0.01;
