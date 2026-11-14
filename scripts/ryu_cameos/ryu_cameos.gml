enum RyuCameo {
    RoundCue,
    ChunLi,
    Kikoken,
    Blanka,
    ShockWave,
    Dhalsim,
    DhalsimDefeat
}

function ryu_cameo_create(_x, _y, _kind, _sprite, _hsp = 0, _vsp = 0) {
    var _decorative = _kind == RyuCameo.RoundCue || _kind == RyuCameo.DhalsimDefeat;
    var _object = _decorative ? obj_green_greens_prop : obj_hazard;
    var _cameo = instance_create_depth(_x, _y, depth - 2, _object, {
        sprite_index: _sprite,
        cameo_kind: _kind,
        cameo_age: 0,
        hsp: _hsp,
        vsp: _vsp
    });
    array_push(ryu_cameo_instances, _cameo);
    return _cameo;
}

function ryu_cameos_spawn(_age) {
    // Fusion groups 762–765 add the late-fight guests to the main attack timeline.
    switch (_age) {
        case 3300:
            var _cue = ryu_cameo_create(1600, 240, RyuCameo.RoundCue, spr_ryu_sagat);
            _cue.image_xscale = 0;
            _cue.image_yscale = 0;
            audio_play_sound(snd_ryu_round, 1, false);
            break;
        case 3350:
            ryu_cameo_create(1965, 391, RyuCameo.ChunLi, spr_ryu_chun_li, -3);
            audio_play_sound(snd_ryu_chun_li_spin, 1, false);
            break;
        case 3600:
            var _blanka = ryu_cameo_create(1943, 395, RyuCameo.Blanka, spr_ryu_cameo_611, -2, -3);
            _blanka.rest_steps = 0;
            audio_play_sound(snd_ryu_cameo_scream, 1, false);
            break;
        case 3900:
            var _dhalsim = ryu_cameo_create(1984, 395, RyuCameo.Dhalsim, spr_ryu_cameo_612, -1);
            _dhalsim.shot_hits = 0;
            _dhalsim.image_xscale = 2;
            _dhalsim.image_yscale = 2;
            break;
    }
}

function ryu_cameo_step_round(_cameo, _age) {
    // Fusion groups 1268–1272 keep the cue centered through its grow and shrink animation.
    var _camera = view_camera[0];
    _cameo.x = camera_get_view_x(_camera) + camera_get_view_width(_camera) / 2;
    _cameo.y = camera_get_view_y(_camera) + camera_get_view_height(_camera) / 2;
    if (_age >= 30 && _age <= 50) {
        _cameo.image_xscale = min(2, _cameo.image_xscale + 0.15);
    } else if (_age >= 65) {
        _cameo.image_xscale = max(0, _cameo.image_xscale - 0.15);
    }
    _cameo.image_yscale = _cameo.image_xscale;
}

function ryu_cameo_step_chun_li(_cameo, _age) {
    // Fusion groups 1229–1240 send three rising Kikokens in each 25-step volley.
    if (_age >= 30 && _age <= 260) {
        var _beat = (_age - 29) mod 25;
        if (_beat == 10 || _beat == 15 || _beat == 0) {
            var _action_offsets = [[0, -15], [0, -18], [1, -15], [1, -19]];
            var _action = _action_offsets[floor(_cameo.image_index) mod 4];
            var _shot = ryu_cameo_create(_cameo.x + _action[0], _cameo.y + _action[1], RyuCameo.Kikoken,
                spr_ryu_hadoken_2, irandom(2) - irandom(2), -12);
            _shot.image_angle = point_direction(0, 0, _shot.hsp, _shot.vsp);
            if (_beat == 0) {
                audio_play_sound(snd_ryu_chun_li_kikoken, 1, false);
            }
        }
    }
    if (_age >= 30 && _age < 260) {
        _cameo.x += _cameo.hsp;
        _cameo.y = floor(391 + dsin(ryu_attack_clock * 20 / 3) * 32);
    } else if (_age >= 260) {
        if (_age == 260) {
            audio_play_sound(snd_ryu_chun_li_victory, 1, false);
        }
        _cameo.y -= (_age - 239) * 0.5;
    }
}

