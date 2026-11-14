function green_greens_middle_traps_setup() {
    // Fusion groups 721 and 747 trigger the beams from these two clouds.
    var _emitter = inst_green_greens_laser_cloud;
    var _reflector = inst_green_greens_laser_reflector;
    green_middle_clouds = [
        {
            actor: _emitter,
            zone: _emitter.laser_trigger_zone, beam_x: _emitter.laser_origin_x, beam_y: _emitter.laser_origin_y,
            reflector: false, triggered: false, beam_age: -1, beam_hitbox: noone, vx: -1, vsp: 0
        },
        {
            actor: _reflector,
            zone: _reflector.laser_trigger_zone, beam_x: _reflector.laser_origin_x, beam_y: _reflector.laser_origin_y,
            reflector: true, triggered: false, beam_age: -1, beam_hitbox: noone, vx: 0, vsp: 0
        }
    ];
    green_middle_cloud_spawn = [];
    green_middle_debris = [];
    green_middle_barrier = [
        inst_green_greens_laser_barrier_1,
        inst_green_greens_laser_barrier_2,
        inst_green_greens_laser_barrier_3,
        inst_green_greens_laser_barrier_4,
        inst_green_greens_laser_barrier_5,
        inst_green_greens_laser_barrier_6
    ];
    green_middle_springs = [
        inst_green_greens_spring_1,
        inst_green_greens_spring_2,
        inst_green_greens_spring_3,
        inst_green_greens_spring_4,
        inst_green_greens_spring_5,
        inst_green_greens_spring_6,
        inst_green_greens_spring_7,
        inst_green_greens_spring_8,
        inst_green_greens_spring_9,
        inst_green_greens_spring_10,
        inst_green_greens_spring_11
    ];

    // Active 40 has a 220 ms centered Stretch transition before its Appearing animation.
    green_middle_stretch_steps = 11;
    green_middle_charge_steps = green_middle_stretch_steps + 17;
    green_middle_fire_steps = 30;
    green_middle_steps = 0;
}

function green_greens_middle_traps_step(_player) {
    ++green_middle_steps;
    green_greens_middle_step_springs(_player);
    for (var _i = 0; _i < array_length(green_middle_clouds); ++_i) {
        green_greens_middle_step_cloud(green_middle_clouds[_i], _player);
    }
    for (var _i = array_length(green_middle_cloud_spawn) - 1; _i >= 0; --_i) {
        var _cloud = green_middle_cloud_spawn[_i];
        if (!instance_exists(_cloud.actor)) {
            array_delete(green_middle_cloud_spawn, _i, 1);
            continue;
        }
        green_greens_middle_move_cloud(_cloud);
        if (_cloud.actor.x < -64 || _cloud.actor.y > 2000) {
            instance_destroy(_cloud.actor);
        }
    }
    for (var _i = array_length(green_middle_debris) - 1; _i >= 0; --_i) {
        var _piece = green_middle_debris[_i];
        _piece.x += _piece.vx;
        _piece.y += _piece.vy;
        _piece.vy += 0.1;
        _piece.angle += 5;
        if (_piece.y > 2000) {
            array_delete(green_middle_debris, _i, 1);
        }
    }
}

function green_greens_middle_step_springs(_player) {
    static _frames = [0, 1, 2, 3, 2, 1, 0, 1, 2, 1, 0, 1, 0];
    var _can_launch = _player != noone && !_player.input_locked;
    for (var _i = 0; _i < array_length(green_middle_springs); ++_i) {
        var _spring = green_middle_springs[_i];
        if (_spring.spring_age >= 0) {
            ++_spring.spring_age;
            var _frame = floor((_spring.spring_age * 80 - 1) / 100);
            if (_frame < array_length(_frames)) {
                _spring.image_index = _frames[_frame];
            } else {
                _spring.spring_age = -1;
                _spring.image_index = 0;
            }
        }

        // Fusion groups 733 and 753 trigger on fresh sprite-mask contact with each spring.
        var _touching = _can_launch && _player.boshy_mask_meeting(_spring);
        if (_touching && !_spring.spring_touching) {
            if (_spring.spring_age < 0) {
                _spring.spring_age = 0;
            }
            _player.vsp = -_spring.spring_force;
            _player.air_jump_available = true;
            _player.jump_cut_enabled = false;
            audio_play_sound(_spring.spring_sound, 1, false);
        }
        _spring.spring_touching = _touching;
    }
}

