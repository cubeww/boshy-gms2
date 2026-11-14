function missingno_attacks_setup() {
    attack_kind = 0;
    previous_attack = 0;
    pending_attack = 0;
    attack_clock_f = 0;
    attack_clock_g = 0;
    attack_clock_h = 0;
    attack_player_float = false;
    attack_player_confused = false;
    attack_additive = false;
    attack_flash_steps = 0;
}

function missingno_attack_caption(_text) {
    set_read_sign(_text);
}

function missingno_attack_kick(_shake, _blur = 0) {
    shake_strength = _shake;
    if (_blur > 0) {
        // All attacks leave the angle at its authored zero, so G1130 rolls it every step.
        set_screen_blur(_blur);
    }
}

function missingno_attack_flash() {
    attack_flash_steps = 12;
}

function missingno_pattern_beam(_player) {
    // G743–751 and G896–898 charge, fire once, then sweep down and return.
    switch (fight_age) {
        case 710:
            instance_create_layer(x, y, "Hazards", obj_missingno_beam_charge, { charge_boss: id });
            missingno_attack_caption("Enemy MISSINGNO. is charging its lazor!");
            break;
        case 850:
            // Fusion stores the beam's position at the boss hotspot, then locks it to target Y.
            var _angle = darctan2(_player.x - x, _player.y - target_y) + 55;
            _angle = sign(_angle) * floor(abs(_angle));
            instance_create_layer(x, target_y, "Hazards", obj_missingno_hyper_beam, { image_angle: _angle });
            audio_play_sound(snd_missingno_hyper_beam, 1, false);
            missingno_attack_caption("Enemy MISSINGNO. used HYPER BEAM!");
            missingno_attack_kick(50, 10);
            break;
        case 950:
            target_y = 360;
            break;
        case 1020:
            target_y = 123;
            break;
    }
    if (fight_age > 710 && fight_age < 830) {
        // The two authored Random(360) calls are independent.
        instance_create_layer(floor(x - dcos(irandom(359)) * 150), floor(y + dsin(irandom(359)) * 150),
            "Hazards", obj_missingno_beam_particle, { particle_boss: id });
    }
}

function missingno_pattern_confusion(_player) {
    // G777–793 reverse controls, orbit stars over Boshy, then fire three sand rocks per burst.
    switch (fight_age) {
        case 710:
            missingno_attack_caption("Enemy MISSINGNO. used CONFUSION!");
            break;
        case 730:
            audio_play_sound(snd_missingno_confusion, 1, false);
            // Fall through to the same shake and flash as the later pulses.
        case 745:
        case 780:
            missingno_attack_kick(15, 2);
            missingno_attack_flash();
            break;
        case 800:
            attack_player_confused = true;
            for (var _phase = 0; _phase < 360; _phase += 120) {
                var _angle = _phase * 5;
                instance_create_layer(floor(_player.x + dcos(_angle) * 32), floor(_player.y - 32 - dsin(_angle) * 8),
                    "Hazards", obj_missingno_confusion_orbit, { orbit_phase: _phase + 1 });
            }
            break;
        case 850:
            missingno_attack_caption("Enemy MISSINGNO. used SAND ATTACK!");
            break;
        case 1150:
            attack_player_confused = false;
            with (obj_missingno_confusion_orbit) {
                instance_destroy();
            }
            missingno_attack_caption("BOSHY's CONFUSION wears off!");
            break;
        case 1180:
            target_y = 360;
            break;
        case 1280:
            target_y = 123;
            break;
    }
    if (fight_age >= 880 && fight_age <= 1100 && attack_clock_f > 25) {
        var _sand_y = y + 32;
        var _angle = darctan2(x - _player.x, _sand_y - _player.y) + 90 + irandom(29) - irandom(29);
        _angle = sign(_angle) * floor(abs(_angle));
        instance_create_layer(x, _sand_y, "Hazards", obj_missingno_sand_burst, { image_angle: _angle });
        audio_play_sound(snd_missingno_sand_attack, 1, false);
        attack_clock_f = 0;
    }
}

function missingno_attacks_step(_player) {
    // G705 and G740–741 keep clocks between patterns and roll once per step until the choice differs.
    ++attack_clock_f;
    ++attack_clock_g;
    ++attack_clock_h;
    if (pending_attack == previous_attack) {
        pending_attack = irandom_range(1, 10);
    }
    if (fight_age == 700) {
        attack_kind = pending_attack;
        previous_attack = pending_attack;
    }

    var _end = 0;
    switch (attack_kind) {
        case 1: missingno_pattern_beam(_player); _end = 1050; break;
        case 2: missingno_pattern_gust(_player); _end = 1500; break;
        case 3: missingno_pattern_rock(_player); _end = 1410; break;
        case 4: missingno_pattern_confusion(_player); _end = 1320; break;
        case 5: missingno_pattern_tri(_player); _end = 1655; break;
        case 6: missingno_pattern_wrap(_player); _end = 1720; break;
        case 7: missingno_pattern_water(_player); _end = 1420; break;
        case 8: missingno_attack_recover(); _end = 1130; break;
        case 9: missingno_attack_splash(_player); _end = 1170; break;
        case 10: missingno_attack_razor_leaf(_player); _end = 1180; break;
    }
    if (_end > 0 && fight_age == _end) {
        fight_age = 680;
    }
}

function missingno_attacks_clear() {
    // G713 only removes these persistent attack objects. The emitted projectiles continue.
    var _player = instance_find(obj_player, 0);
    if (_player != noone && instance_exists(obj_missingno_tri_freeze)) {
        _player.input_locked = false;
    }
    with (obj_missingno_beam_charge) instance_destroy();
    with (obj_missingno_recover) instance_destroy();
    with (obj_missingno_tri_freeze) instance_destroy();
    with (obj_missingno_tri_wall) instance_destroy();
    with (obj_missingno_tri_orbit) instance_destroy();
    missingno_wrap_clear(_player);

    // The pending exit keeps the player in the arena after the scene.
    attack_player_confused = false;
    attack_player_float = false;
    attack_additive = false;
    with (obj_missingno_confusion_orbit) instance_destroy();
}
