function missingno_tri_spawn_flame(_amplitude, _low) {
    // G804 and G812 both create the flame at MissingNo.'s hotspot.
    instance_create_layer(x, y, "Hazards", obj_missingno_tri_flame, {
        target_height: 370 + dsin(attack_clock_f * 6) * _amplitude,
        flame_phase: irandom(359),
        low_stream: _low
    });
}

function missingno_pattern_tri(_player) {
    switch (fight_age) {
        case 710:
            missingno_attack_caption("Enemy MISSINGNO. used TRI ATTACK!");
            // G798 emits all twenty actors from the same fast loop.
            for (var _i = 0; _i < 20; ++_i) {
                instance_create_layer(x, y, "Hazards", obj_missingno_tri_orbit, {
                    orbit_angle: _i * 18,
                    orbit_radius: 640
                });
            }
            break;
        case 750:
            audio_play_sound(snd_missingno_tri_charge, 1, false);
            break;
        case 920:
            audio_play_sound(snd_tutorial_teleport, 1, false);
            audio_play_sound(snd_missingno_tri_flame, 1, false);
            missingno_attack_flash();
            attack_additive = true;
            break;
        case 1300:
            // G807 uses an absolute coordinate and scales the ice bank fourfold on both axes.
            instance_create_layer(173, 575, "Hazards", obj_missingno_tri_wall, {
                image_xscale: 4,
                image_yscale: 4
            });
            break;
        case 1324:
            if (_player != noone) {
                _player.input_locked = true;
                _player.hsp = 0;
                _player.vsp = 0;
                instance_create_layer(_player.x, _player.y, "Foreground Effects", obj_missingno_tri_freeze);
            }
            break;
        case 1360:
            with (obj_missingno_tri_wall) {
                instance_destroy();
            }
            audio_play_sound(snd_missingno_tri_flame, 1, false);
            break;
        case 1520:
            if (_player != noone) {
                _player.input_locked = false;
            }
            with (obj_missingno_tri_freeze) {
                instance_destroy();
            }
            missingno_attack_flash();
            attack_additive = false;
            break;
        case 1530:
            target_y = 360;
            break;
        case 1630:
            target_y = 123;
            break;
    }

    if (fight_age >= 930 && fight_age <= 1255) {
        if (fight_age <= 1240 && attack_clock_h < 80) {
            missingno_tri_spawn_flame(46, false);
        }
        if (attack_clock_h >= 160) {
            attack_clock_h = 0;
            audio_play_sound(snd_missingno_tri_flame, 1, false);
        }
        if (fight_age >= 1065 && attack_clock_g > 40) {
            attack_clock_g = 0;
            audio_play_sound(snd_missingno_tri_thunder, 1, false);
            instance_create_layer(x, y, "Hazards", obj_missingno_tri_thunder, {
                image_angle: 170 + irandom(69)
            });
        }
    }
    if (fight_age >= 1370 && fight_age <= 1460) {
        missingno_tri_spawn_flame(8, true);
    }
}

function missingno_pattern_tri_effects_step(_player) {
    var _boss_x = x;
    var _boss_y = y;
    with (obj_missingno_tri_orbit) {
        // G799–801 position the actors before shrinking the radius.
        x = floor(_boss_x + dcos(orbit_angle) * orbit_radius);
        y = floor(_boss_y - dsin(orbit_angle) * orbit_radius);
        ++orbit_angle;
        image_angle = (image_angle + 5) mod 360;
        if (other.attack_kind == 5 && other.fight_age >= 710) {
            orbit_radius -= other.fight_age >= 870 ? 6 : 2;
        }
        if (orbit_radius <= 0) {
            instance_destroy();
        }
    }

    with (obj_missingno_tri_flame) {
        // G814 and G816 update each flame twice horizontally in the lower stream.
        y = floor(y + dsin(flame_phase * 5) * 4 + (target_height - y) * 0.1);
        x -= low_stream ? 6 : 3;
        flame_phase += 2;
        if (bbox_right < -16) {
            instance_destroy();
        }
    }

    with (obj_missingno_tri_thunder) {
        // G1058–1059 retain fractional motion under integer draw and mask positions.
        x = floor(motion_x);
        y = floor(motion_y);
        motion_x += lengthdir_x(5, image_angle);
        motion_y += lengthdir_y(5, image_angle);
        if (bbox_right < -16 || bbox_bottom < -16 || bbox_top >= 496) {
            instance_destroy();
        }
    }

    with (obj_missingno_tri_wall) {
        if (other.fight_age >= 1300 && other.fight_age <= 1324) {
            y -= 8;
        }
        if (other.fight_age >= 1324) {
            // G810 flashes the ice at 50 ms intervals, starting hidden.
            visible = ((other.fight_age - 1324) * 20 div 50) mod 2 == 1;
        }
    }

    if (_player == noone && instance_exists(obj_missingno_tri_freeze)) {
        with (obj_missingno_tri_freeze) {
            instance_destroy();
        }
        missingno_attack_flash();
        return;
    }

    with (obj_missingno_tri_freeze) {
        // G814's coefficient is 0 for opaque and 128 for invisible.
        image_alpha = 1 - floor(60 + dsin(other.scene_steps * 10) * 50) / 128;
    }
}
