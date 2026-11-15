enum WowHazard {
    Tauren,
    Guard,
    Rock
}

function wow_mulgore_hazards_step(_player) {
    // G1057–1058 force an animation frame after moving the Tauren.
    with (obj_wow_tauren) {
        x -= travel_speed;
        image_index = min(++animation_step, image_number - 1);
        if (animation_step > 25) {
            animation_step = 0;
        }
        if (bbox_right < 0) {
            instance_destroy();
        }
    }

    // G1059–1060 count time in this Y band and spawn at Active 11's hotspot.
    if (_player != noone && !_player.dead && _player.y > 1280 && _player.y < 1920) {
        with (obj_wow_hazard_emitter) {
            if (hazard_kind == WowHazard.Tauren && ++spawn_steps == 85) {
                spawn_steps = 0;
                instance_create_layer(x, y, "Hazards", obj_wow_tauren, {
                    travel_speed: irandom_range(2, 9),
                    animation_step: irandom(23)
                });
            }
        }
    }
}

function wow_stormwind_hazards_step(_player) {
    with (obj_wow_guard) {
        // G1064–1067 charge forward with a lethal interval near the hallway floor.
        if (y >= 1682) {
            y -= rise_speed;
            image_xscale -= 0.01;
        }
        if (y < 1682) {
            --y;
        }
        image_yscale = image_xscale;
        if (y >= 1674 && y <= 1750 && _player != noone && instance_exists(_player)
            && _player.boshy_mask_meeting(id) && _player.die()) {
            _player = noone;
        }

        // G1068–1070 send guards behind the player as they converge on the doorway.
        if (y < 1682) {
            if (x != 984) {
                layer = layer_get_id("HazardsBehindPlayer");
                if (x < 984) {
                    x = floor(x + max((984 - x) * 0.025, 2));
                }
                if (x > 984) {
                    x = floor(x + min((984 - x) * 0.025, -2));
                }
            }
            image_xscale = max(0, image_xscale - 0.01);
            image_yscale = image_xscale;
            if (image_xscale == 0) {
                instance_destroy();
            }
        }
    }

    if (_player != noone && !_player.dead) {
        var _player_x = _player.x;
        var _player_y = _player.y;
        // Fusion's Number in Zone test excludes each zone's right and bottom edges.
        var _in_hall = _player_x >= 641 && _player_x < 1336 && _player_y >= 1492 && _player_y < 1755;
        var _in_stairs = _player_x >= -7 && _player_x < 637 && _player_y >= 1501 && _player_y < 1872;
        with (obj_wow_hazard_emitter) {
            if (hazard_kind == WowHazard.Guard && _in_hall) {
                if (++spawn_steps == 15) {
                    spawn_steps = 0;
                    // G1072 uses two independent Random(320) draws around X 997.
                    instance_create_layer(997 + irandom(319) - irandom(319), 2029,
                        "Hazards", obj_wow_guard);
                }
                if (!hall_marker_created) {
                    hall_marker_created = true;
                    instance_create_layer(607, 1431, "Triggers", obj_wow_jump_marker);
                }
            }
        }

        // G1074–1075 set the launch strength for both jumps on marker contact.
        with (obj_wow_jump_marker) {
            var _overlaps = jump_strength >= 0 && _player.boshy_mask_meeting(id);
            if (_overlaps && !player_touching) {
                _player.wow_jump_speed = jump_strength;
            }
            player_touching = _overlaps;
        }

        if (_in_stairs) {
            with (obj_wow_hazard_emitter) {
                if (hazard_kind == WowHazard.Rock && ++spawn_steps == 40) {
                    spawn_steps = 0;
                    instance_create_layer(x, y, "Hazards", obj_wow_rock, {
                        drift_speed: irandom_range(1, 3)
                    });
                }
            }
        }
    }

    // G1078–1079 move and rotate the rocks, then bounce on a new backdrop collision.
    with (obj_wow_rock) {
        y = floor(y + vertical_speed);
        vertical_speed += 0.2;
        x -= drift_speed;
        image_angle += drift_speed * 3;
        var _overlaps = place_meeting(x, y, obj_player_backdrop);
        if (_overlaps && !backdrop_touching) {
            vertical_speed = -4 - irandom(1);
        }
        backdrop_touching = _overlaps;
        if (bbox_right < 0 || bbox_top >= room_height) {
            instance_destroy();
        }
    }
}
