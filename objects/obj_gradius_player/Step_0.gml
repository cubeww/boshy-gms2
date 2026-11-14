++scene_steps;

var _keys = global.settings.keys;
if (!dead) {
    var _up = keyboard_check(vk_up);
    var _down = keyboard_check(vk_down);
    var _left = keyboard_check(_keys.left);
    var _right = keyboard_check(_keys.right);

    // Groups 862–868 update thrust in input order and round each vertical step.
    vertical_speed += (_down - _up) * flight_speed;
    repeat (_up + _down) {
        gradius_record_option_position();
    }
    if (_right) {
        x += 3 + flight_speed;
        gradius_record_option_position();
    }
    if (_left) {
        x -= 3 + flight_speed;
        gradius_record_option_position();
    }
    image_index = _down ? 2 : (_up ? 1 : 0);
    rider_frame = ((scene_steps * 7 - 1) div 100) mod 2;
}
y += floor(vertical_speed + 0.5);

gradius_update_options();
if (dead) {
    vertical_speed += 0.5;
    image_angle -= 2;
    x += 2;
    death_blast_ms -= 20;
    if (death_blast_ms <= 0) {
        death_blast_ms += 50;
        // Group 885 uses the same additive explosion art as Sanicz.
        if (x < room_width + 128 && y < room_height + 128) {
            instance_create_depth(x + irandom(31) - irandom(31), y + irandom(31) - irandom(31),
                depth - 1, obj_sanicz_victory_blast, {
                    image_angle: irandom(359), image_xscale: 0.4, image_yscale: 0.4
                });
        }
    }
} else {
    vertical_speed *= 0.6;
    if (keyboard_check(_keys.shoot)) {
        gradius_fire_weapons(keyboard_check_pressed(_keys.shoot));
    }
}

// Groups 975–976 nudge the ship toward the flight area without clipping its path.
if (!dead && y > 430) {
    --vertical_speed;
}
if (y < 25) {
    ++vertical_speed;
}