function green_greens_middle_step_cloud(_cloud, _player) {
    if (_cloud.beam_age >= 0) {
        ++_cloud.beam_age;
        green_greens_middle_step_laser(_cloud);
    }
    if (!instance_exists(_cloud.actor)) {
        return;
    }

    var _actor = _cloud.actor;
    if (!_cloud.triggered && green_greens_player_in_zone(_player, _cloud.zone) && !_player.input_locked) {
        _cloud.triggered = true;
        _cloud.beam_age = 0;
    }

    if (_cloud.beam_age >= 0) {
        // The cloud alternates its firing pose at Fusion speed 80 while the beam exists.
        var _firing_frame = floor(((_cloud.beam_age + 1) * 80 - 1) / 100);
        _actor.image_index = (_firing_frame mod 2) * 2;
    } else {
        _actor.image_index = (green_middle_steps div 5) mod 2;
    }
    if (_cloud.triggered && _cloud.beam_age < 0 && !_cloud.reflector) {
        green_greens_middle_move_cloud(_cloud);
    }
}

function green_greens_middle_step_laser(_cloud) {
    var _age = _cloud.beam_age;
    var _fire_end = green_middle_charge_steps + green_middle_fire_steps;
    // The shared laser sprites use a centered origin. Fusion's stage laser is right-anchored.
    if (_age == green_middle_charge_steps) {
        _cloud.beam_hitbox = instance_create_layer(_cloud.beam_x - 458, _cloud.beam_y, "Gameplay", obj_hazard, {
            sprite_index: spr_hello_kitty_laser_active, image_speed: 0, visible: false
        });
        audio_play_sound(snd_hello_kitty_laser, 1, false, 0.4);
        if (_cloud.reflector) {
            green_greens_middle_break_barrier();
        }
    }
    if (instance_exists(_cloud.beam_hitbox)) {
        if (_age == _fire_end) {
            instance_destroy(_cloud.beam_hitbox);
            _cloud.beam_hitbox = noone;
        } else {
            _cloud.beam_hitbox.image_index = (_age - green_middle_charge_steps) mod 3;
        }
    }
    if (_age >= _fire_end + sprite_get_number(spr_hello_kitty_laser_fire)) {
        _cloud.beam_age = -1;
        if (_cloud.reflector && instance_exists(_cloud.actor)) {
            _cloud.actor.image_angle = 180;
            _cloud.actor.y -= 16;
        }
    }
}

function green_greens_middle_break_barrier() {
    for (var _i = 0; _i < array_length(green_middle_barrier); ++_i) {
        var _tile = green_middle_barrier[_i];
        array_push(green_middle_debris, {
            x: _tile.x, y: _tile.y, vx: -2 - irandom(3), vy: -3 - irandom(3), angle: 0
        });
        instance_destroy(_tile);
    }
    green_middle_barrier = [];
}

function green_greens_middle_move_cloud(_cloud) {
    var _actor = _cloud.actor;
    _actor.x += _cloud.vx;
    _actor.y += _cloud.vsp;
    _cloud.vsp += 0.2;
    var _terrain_hit = false;
    with (_actor) {
        _terrain_hit = terrain_meeting(x, y);
    }
    if (_terrain_hit && _cloud.vsp > 0) {
        _actor.y -= _cloud.vsp - 0.2;
        _cloud.vsp = -2 - irandom(4);
    }
    _actor.image_index = (green_middle_steps div 5) mod 2;
}

function green_greens_middle_split_cloud() {
    static _speeds = [-3, -2, -1, 1];
    repeat (7) {
        var _actor = instance_create_layer(3861 - irandom(49), 1340, "Gameplay", obj_hazard, {
            sprite_index: spr_green_greens_middle_cloud, image_speed: 0
        });
        array_push(green_middle_cloud_spawn, { actor: _actor, vx: _speeds[irandom(3)], vsp: 0 });
    }
}

function green_greens_middle_reflect_shot(_target) {
    // Shared player shots travel horizontally, so keep the original bounce audible and reverse the shot.
    travel_direction = -travel_direction;
    x = travel_direction < 0 ? _target.bbox_left - (bbox_right - x) - 1 : _target.bbox_right + (x - bbox_left) + 1;
    image_index = travel_direction < 0 ? 1 : 0;
    audio_play_sound(snd_green_greens_middle_reflect, 1, false);
}

