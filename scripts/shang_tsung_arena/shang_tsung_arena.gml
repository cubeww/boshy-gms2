function shang_tsung_flash() {
    with (obj_shang_tsung_flash) {
        transparency = 0;
    }
}

function shang_tsung_drop_floor() {
    // G708–710 remove the bridge and its pillars, then create the two rising platforms.
    with (obj_shang_tsung_platform) {
        instance_destroy();
    }
    with (obj_shang_tsung_pillar) {
        instance_destroy();
    }
    var _layer = layer_get_id("Platforms");
    var _heights = [888, 1155];
    for (var _i = 0; _i < array_length(_heights); ++_i) {
        instance_create_layer(100, _heights[_i], _layer, obj_shang_tsung_platform, {
            sprite_index: spr_shang_tsung_rising_platform,
            travel_x: 0,
            travel_y: -1,
            is_bridge: false
        });
    }
}

function shang_tsung_arena_step(_player, _scrolling) {
    if (_player != noone) {
        // G733 recycles the lift before G928 tests the Down probe.
        if (_player.y > 470) {
            with (obj_shang_tsung_platform) {
                if (!is_bridge && y < 495) {
                    x = 100;
                    y = 980;
                }
            }
        }
        var _count = instance_number(obj_shang_tsung_platform);
        for (var _i = 0; _i < _count; ++_i) {
            var _platform = instance_find(obj_shang_tsung_platform, _i);
            if (_player.probe_overlaps(_player.down_probe, _platform)) {
                _player.x += _platform.rider_delta_x;
                _player.y += _platform.rider_delta_y;
                _player.air_jump_available = true;
                _player.refresh_collision_probes();
                break;
            }
        }
    }

    with (obj_shang_tsung_platform) {
        if (_scrolling) {
            // G930 samples the previous move before applying the next one.
            rider_delta_x = x - rider_previous_x;
            rider_delta_y = y - rider_previous_y;
            rider_previous_x = x;
            rider_previous_y = y;
            x += travel_x;
            y += travel_y;
        }
        if (x < (is_bridge ? -400 : -30)) {
            x = 640;
        }
    }

    if (_scrolling) {
        with (obj_shang_tsung_pillar) {
            x -= 2;
            if (x < -400) {
                x = 640;
            }
        }
    }

    // G946–951 scroll independent strips at 3, 2 and 1 pixels per step.
    with (obj_shang_tsung_sky) {
        if (scroll_speed != 0) {
            if (x <= wrap_left) {
                x = wrap_right;
            }
            x += scroll_speed;
        }
    }

    // G943 raises the transparency by ten units until the flash is gone.
    with (obj_shang_tsung_flash) {
        transparency = min(128, transparency + 10);
    }
}
