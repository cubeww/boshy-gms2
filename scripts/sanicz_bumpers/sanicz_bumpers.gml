function sanicz_bumpers_setup() {
    bumper_spawn_steps = 15;
}

function sanicz_bumpers_spawn() {
    // Group 1130 keeps the 300 ms timer running while the age is at least 160.
    if (fight_age < 160) {
        return;
    }
    if (--bumper_spawn_steps == 0) {
        bumper_spawn_steps = 15;
        if (fight_age < 330) {
            var _bumper = instance_create_depth(x, y, depth - 1, obj_sanicz_bumper);
            _bumper.velocity_x = irandom(4) - irandom(4);
            _bumper.velocity_y = 1;
        }
    }
}

function sanicz_bumpers_step(_player) {
    with (obj_sanicz_bumper) {
        if (sprite_index == spr_sanicz_bumper_bounce) {
            animation_counter += 80;
            if (animation_counter > 100) {
                animation_counter -= 100;
                ++image_index;
                if (image_index >= image_number) {
                    sprite_index = spr_sanicz_bumper;
                    image_index = 0;
                }
            }
        }

        // Group 1226 applies the lift on initial contact and restores the air jump.
        var _touching_player = _player != noone && !_player.input_locked && _player.boshy_mask_meeting(id);
        if (_touching_player && !player_contact) {
            if (sprite_index != spr_sanicz_bumper_bounce) {
                sprite_index = spr_sanicz_bumper_bounce;
                image_index = 0;
                animation_counter = 0;
            }
            _player.vsp = -70;
            _player.grounded = false;
            _player.air_jump_available = true;
            _player.jump_cut_enabled = false;
            audio_play_sound(snd_stock_sonic_jump, 1, false);
        }
        player_contact = _touching_player;

        // Groups 1227–1231 update the integer coordinates before testing the floor and edges.
        y = floor(y + velocity_y);
        x += velocity_x;
        velocity_y += 0.5;
        ++age;
        image_angle -= velocity_x;
        var _touching_backdrop = y > 400 && place_meeting(x, y, obj_player_backdrop);
        if (_touching_backdrop && !backdrop_contact) {
            velocity_y *= -0.7;
            image_angle = 0;
        }
        backdrop_contact = _touching_backdrop;
        if (age > 150 + irandom(49)) {
            instance_destroy();
        } else if ((x < 0 && velocity_x < 0) || (x >= 640 && velocity_x > 0)) {
            velocity_x = -velocity_x;
        }
    }
}
