enum MarioProjectile {
    SideFireball,
    Flame,
    ThrownBlock,
    HammerBro
}

function mario_projectiles_setup() {
    mario_projectile_instances = [];
    mario_turret = { x: -104, y: 405, direction: 1 };
    mario_wave_steps = 0;
    mario_flame_pair_steps = 0;
    mario_flame_barrage_steps = 0;
}

function mario_clear_side_fireballs() {
    for (var _i = array_length(mario_projectile_instances) - 1; _i >= 0; --_i) {
        var _shot = mario_projectile_instances[_i];
        if (!instance_exists(_shot)) {
            array_delete(mario_projectile_instances, _i, 1);
        } else if (_shot.kind == MarioProjectile.SideFireball) {
            instance_destroy(_shot);
            array_delete(mario_projectile_instances, _i, 1);
        }
    }
}

function mario_create_projectile(_x, _y, _sprite, _kind, _hsp, _vsp, _gravity) {
    // Hammer Bros check for a stomp before they count as contact damage.
    var _object = _kind == MarioProjectile.HammerBro ? obj_mario_intro_koopa : obj_hazard;
    var _shot = instance_create_depth(_x, _y, depth - 1, _object, {
        sprite_index: _sprite, kind: _kind, motion_x: _hsp, motion_y: _vsp,
        motion_gravity: _gravity, age: 0
    });
    array_push(mario_projectile_instances, _shot);
    return _shot;
}

function mario_spawn_wave(_direction, _y, _fast, _turret_y = undefined) {
    var _x = _direction < 0 ? 685 : -43;
    var _spawn_y = _y;
    if (_fast) {
        // G731 creates at the existing turret action point before moving the turret.
        _x = mario_turret.x + 11 * mario_turret.direction;
        _spawn_y = mario_turret.y - 19;
    }
    var _sprite = _direction < 0 ? spr_mario_side_fireball_left : spr_mario_side_fireball;
    var _shot = mario_create_projectile(_x, _spawn_y, _sprite, MarioProjectile.SideFireball, _direction * 2, 0, 0);
    _shot.image_speed = 0;
    _shot.base_y = _y;
    mario_turret.x = _direction < 0 ? 635 : 5;
    mario_turret.direction = _direction;
    if (_fast) {
        mario_turret.y = floor(_turret_y);
    }
    audio_play_sound(snd_mario_enemy_fireball, 1, false);
}

function mario_spawn_flame(_angle, _speed, _large = false) {
    var _sprite = _large ? spr_mario_bowser_fireball : spr_mario_fireball;
    _angle = ((_angle mod 360) + 360) mod 360;
    var _shot = mario_create_projectile(x, y, _sprite, MarioProjectile.Flame,
        lengthdir_x(_speed, _angle), lengthdir_y(_speed, _angle), 0);
    _shot.image_speed = 0;
    _shot.image_angle = _angle;
    _shot.flight_x = x;
    _shot.flight_y = y;
}

function mario_spawn_hammer() {
    var _first = spawn_counter == 40;
    var _bro = mario_create_projectile(_first ? 464 : 542, _first ? 1 : -3, spr_mario_hammer_left,
        MarioProjectile.HammerBro, 1, 0, 0.2);
    _bro.image_xscale = 2;
    _bro.image_yscale = 2;
    _bro.image_speed = 0;
    _bro.rebound_right = false;
    _bro.down_contact = false;
}

function mario_hammer_contact(_player) {
    var _body_contact = false;
    for (var _i = 0; _i < array_length(mario_projectile_instances); ++_i) {
        var _bro = mario_projectile_instances[_i];
        if (!instance_exists(_bro) || _bro.kind != MarioProjectile.HammerBro) {
            continue;
        }

        // Group 1072 fires on contact with the Down probe before group 46 checks the body.
        var _down_contact = _player.probe_overlaps(_player.down_probe, _bro);
        if (_down_contact && !_bro.down_contact && _player.vsp >= 0) {
            _player.vsp = -3;
            audio_play_sound(snd_prehistorik_kick, 1, false);
            instance_destroy(_bro);
            continue;
        }
        _bro.down_contact = _down_contact;
        _body_contact = _body_contact || _player.boshy_mask_meeting(_bro);
    }
    return _body_contact;
}

function mario_hammer_step(_bro, _player_x) {
    // Groups 1067–1071 add the same horizontal step, then apply the bounce flag.
    _bro.y = floor(_bro.y + _bro.motion_y);
    _bro.motion_y += _bro.motion_gravity;
    _bro.image_angle = dsin(scene_steps * 4) * 30;
    if (_bro.y > 430 && _bro.motion_y > 0) {
        _bro.motion_y = -2 - irandom(6);
        _bro.rebound_right = !_bro.rebound_right;
    }
    _bro.x += _bro.motion_x + (_bro.rebound_right ? 1 : -1);

    if (_bro.age mod 30 == 0) {
        var _aim = (_player_x - _bro.x) * 0.02;
        var _block = mario_create_projectile(_bro.x, _bro.y, spr_mario_thrown_block,
            MarioProjectile.ThrownBlock, _aim, -3 - irandom(1), 0.2);
        _block.image_speed = 0;
        // Group 1074 moves new blocks on the same step that group 1071 creates them.
        if (mario_thrown_block_step(_block)) {
            instance_destroy(_block);
        }
    }

    return _bro.bbox_right < -480 || _bro.bbox_left > room_width + 480
        || _bro.bbox_bottom < -300 || _bro.bbox_top > room_height + 300;
}

