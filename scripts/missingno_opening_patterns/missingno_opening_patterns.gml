function missingno_pattern_gust(_player) {
    if (fight_age == 710) {
        missingno_attack_caption("Enemy MISSINGNO. used GUST!");
        instance_create_layer(176, 561, "Hazards", obj_missingno_gust_tornado);
        audio_play_sound(snd_missingno_gust, 1, false);
    }
    if (fight_age > 730 && fight_age < 840) {
        with (obj_missingno_gust_tornado) {
            y -= 2;
        }
    }
    if (fight_age > 760 && fight_age < 1300) {
        // G756 tests the player's integer hotspot before applying a late movement update.
        if (_player != noone && floor(_player.x) > 40 && floor(_player.x) < 310
            && floor(_player.y) > 300 && floor(_player.y) < 370) {
            _player.vsp -= 1;
            _player.x -= 1;
            _player.refresh_collision_probes();
            attack_player_float = true;
            missingno_attack_kick(10, 0.5);
        }

        // G757–759 roll three independent chances in order, with one shared cooldown.
        if (fight_age < 1200 && attack_clock_f > 35) {
            var _gust_targets = [270, 300, 327];
            for (var _i = 0; _i < array_length(_gust_targets); ++_i) {
                if (irandom(2) == 0) {
                    var _sliver = instance_create_layer(x, y, "Hazards", obj_missingno_gust_sliver);
                    _sliver.target_y = _gust_targets[_i];
                    attack_clock_f = 0;
                    break;
                }
            }
        }

        // The translucent cloud starts moving on the following update in G760.
        var _fog = instance_create_layer(693, 230 + irandom(109), "Attack Effects", obj_missingno_gust_fog);
        _fog.image_index = irandom(2);
    }
    switch (fight_age) {
        case 1300:
            attack_player_float = false;
            break;
        case 1350:
            target_y = 360;
            break;
        case 1450:
            target_y = 123;
            break;
        case 1500:
            with (obj_missingno_gust_tornado) {
                instance_destroy();
            }
            break;
    }
}

function missingno_pattern_rock(_player) {
    if (fight_age == 710) {
        missingno_attack_caption("Enemy MISSINGNO. used ROCK THROW!");
    }
    if (fight_age >= 740 && fight_age < 1200 && attack_clock_f >= 45) {
        instance_create_layer(62 + irandom(229), -9, "Hazards", obj_missingno_rock);
        audio_play_sound(snd_missingno_rock_drop, 1, false);
        missingno_attack_kick(10);
        attack_clock_f = 0;
    }
    if (fight_age == 1280) {
        target_y = 360;
    } else if (fight_age == 1380) {
        target_y = 123;
    }
}

function missingno_rock_split(_level) {
    var _fragment = _level == 1 ? spr_missingno_rock_medium : spr_missingno_rock_small;
    var _launch = _level == 1 ? -18 : -15;
    for (var _direction = -1; _direction <= 1; _direction += 2) {
        var _rock = instance_create_layer(x, y - 8, "Hazards", obj_missingno_rock);
        _rock.sprite_index = _fragment;
        _rock.rock_level = _level;
        _rock.rock_hsp = _direction;
        _rock.rock_vsp = _launch;
    }
}

function missingno_opening_patterns_step() {
    // G760 moves slivers before creating the next wave of fog.
    with (obj_missingno_gust_sliver) {
        x -= 2;
        y = floor(y + (target_y - y) * 0.1);
        if (bbox_right < -32) {
            instance_destroy();
        }
    }
    with (obj_missingno_gust_fog) {
        if (gust_age++ == 0) {
            continue;
        }
        x -= 30 + irandom(29);
        y += irandom(4) - irandom(4);
        if (x < -200) {
            instance_destroy();
        }
    }

    // G1050–1055 resolve large and medium contact before moving the fragments.
    var _shook = false;
    with (obj_missingno_rock) {
        if (rock_level == 2 && rock_vsp > 0 && place_meeting(x, y, obj_missingno_arena_platform)) {
            missingno_rock_split(1);
            audio_play_sound(snd_missingno_rock_impact, 1, false);
            _shook = true;
            instance_destroy();
        }
    }
    with (obj_missingno_rock) {
        if (rock_level == 1 && rock_vsp > 0 && place_meeting(x, y, obj_missingno_arena_platform)) {
            missingno_rock_split(0);
            audio_play_sound(snd_missingno_rock_impact, 1, false);
            _shook = true;
            instance_destroy();
        }
    }
    with (obj_missingno_rock) {
        var _next_y = y + rock_vsp;
        x += rock_hsp;
        y = sign(_next_y) * floor(abs(_next_y));
        rock_vsp += 0.6;
        if (rock_level == 0 && rock_vsp > 0 && place_meeting(x, y, obj_missingno_arena_platform)) {
            audio_play_sound(snd_missingno_rock_impact, 1, false);
            _shook = true;
            instance_destroy();
        } else if (bbox_top >= room_height) {
            instance_destroy();
        }
    }
    if (_shook) {
        missingno_attack_kick(5);
    }
}