function green_greens_middle_traps_shot(_stage) {
    for (var _i = 0; _i < array_length(_stage.green_middle_clouds); ++_i) {
        var _cloud = _stage.green_middle_clouds[_i];
        if (instance_exists(_cloud.beam_hitbox) && place_meeting(x, y, _cloud.beam_hitbox)) {
            instance_destroy();
            return true;
        }
        if (!instance_exists(_cloud.actor) || !place_meeting(x, y, _cloud.actor)) {
            continue;
        }
        if (_cloud.reflector) {
            green_greens_middle_reflect_shot(_cloud.actor);
            return true;
        }
        if (_cloud.triggered) {
            instance_destroy(_cloud.actor);
            with (_stage) {
                green_greens_middle_split_cloud();
            }
            audio_play_sound(snd_hello_kitty_hit, 1, false);
            instance_destroy();
            return true;
        }
    }
    for (var _i = 0; _i < array_length(_stage.green_middle_cloud_spawn); ++_i) {
        var _actor = _stage.green_middle_cloud_spawn[_i].actor;
        if (instance_exists(_actor) && place_meeting(x, y, _actor)) {
            instance_destroy(_actor);
            audio_play_sound(snd_hello_kitty_hit, 1, false);
            instance_destroy();
            return true;
        }
    }
    for (var _i = 0; _i < array_length(_stage.green_middle_barrier); ++_i) {
        var _tile = _stage.green_middle_barrier[_i];
        if (place_meeting(x, y, _tile)) {
            green_greens_middle_reflect_shot(_tile);
            return true;
        }
    }
    return false;
}

function green_greens_middle_traps_draw() {
    for (var _i = 0; _i < array_length(green_middle_debris); ++_i) {
        var _piece = green_middle_debris[_i];
        draw_sprite_ext(spr_green_greens_middle_barrier, 0, _piece.x, _piece.y, 1, 1, _piece.angle, c_white, 1);
    }
    green_greens_middle_draw_lasers(true);
}

function green_greens_middle_draw_lasers(_firing) {
    // Groups 730–731 draw the active beam on Gameplay and its thin phases in front of it.
    // Restore the native per-frame hotspots after padding the shared sprites to common canvases.
    static _charge_y_offsets = [0, 0, -1, 0, 0, -1, 0, -1, 0, -1];
    static _taper_y_offsets = [
        0, 0, -1, -1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 0, -1, 0, 0, -1, -1, 0,
        0, -1, -1, 0, 0, -1, -1, 0, 0, -1, 0, -1, 0, 0, -1, -1, 0, -1, -1, 0, 1
    ];
    var _fire_end = green_middle_charge_steps + green_middle_fire_steps;
    for (var _i = 0; _i < array_length(green_middle_clouds); ++_i) {
        var _cloud = green_middle_clouds[_i];
        var _age = _cloud.beam_age;
        var _active = _age >= green_middle_charge_steps && _age < _fire_end;
        if (_age <= 0 || _active != _firing) {
            continue;
        }
        var _sprite;
        var _frame;
        var _y = _cloud.beam_y;
        var _xscale = 1;
        if (_active) {
            _sprite = spr_hello_kitty_laser_active;
            _frame = (_age - green_middle_charge_steps) mod 3;
        } else if (_age >= _fire_end) {
            _sprite = spr_hello_kitty_laser_fire;
            _frame = _age - _fire_end;
            _y += _taper_y_offsets[_frame];
        } else {
            _sprite = spr_hello_kitty_laser_charge;
            if (_age < green_middle_stretch_steps) {
                // The transition stretches the first one-pixel frame from the canvas center.
                _frame = 0;
                _xscale = _age / green_middle_stretch_steps;
            } else {
                // The original advances to the second Appearing frame as Stretch completes.
                var _appearance_step = _age - green_middle_stretch_steps + 2;
                _frame = floor((_appearance_step * 80 - 1) / 100);
                if (_frame >= 10) {
                    _frame -= 5;
                }
            }
            _y += _charge_y_offsets[_frame];
        }
        gpu_set_blendmode(bm_add);
        draw_sprite_ext(_sprite, _frame, _cloud.beam_x - 458, _y, _xscale, 1, 0, c_white, 1);
        gpu_set_blendmode(bm_normal);
    }
}
