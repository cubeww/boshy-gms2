attack_enabled = false;
vertical_offset = 92;
lift_steps = 0;
attack_clock = 0;
attack_lane = 0;
beam = noone;
intro_cue = -1;
laser_cue = -1;
image_speed = 0;
image_index = 0;

stop_beam = function() {
    if (instance_exists(beam)) {
        instance_destroy(beam);
    }
    beam = noone;
    image_index = 0;
};

advance_attack = function(_player, _floor_speed) {
    // G926 follows the visible bottom before G927–928 animate the emergence.
    var _bottom = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]);
    y = _bottom + vertical_offset;
    if (lift_steps > 0) {
        vertical_offset += lift_steps;
        --lift_steps;
    } else if (lift_steps < 0) {
        vertical_offset += lift_steps;
        ++lift_steps;
    }

    // G929–939 run a 50-step wait, 25-step warning and 74-step discharge.
    if (attack_enabled) {
        ++attack_clock;
        switch (attack_clock) {
            case 1:
                with (obj_desert_secret_gear) {
                    screen_y += 4;
                    image_angle += (4 - fall_speed) * 2;
                }
                break;
            case 50:
                if (_player != noone) {
                    attack_lane = _player.y < 1300 || (_player.x >= 223 && _player.x < 423)
                        ? 2 : (_player.x < 223 ? 1 : 3);
                    attack_clock = -100;
                    lift_steps -= 12;
                }
                break;
            case -75:
                if (attack_lane > 0) {
                    image_index = 1;
                    beam = instance_create_layer(x + 4, y - 62, "Hazards", obj_desert_secret_stone_beam);
                    laser_cue = audio_play_sound(snd_desert_secret_stone_laser, 1, false);
                }
                break;
            case -1:
                lift_steps += 12;
                stop_beam();
                attack_lane = 0;
                break;
        }
    }
    if (attack_lane > 0) {
        x = 124 + 208 * (attack_lane - 1);
    }

    if (instance_exists(beam)) {
        // G940 emits only once the flame reaches frame 1, using that frame's action point.
        if (beam.image_index >= 1) {
            var _segment_x = beam.x - 14;
            var _segment_y = beam.y - 94 - _floor_speed - 6;
            instance_create_layer(_segment_x, _segment_y, "Hazards", obj_desert_secret_stone_segment);
        }
        // G941 moves the beam after spawning the segment.
        beam.y -= _floor_speed;
    }
};
