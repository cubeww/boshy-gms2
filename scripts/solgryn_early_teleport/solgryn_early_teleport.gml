function solgryn_early_teleport_init() {
    teleport_cycle = 0;
    teleport_sound_steps = 0;
    teleport_target_x = 320;
    teleport_target_y = 150;
    teleport_wave_amplitude = 0;
    teleport_wave_frequency = 0;
}

function solgryn_early_teleport_burst(_x, _y) {
    return instance_create_layer(_x, _y, "Attack Effects", obj_solgryn_early_teleport_burst);
}

function solgryn_early_teleport_burst_splash() {
    var _boss = instance_find(obj_solgryn, 0);
    if (_boss != noone && _boss.fight_age < 15000) {
        var _splash_y = y + irandom(63) - irandom(63);
        solgryn_early_splash(x + irandom(63) - irandom(63), _splash_y);
    }
}

function solgryn_early_teleport_reveal(_steps) {
    teleport_wave_amplitude = 5 / (_steps * 3);
    teleport_wave_frequency = _steps * 0.08;
    image_alpha = min(1, _steps * 5 / 255);
}

function solgryn_early_teleport_step(_age) {
    // G683 advances the shared cooldown before G748 resets it.
    if (_age == 3300) {
        target_x = 500;
        target_y = 200;
        teleport_cycle = 0;
    } else {
        ++teleport_cycle;
    }

    if (_age > 3300 && _age <= 3990) {
        image_angle = dsin(_age * 8) * 10;
        if (_age >= 3350) {
            // In G758 the timer is tested before the requirements on alterable F.
            teleport_sound_steps = (teleport_sound_steps + 1) mod 5;
            if (teleport_cycle == 5) {
                visible = false;
            } else if (teleport_cycle == 15) {
                teleport_target_x = 80 + irandom(559);
                teleport_target_y = 50 + irandom(419);
                solgryn_early_teleport_burst(teleport_target_x, teleport_target_y);
                audio_play_sound(snd_solgryn_early_teleport_warning, 1, false);
            }
            if (teleport_cycle >= 60) {
                visible = true;
                x = teleport_target_x;
                y = teleport_target_y;
                target_x = x;
                target_y = y;
            }
            if (teleport_cycle == 60 || teleport_cycle == 90) {
                audio_play_sound(snd_solgryn_early_teleport_warp, 1, false);
            }
            if (teleport_cycle >= 60 && teleport_cycle <= 90) {
                solgryn_early_teleport_reveal(teleport_cycle - 59);
                solgryn_early_shot(x, y, (_age * 25) mod 360, 6);
                if (teleport_sound_steps == 0) {
                    audio_play_sound(snd_solgryn_early_shoot, 1, false);
                }
            }
            if (teleport_cycle >= 90) {
                var _fade = teleport_cycle - 89;
                teleport_wave_amplitude = _fade * 0.01;
                teleport_wave_frequency = _fade * 0.08;
                image_alpha = max(0, 1 - _fade * 15 / 255);
            }
            if (teleport_cycle >= 60) {
                solgryn_blur(1.5, blur_angle);
            }
            if (teleport_cycle == 115) {
                teleport_cycle = 0;
            }
        }
        if (_age > 3350) {
            with (obj_solgryn_early_hazard) {
                if (shot_kind == SolgrynEarlyShot.Explosion) {
                    shot_drift = 5;
                    shot_hsp = -2;
                }
            }
        }
    }

    if (_age == 3990) {
        x = 570;
        y = 320;
        target_x = x;
        target_y = y;
    }
    if (_age == 4010) {
        audio_play_sound(snd_solgryn_early_teleport_warp, 1, false);
    }
    if (_age >= 4010 && _age < 4040) {
        solgryn_early_teleport_reveal(_age - 4009);
    } else if (_age == 4040) {
        teleport_wave_amplitude = 0;
        image_alpha = 1;
        image_angle = 0;
    }

    if (_age >= 4040 && _age <= 5000) {
        if (teleport_cycle >= 4) {
            // G767–769 fire two separated tracks in opposite vertical phase.
            var _offset = dsin(_age * 6) * 35;
            solgryn_early_shot(x, floor(300 + _offset), 180, 4);
            solgryn_early_shot(x, floor(440 - _offset), 180, 4);
            audio_play_sound(snd_solgryn_early_shoot, 1, false);
            teleport_cycle = 0;
        }
        target_y = floor(350 + dsin(_age * 5) * 30);
        image_angle = dsin(_age * 8) * 20;
    }
}

function solgryn_early_teleport_draw(_sprite, _frame, _x, _y, _scale_x, _scale_y, _angle, _color, _alpha) {
    if (teleport_wave_amplitude == 0 || !shader_is_compiled(shd_solgryn_early_teleport_wave)) {
        return false;
    }

    // Draw the full source canvas so distortion can move pixels into its transparent margins.
    var _width = sprite_get_width(_sprite);
    var _height = sprite_get_height(_sprite);
    var _uv = sprite_get_uvs(_sprite, _frame);
    var _uv_width = (_uv[2] - _uv[0]) / _uv[6];
    var _uv_height = (_uv[3] - _uv[1]) / _uv[7];
    var _u = -_uv[4] / (_width * _uv[6]);
    var _v = -_uv[5] / (_height * _uv[7]);
    var _u_end = _u + 1 / _uv[6];
    var _v_end = _v + 1 / _uv[7];
    static _bounds_uniform = shader_get_uniform(shd_solgryn_early_teleport_wave, "u_bounds");
    static _canvas_uniform = shader_get_uniform(shd_solgryn_early_teleport_wave, "u_canvas");
    static _wave_uniform = shader_get_uniform(shd_solgryn_early_teleport_wave, "u_wave");

    shader_set(shd_solgryn_early_teleport_wave);
    shader_set_uniform_f(_bounds_uniform, _uv[0], _uv[1], _uv[2], _uv[3]);
    shader_set_uniform_f(_canvas_uniform, _uv[1] + _uv_height * _v * _uv[7], _uv_width, _uv_height);
    shader_set_uniform_f(_wave_uniform, teleport_wave_amplitude, teleport_wave_frequency);

    var _left = -sprite_get_xoffset(_sprite) * _scale_x;
    var _top = -sprite_get_yoffset(_sprite) * _scale_y;
    var _right = _left + _width * _scale_x;
    var _bottom = _top + _height * _scale_y;
    var _cos = dcos(_angle);
    var _sin = dsin(_angle);
    draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(_sprite, _frame));
    draw_vertex_texture_color(_x + _left * _cos + _top * _sin, _y - _left * _sin + _top * _cos,
        _u, _v, _color, _alpha);
    draw_vertex_texture_color(_x + _right * _cos + _top * _sin, _y - _right * _sin + _top * _cos,
        _u_end, _v, _color, _alpha);
    draw_vertex_texture_color(_x + _left * _cos + _bottom * _sin, _y - _left * _sin + _bottom * _cos,
        _u, _v_end, _color, _alpha);
    draw_vertex_texture_color(_x + _right * _cos + _bottom * _sin, _y - _right * _sin + _bottom * _cos,
        _u_end, _v_end, _color, _alpha);
    draw_primitive_end();
    shader_reset();
    return true;
}
