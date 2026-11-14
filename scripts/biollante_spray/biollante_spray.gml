enum BiollanteSpit {
    Rising,
    Falling,
    SweepUpper,
    SweepLower
}

function biollante_spray_setup() {
    spray_interval_steps = 105;
}

function biollante_spray_step(_age, _frame_age) {
    // Group 723 evaluates Every 2.1 seconds between its lower and upper age checks.
    if (_age >= 2150 && --spray_interval_steps <= 0) {
        spray_interval_steps += 105;
        if (_age < 2600) {
            if (irandom(1) == 0) {
                instance_create_depth(100, 514, depth - 1, obj_biollante_spitter, {
                    spit_mode: BiollanteSpit.Rising
                });
            } else {
                instance_create_depth(92, -45, depth - 1, obj_biollante_spitter, {
                    spit_mode: BiollanteSpit.Falling
                });
            }
        }
    }

    if (_age == 2600) {
        instance_create_depth(656, 228, depth - 1, obj_biollante_spitter, {
            spit_mode: BiollanteSpit.SweepUpper
        });
        instance_create_depth(692, 225, depth - 1, obj_biollante_spitter, {
            spit_mode: BiollanteSpit.SweepLower
        });
    }
    var _timer = _frame_age * 20;
    var _trail_due = _frame_age > 0 && _frame_age mod 5 == 0;
    with (obj_biollante_spitter) {
        // Groups 786–791 use the room timer in milliseconds.
        var _scale = 2 + dsin(_timer div 2) * 0.5;
        image_xscale = _scale;
        image_yscale = _scale;
        switch (spit_mode) {
            case BiollanteSpit.Rising:
            case BiollanteSpit.Falling:
                var _direction = spit_mode == BiollanteSpit.Rising ? 1 : -1;
                x = floor(xstart + dsin(_timer div 6) * 32);
                image_angle = _direction * floor(90 + dsin(_timer div 3) * 32);
                if (_age == 2700) {
                    vertical_speed = 9000;
                }
                y -= _direction * vertical_speed;
                break;
            case BiollanteSpit.SweepUpper:
            case BiollanteSpit.SweepLower:
                var _sign = spit_mode == BiollanteSpit.SweepUpper ? 1 : -1;
                var _sine = dsin(_timer div 8);
                y = floor(250 + _sign * _sine * 210);
                image_angle = floor(180 - _sine * 50);
                --x;
                break;
        }

        if (_trail_due && point_in_rectangle(x, y, -32, -32, room_width + 32, room_height + 32)) {
            // Group 792 sets an unused angle value. The drawn angle starts at zero.
            instance_create_depth(x, y, depth - 1, obj_biollante_acid);
        }
        // Each path has one travel direction, so a head past its exit cannot reenter.
        if ((spit_mode == BiollanteSpit.Rising && y < -40)
            || (spit_mode == BiollanteSpit.Falling && y > room_height + 40)
            || (spit_mode >= BiollanteSpit.SweepUpper && x < -40)) {
            instance_destroy();
        }
    }
}