function mario_thrown_block_step(_block) {
    // Group 1073 uses the current source frame's uncropped bounds and a 32-pixel margin.
    static _frame_bounds = [[-4, -9, 6, 9], [-9, -4, 9, 6], [-6, -9, 4, 9], [-9, -6, 9, 4]];
    var _bounds = _frame_bounds[_block.image_index];
    var _camera = view_camera[0];
    var _left = camera_get_view_x(_camera);
    var _top = camera_get_view_y(_camera);
    if (_block.x + _bounds[0] <= _left - 32
        || _block.x + _bounds[2] >= _left + camera_get_view_width(_camera) + 32
        || _block.y + _bounds[1] <= _top - 32
        || _block.y + _bounds[3] >= _top + camera_get_view_height(_camera) + 32) {
        return true;
    }

    _block.x = floor(_block.x + _block.motion_x);
    _block.y = floor(_block.y + _block.motion_y);
    _block.motion_y += _block.motion_gravity;
    return false;
}

function mario_projectile_animations_step() {
    for (var _i = 0; _i < array_length(mario_projectile_instances); ++_i) {
        var _shot = mario_projectile_instances[_i];
        if (!instance_exists(_shot)) {
            continue;
        }
        // Fusion advances the sprite before its overlap event, starting after creation.
        if (_shot.kind == MarioProjectile.SideFireball) {
            _shot.image_index = ((_shot.age * 60 - 1) div 100) mod _shot.image_number;
        } else if (_shot.kind == MarioProjectile.Flame) {
            _shot.image_index = ((_shot.age * 20 - 1) div 100) mod _shot.image_number;
        } else if (_shot.kind == MarioProjectile.HammerBro) {
            _shot.image_index = ((_shot.age * 25 - 1) div 100) mod _shot.image_number;
        } else if (_shot.kind == MarioProjectile.ThrownBlock) {
            _shot.image_index = (_shot.age div 4) mod _shot.image_number;
        }
    }
}

function mario_projectiles_step(_player) {
    var _wave_offset = dsin(scene_steps * 4) * 15;
    var _player_x = _player == noone ? 0 : floor(_player.x);
    // G759 sets the defeated actor's age to -1 until G762 destroys it.
    var _wave_active = defeated ? victory_age < 150 : fight_age < 1800;
    var _fast_wave = !defeated && fight_age >= 1800;
    if (_wave_active) {
        mario_turret.y = floor(420 + _wave_offset);
    }
    if (!defeated && (fight_age == 1720 || fight_age == 2305)) {
        mario_turret.x = fight_age == 1720 ? -50 : -100;
    }
    for (var _i = array_length(mario_projectile_instances) - 1; _i >= 0; --_i) {
        var _shot = mario_projectile_instances[_i];
        if (!instance_exists(_shot)) {
            array_delete(mario_projectile_instances, _i, 1);
            continue;
        }
        ++_shot.age;
        var _expired;
        if (_shot.kind == MarioProjectile.SideFireball) {
            _shot.x += _shot.motion_x;
            if (_wave_active) {
                _shot.y = floor(_shot.base_y + _wave_offset);
            } else if (_fast_wave && _shot.motion_x < 0) {
                _shot.x -= 6;
            }
            _expired = (_shot.x < -128 && _shot.motion_x < 0) || (_shot.x > room_width + 128 && _shot.motion_x > 0);
        } else if (_shot.kind == MarioProjectile.Flame) {
            // G780 and G786 write the accumulators first. Alterable value E stays zero,
            // so the added vertical term (E * 0.01) never bends the flight path.
            _shot.x = floor(_shot.flight_x);
            _shot.y = floor(_shot.flight_y);
            _shot.flight_x += _shot.motion_x;
            _shot.flight_y += _shot.motion_y;
            _expired = (_shot.x < -128 && _shot.motion_x < 0) || (_shot.x > room_width + 128 && _shot.motion_x > 0)
                || (_shot.y < -128 && _shot.motion_y < 0) || (_shot.y > room_height + 128 && _shot.motion_y > 0);
        } else if (_shot.kind == MarioProjectile.HammerBro) {
            _expired = mario_hammer_step(_shot, _player_x);
        } else {
            _expired = mario_thrown_block_step(_shot);
        }
        if (_expired) {
            instance_destroy(_shot);
            array_delete(mario_projectile_instances, _i, 1);
        }
    }
}

function mario_projectiles_draw() {
    if (mario_turret.x >= 0) {
        var _turret_sprite = mario_turret.direction < 0 ? spr_mario_turret_left : spr_mario_turret;
        var _frame = max(0, (scene_steps * 10 - 1) div 100) mod sprite_get_number(_turret_sprite);
        draw_sprite(_turret_sprite, _frame, mario_turret.x, mario_turret.y);
    }
}
