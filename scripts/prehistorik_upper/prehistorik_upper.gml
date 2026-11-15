function prehistorik_upper_setup() {
    upper_steps = 0;
    // Source groups 702–711 position each sweep using one shared sine phase.
    with (obj_prehistorik_upper_sweep) {
        base_y = y;
    }

    upper_platforms = [
        inst_prehistorik_phase_platform_1_1,
        inst_prehistorik_phase_platform_1_2,
        inst_prehistorik_phase_platform_1_3,
        inst_prehistorik_phase_platform_1_4,
        inst_prehistorik_phase_platform_1_5,
        inst_prehistorik_phase_platform_1_6,
        inst_prehistorik_phase_platform_2_1,
        inst_prehistorik_phase_platform_2_2,
        inst_prehistorik_phase_platform_2_3,
        inst_prehistorik_phase_platform_2_4,
        inst_prehistorik_phase_platform_2_5,
        inst_prehistorik_phase_platform_2_6,
        inst_prehistorik_phase_platform_2_7
    ];
    upper_platform_phase = -1;
    prehistorik_upper_set_phase(0);

    upper_chaser = inst_prehistorik_upper_chaser;
    upper_patroller = inst_prehistorik_upper_patroller;
    upper_thrower = inst_prehistorik_upper_thrower;
    upper_kick_age = 0;
    upper_kicks = [];
}

function prehistorik_upper_set_phase(_phase) {
    if (upper_platform_phase == _phase) {
        return;
    }
    upper_platform_phase = _phase;

    // Active 30 and Active 32 move to the non-colliding layer while outlined.
    for (var _i = 0; _i < array_length(upper_platforms); ++_i) {
        var _platform = upper_platforms[_i];
        _platform.sprite_index = _platform.phase == _phase ? spr_prehistorik_upper_phase_platform : -1;
    }
}

function prehistorik_upper_step(_player) {
    ++upper_steps;
    var _offset = dsin(upper_steps * 2) * 100;
    with (obj_prehistorik_upper_sweep) {
        y = floor(base_y + _offset);
    }
    prehistorik_upper_set_phase((upper_steps * 3 div 100) mod 2);

    with (obj_bullet) {
        if (place_meeting(x, y, obj_prehistorik_upper_sweep)) {
            instance_destroy();
        }
    }

    if (_player == noone || !instance_exists(_player)) {
        return;
    }
    prehistorik_upper_step_apes(_player);
    if (_player.touching_hazard()) {
        _player.die();
        return;
    }
    prehistorik_upper_step_thrower(_player);
}

function prehistorik_upper_sweep_terrain(_dx, _dy, _terrain) {
    // Keep each movement probe at most one pixel from the last clear position.
    var _steps = ceil(max(abs(_dx), abs(_dy)));
    var _start_x = x;
    var _start_y = y;
    for (var _step = 1; _step <= _steps; ++_step) {
        var _fraction = _step / _steps;
        var _next_x = _start_x + _dx * _fraction;
        var _next_y = _start_y + _dy * _fraction;
        if (place_meeting(_next_x, _next_y, _terrain)) {
            return true;
        }
        x = _next_x;
        y = _next_y;
    }
    return false;
}