function ryu_cameo_step_blanka(_cameo) {
    // Fusion groups 1241–1250 alternate the rolling jump and the grounded shock waves.
    if (_cameo.sprite_index == spr_ryu_cameo_611_anim_12) {
        ++_cameo.rest_steps;
        if (_cameo.rest_steps == 10) {
            ryu_cameo_create(_cameo.x, _cameo.y, RyuCameo.ShockWave, spr_ryu_cameo_613, 7);
            ryu_cameo_create(_cameo.x, _cameo.y, RyuCameo.ShockWave, spr_ryu_cameo_613_left, -7);
            audio_play_sound(snd_ryu_cameo_explosion, 1, false);
        } else if (_cameo.rest_steps == 20) {
            _cameo.sprite_index = spr_ryu_cameo_611;
            _cameo.image_index = 0;
            _cameo.hsp = -3;
            _cameo.vsp = -10 - irandom(2) * 6;
            _cameo.rest_steps = 0;
        }
        return;
    }

    _cameo.x += _cameo.hsp;
    _cameo.y += _cameo.vsp;
    _cameo.vsp += 0.7;
    _cameo.image_angle -= _cameo.hsp * 10;
    var _landed = false;
    if (_cameo.vsp > 0) {
        with (_cameo) {
            _landed = place_meeting(x, y, [obj_player_backdrop, obj_ryu_arena_solid]);
        }
    }
    if (_landed) {
        _cameo.sprite_index = spr_ryu_cameo_611_anim_12;
        _cameo.image_index = 0;
        _cameo.image_angle = 0;
        _cameo.y = 440;
        // Group 1245 also counts the landing frame toward the shock wave.
        _cameo.rest_steps = 1;
    }
}

function ryu_cameo_step_dhalsim(_cameo, _player) {
    // Fusion groups 1251–1258 track the player's height and count 75 shots.
    --_cameo.x;
    if (instance_exists(_player)) {
        _cameo.y = floor(_player.y - 4 - dsin(ryu_attack_clock * 20 / 2) * 6);
    }
    with (obj_bullet) {
        if (place_meeting(x, y, _cameo)) {
            instance_destroy();
            ++_cameo.shot_hits;
            audio_play_sound(snd_hello_kitty_hit, 1, false);
        }
    }
    if (_cameo.shot_hits >= 75) {
        // Fusion removes collision on destroy and keeps the disappearance animation moving right.
        var _defeat = ryu_cameo_create(_cameo.x + 1, _cameo.y, RyuCameo.DhalsimDefeat, spr_ryu_cameo_612_impact);
        _defeat.image_speed = 0;
        _defeat.image_xscale = _cameo.image_xscale;
        _defeat.image_yscale = _cameo.image_yscale;
        audio_play_sound(snd_ryu_dhalsim_defeat, 1, false);
        return true;
    } else if (_cameo.cameo_age mod 50 == 0) {
        audio_play_sound(snd_ryu_dhalsim_yoga, 1, false);
    }
    return false;
}

function ryu_cameos_step(_player) {
    for (var _i = array_length(ryu_cameo_instances) - 1; _i >= 0; --_i) {
        var _cameo = ryu_cameo_instances[_i];
        if (!instance_exists(_cameo)) {
            array_delete(ryu_cameo_instances, _i, 1);
            continue;
        }

        var _age = ++_cameo.cameo_age;
        var _finished = false;
        switch (_cameo.cameo_kind) {
            case RyuCameo.RoundCue:
                ryu_cameo_step_round(_cameo, _age);
                _finished = _age >= 110;
                break;
            case RyuCameo.ChunLi:
                ryu_cameo_step_chun_li(_cameo, _age);
                _finished = _age >= 320;
                break;
            case RyuCameo.Kikoken:
                // Group 1240 derives the angle from the projectile's travel direction.
                _cameo.image_angle = point_direction(0, 0, _cameo.hsp, _cameo.vsp);
                _cameo.x += _cameo.hsp;
                _cameo.y += _cameo.vsp;
                _cameo.vsp += 0.3;
                _finished = _cameo.y > 544;
                break;
            case RyuCameo.Blanka:
                ryu_cameo_step_blanka(_cameo);
                _finished = _cameo.x < 1216 || _cameo.y > 544;
                break;
            case RyuCameo.ShockWave:
                _cameo.x += _cameo.hsp;
                _finished = _cameo.x < 1152 || _cameo.x > 2048;
                break;
            case RyuCameo.Dhalsim:
                _finished = ryu_cameo_step_dhalsim(_cameo, _player) || _cameo.x <= 1152;
                break;
            case RyuCameo.DhalsimDefeat:
                ++_cameo.x;
                var _frame = _age * sprite_get_speed(_cameo.sprite_index) / 50;
                _cameo.image_index = floor(_frame);
                _finished = _frame >= _cameo.image_number;
                break;
        }
        if (_finished) {
            instance_destroy(_cameo);
            array_delete(ryu_cameo_instances, _i, 1);
        }
    }
}
