function biollante_attacks_create() {
    // Each 300 ms condition runs only while its own beam pattern is active.
    beam_shake_steps = 15;
    beam_counter_steps = 15;
    biollante_spray_setup();
}

function biollante_attacks_step(_player, _age, _frame_age, _reaction) {
    biollante_vines_step(_age, _reaction);
    biollante_beams_step(_age, _reaction);
    biollante_suction_step(_player, _age, _frame_age);
    biollante_spray_step(_age, _frame_age);
}

function biollante_attacks_clear() {
    with (obj_biollante_vine) {
        instance_destroy();
    }
    with (obj_biollante_suction) {
        instance_destroy();
    }
    with (obj_biollante_spitter) {
        instance_destroy();
    }
    with (obj_biollante_beam) {
        // Group 756 starts the beam's Disappearing animation and clears its collision.
        begin_fade();
    }
}

function biollante_beams_step(_age, _reaction) {
    var _mouth = biollante_mouth();
    var _sweeping = _age >= 1320 && _age < 1480;
    var _countering = _reaction >= 20 && _reaction < 180;
    var _new_beam = noone;
    // The create records use the boss's current action point.
    if (_age == 1320 || _reaction == 20) {
        _new_beam = instance_create_depth(_mouth.x, _mouth.y, -81, obj_biollante_beam, { image_angle: 300 });
    }

    var _sweep_pulse = _sweeping && --beam_shake_steps == 0;
    if (_sweep_pulse) {
        beam_shake_steps = 15;
        shake_strength = 15;
        blur_strength = 0.5;
    }

    var _turn = (_sweeping ? 1 : 0) + (_sweep_pulse ? 1 : 0) + (_countering ? 1 : 0);
    with (obj_biollante_beam) {
        // Groups 710, 712 and 717 move the beam origin and aim without stretching the sprite.
        x = _mouth.x;
        y = _mouth.y;
        // Each active event adds one degree before the animation changes state.
        image_angle = (image_angle + _turn) mod 360;
        if (!fading && id != _new_beam) {
            beam_age += 1;
            var _appear_frame = ((beam_age + 1) * 80 - 1) div 100;
            if (_appear_frame < 40) {
                // Appear has ten frames, then repeats from frame five six more times.
                appear_frame = _appear_frame < 10 ? _appear_frame : 5 + (_appear_frame - 10) mod 5;
            } else if (beam_age < 79) {
                if (sprite_index != spr_biollante_beam_charge) {
                    // Group 784 moves the firing beam onto the player's collision layer.
                    sprite_index = spr_biollante_beam_charge;
                    depth = other.depth - 1;
                    audio_play_sound(snd_hello_kitty_laser, 1, false, 0.4);
                }
                // Fusion keeps frame zero until the Stopped animation counter exceeds 100.
                image_index = max(0, beam_age - 51) mod 3;
                // Group 782 sets the shaker to Counter - 10. Counter stays at zero.
                other.shake_strength = -10;
                other.blur_strength = 2;
            } else {
                begin_fade();
            }
        }
    }

    // Group 755 adds another degree every 300 ms during a counterattack.
    if (_countering && --beam_counter_steps == 0) {
        beam_counter_steps = 15;
        with (obj_biollante_beam) {
            image_angle = (image_angle + 1) mod 360;
        }
    }
}

function biollante_suction_step(_player, _age, _frame_age) {
    var _ring = inst_biollante_suction;
    // Groups 719–722 set the orbit center at the mouth and grow the ring.
    if (_age == 1800) {
        _ring.image_xscale = 0.1;
        _ring.image_yscale = 0.1;
    }
    if (_age >= 1800 && _age < 2150) {
        var _mouth = biollante_mouth();
        _ring.orbit_x = _mouth.x;
        _ring.orbit_y = _mouth.y;
        if (_age < 1820) {
            _ring.image_xscale += 0.05;
            _ring.image_yscale = _ring.image_xscale;
        }
    } else if (_age == 2150) {
        _ring.orbit_x = 900;
    }

    // Groups 776–779 still update the ring and check the pull while it is parked offscreen.
    _ring.orbit_angle = (_ring.orbit_angle + 5) mod 360;
    _ring.x = floor(_ring.orbit_x + dcos(_ring.orbit_angle) * 10);
    _ring.y = floor(_ring.orbit_y - dsin(_ring.orbit_angle) * 10);
    var _wave = dsin((_frame_age * 20) div 3) * 30;
    _ring.image_alpha = 1 - floor(90 + _wave) / 128;

    if (_player == noone || _player.dead || _player.x < _ring.x - 350) {
        return;
    }
    // Groups 778–779 compare the player's X to the ring's Y for the lift threshold.
    if (_player.x > _ring.y) {
        _player.x += floor(abs(_ring.x - _player.x) * 0.005);
        _player.y -= 6;
    }
    if (_player.x < _ring.y) {
        _player.x += floor(abs(_ring.x - _player.x) * 0.005);
    }
}