function prehistorik_upper_step_apes(_player) {
    static _terrain = [obj_solid, obj_prehistorik_terrain_mask];
    if (_player.x >= 1920 && _player.x < 2560 && _player.y < 480) {
        with (upper_chaser) {
            if (_player.y >= 100) {
                // Fusion places the mole back on the lower floor before the ground chase.
                y = ystart;
                vy = 0;
                facing = _player.x > x ? 1 : -1;
                vx += 0.3 * facing;
                if (bbox_left <= 1959 && bbox_right >= 1928) {
                    vx += 0.6;
                } else if ((bbox_left <= 2415 && bbox_right >= 2384) || (bbox_left <= 2543 && bbox_right >= 2512)) {
                    vx -= 0.6;
                }
                if (prehistorik_upper_sweep_terrain(vx, 0, _terrain)) {
                    vx *= -0.5;
                }
            } else if (_player.y < 82) {
                if (y > 250 && vy >= 0 && place_meeting(x, y + 1, _terrain)) {
                    vy = -11;
                }

                // The jump passes through the upper floor. Sweep only the descent near the lower floor.
                if (vy > 0 && y > 250) {
                    if (prehistorik_upper_sweep_terrain(0, vy, _terrain)) {
                        vy = 0;
                    }
                } else {
                    y += vy;
                }
                vy += 0.3;
                if (_player.x >= 1872 && _player.x <= 2434) {
                    facing = _player.x > x ? 1 : -1;
                    x = lerp(x, _player.x, 0.18);
                }
            }
            animation_phase = (animation_phase + clamp((10 + abs(vx) * 10) / 100, 0.1, 1)) mod 2;
            image_index = (facing < 0 ? 2 : 0) + floor(animation_phase);
        }
    }

    // Active 60 loops its two frames per direction at 5% of a frame per step.
    var _patrol_frame = ((upper_steps - 1) div 20) mod 2;
    with (upper_patroller) {
        if (bbox_left <= 2655) {
            facing = 1;
        } else if (bbox_right >= 3104) {
            facing = -1;
        }
        x += 6 * facing;
        image_index = (facing < 0 ? 2 : 0) + _patrol_frame;
    }
}

function prehistorik_upper_step_thrower(_player) {
    static _backdrops = [obj_prehistorik_terrain_mask];
    var _on_page = _player.x >= 3200 && _player.x < 3840 && _player.y < 480;
    if (instance_exists(upper_thrower) && _on_page) {
        if (_player.boshy_mask_meeting(upper_thrower)) {
            if (_player.vsp <= 0) {
                _player.die();
                return;
            }
            audio_play_sound(snd_prehistorik_kick, 1, false);
            instance_destroy(upper_thrower);
        } else if (++upper_kick_age >= 35) {
            upper_kick_age = 0;
            var _kick = instance_create_layer(upper_thrower.x, upper_thrower.y - 16, "Gameplay", obj_prehistorik_upper_actor, {
                sprite_index: spr_prehistorik_upper_kick,
                image_speed: 0,
                vx: -2,
                vy: -6,
                animation_phase: 0
            });
            array_push(upper_kicks, _kick);
        }
    }

    for (var _i = array_length(upper_kicks) - 1; _i >= 0; --_i) {
        var _kick = upper_kicks[_i];
        var _remove = !_on_page || _kick.x < 3184 || _kick.y >= 480;
        if (!_remove) {
            with (_kick) {
                // Fusion groups 1018 and 1020 apply gravity before reversing vertical speed on backdrop impact.
                prehistorik_upper_sweep_terrain(vx, 0, _backdrops);
                var _hit_backdrop = prehistorik_upper_sweep_terrain(0, vy, _backdrops);
                vy += 0.5;
                if (_hit_backdrop) {
                    vy *= -0.8;
                }
                animation_phase = min(1, animation_phase + 0.15);
                image_index = floor(animation_phase);
            }
            if (_player.boshy_mask_meeting(_kick)) {
                _player.vsp = -10;
                audio_play_sound(snd_prehistorik_kick, 1, false);
                _remove = true;
            }
        }
        if (_remove) {
            instance_destroy(_kick);
            array_delete(upper_kicks, _i, 1);
        }
    }
}

function prehistorik_upper_draw() {
    for (var _i = 0; _i < array_length(upper_platforms); ++_i) {
        var _platform = upper_platforms[_i];
        draw_sprite_ext(spr_prehistorik_upper_phase_platform, _platform.phase == upper_platform_phase ? 0 : 1,
            _platform.x, _platform.y, _platform.image_xscale, _platform.image_yscale, _platform.image_angle,
            _platform.image_blend, _platform.image_alpha);
    }
}
