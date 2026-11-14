function missingno_attack_recover() {
    // G858–868 move MissingNo. down and stage ten shrinking orbits per pulse.
    if (fight_age == 710) {
        missingno_attack_caption("Enemy MISSINGNO. used RECOVER!");
    }
    if (fight_age >= 760 && fight_age <= 1100) {
        if (attack_clock_f > 33) {
            target_y = 260;
            for (var _index = 0; _index < 10; ++_index) {
                instance_create_depth(x, y, depth - 1, obj_missingno_recover, { recover_angle: _index * 35 });
            }
            attack_clock_f = 0;
        }
        if (attack_clock_h > 60) {
            audio_play_sound(snd_missingno_recover, 1, false);
            attack_clock_h = 0;
        }
    }
    if (fight_age == 1100) {
        target_y = 123;
    }
}

function missingno_recover_step() {
    var _center_x = x;
    var _center_y = y;
    var _wave_finished = false;
    with (obj_missingno_recover) {
        // G861 positions each dot before advancing its angle and shrinking the orbit.
        x = floor(_center_x + lengthdir_x(recover_radius, recover_angle));
        y = floor(_center_y + lengthdir_y(recover_radius, recover_angle));
        recover_angle += 5;
        recover_radius -= 3;
        if (recover_radius < 0) {
            _wave_finished = true;
            instance_destroy();
        }
    }
    // G863 removes all expired dots and credits the boss once, then G864–867 cap HP.
    if (_wave_finished && hit_points > 0) {
        hit_points = min(max_health, hit_points + 5);
        missingno_attack_flash();
    }
}

function missingno_attack_splash(_player) {
    // G872–882 feint twice before the water jets cross the arena.
    switch (fight_age) {
        case 710:
            missingno_attack_caption("Enemy MISSINGNO. used SPLASH!");
            break;
        case 800:
        case 850:
            target_y += 80;
            audio_play_sound(snd_missingno_splash, 1, false);
            break;
        case 825:
        case 875:
            target_y -= 80;
            break;
        case 900:
            missingno_attack_caption("But nothing happened!");
            break;
        case 990:
            audio_play_sound(snd_missingno_hydro_pump, 1, false);
            break;
        case 1025: target_y = 360; break;
        case 1130: target_y = 123; break;
    }
    if (fight_age >= 1000 && fight_age <= 1025 && attack_clock_f >= 5) {
        instance_create_layer(639, 467, "Hazards", obj_missingno_splash_wave);
        attack_clock_f = 0;
        missingno_attack_kick(20, 7);
    }
}

function missingno_attack_razor_leaf(_player) {
    // G887–891 release small seeds. G894 turns each seed into a lethal aimed leaf.
    switch (fight_age) {
        case 710:
            missingno_attack_caption("Enemy MISSINGNO. used RAZOR LEAF!");
            break;
        case 1050: target_y = 360; break;
        case 1120: target_y = 123; break;
    }
    if (fight_age >= 800 && fight_age < 965 && attack_clock_f >= 7) {
        audio_play_sound(snd_missingno_splash, 1, false);
        instance_create_layer(x, y, "Hazards", obj_missingno_leaf_seed, {
            seed_hsp: irandom(7) - irandom(7),
            seed_vsp: -10 - irandom(4)
        });
        attack_clock_f = 0;
    }
}
