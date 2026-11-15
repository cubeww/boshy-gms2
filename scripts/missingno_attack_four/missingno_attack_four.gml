function missingno_pattern_water(_player) {
    // G841–846 announce Hydro Pump and release water at the player's current X.
    if (fight_age == 710) {
        missingno_attack_caption("Enemy MISSINGNO. used HYDRO PUMP!");
    }
    if (fight_age >= 750 && fight_age <= 1050 && fight_age mod 100 == 50) {
        audio_play_sound(snd_missingno_hydro_pump, 1, false);
    }
    if (fight_age >= 780 && fight_age <= 1200 && attack_clock_f >= 25 && _player != noone) {
        instance_create_layer(floor(_player.x), 490, "Attack Effects", obj_missingno_water);
        attack_clock_f = 0;
    }
    if (fight_age == 1250) {
        target_y = 360;
        attack_player_float = false;
    }
    if (fight_age == 1375) {
        target_y = 123;
    }
}

function missingno_water_step(_player) {
    // G850 advances both effects even after the encounter stops spawning them.
    var _touching = false;
    var _fresh_contact = false;
    with (obj_missingno_water) {
        y = floor(y + water_vsp);
        water_vsp += 0.5;
        var _contact = _player != noone && _player.boshy_mask_meeting(id);
        _fresh_contact = _fresh_contact || (_contact && !water_contact);
        _touching = _touching || _contact;
        water_contact = _contact;
    }
    with (obj_missingno_water_splash) {
        x += splash_hsp;
        y += floor(splash_vsp);
        splash_vsp += 0.5;
        image_index = min(2, ++splash_age div 20);
        if (bbox_right < 0 || bbox_left >= room_width || bbox_bottom < 0 || bbox_top >= room_height) {
            instance_destroy();
        }
    }

    if (_touching) {
        // Event G853 resets falling speed on a new collision with each pillar.
        if (_fresh_contact && _player.vsp > 0) {
            _player.vsp = 0;
        }
        // G851–852 apply one lift to the player and emit additive droplets.
        --_player.vsp;
        attack_player_float = true;
        water_splash_wait_us -= delta_time;
        if (water_splash_wait_us <= 0) {
            water_splash_wait_us += 50000;
            instance_create_layer(floor(_player.x), floor(_player.y), "Attack Effects", obj_missingno_water_splash);
        }
    }

    with (obj_missingno_water) {
        if (water_vsp > 15) {
            instance_destroy();
        }
    }
}
