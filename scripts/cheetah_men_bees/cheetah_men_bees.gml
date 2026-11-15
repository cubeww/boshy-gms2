function cheetah_men_spawn_bee(_x, _y) {
    // G1158 creates the bee at the second Cheetah's hotspot.
    return instance_create_layer(_x, _y, "Hazards", obj_cheetah_men_bee);
}

function cheetah_men_bees_step(_player) {
    with (obj_cheetah_men_bee) {
        // G1254–1255 retain fractional travel separately from the integer hotspot.
        x = floor(flight_x);
        y = floor(flight_y);
        flight_y += flight_vsp;
        flight_x += flight_hsp;
        ++flight_steps;

        // G1256–1263 accelerate toward the player, then gently correct over the speed limit.
        if (_player != noone && instance_exists(_player)) {
            if (x != _player.x) {
                flight_hsp += sign(_player.x - x) * (10 + irandom(9)) * 0.01;
            }
            if (y != _player.y) {
                flight_vsp += sign(_player.y - y) * (10 + irandom(9)) * 0.01;
            }
        }
        if (abs(flight_hsp) > 7.5) {
            flight_hsp -= sign(flight_hsp) * 0.1;
        }
        if (abs(flight_vsp) > 7.5) {
            flight_vsp -= sign(flight_vsp) * 0.1;
        }

        // G1264–1266 set the logical direction. The only clip is direction 0.
        if (y > room_height && flight_vsp > 0) {
            flight_vsp = 0;
        }

        if (flight_steps >= 200) {
            cheetah_men_spawn(CheetahMenAttack.Explosion, x, y);
            instance_destroy();
        }
    }
}
