function kid_icarus_enemy_zone(_player, _zone) {
    return _player != noone && _player.x >= _zone[0] && _player.x < _zone[2]
        && _player.y >= _zone[1] && _player.y < _zone[3];
}

function kid_icarus_blob_player_locked() {
    var _caster = instance_find(obj_kid_icarus_blob_caster, 0);
    return _caster != noone && _caster.cast_age > 0;
}

function kid_icarus_enemy_take_shot(_shot) {
    // G830–831 only allow damage after the caster disappears. Small blobs
    // disappear on contact and the same shot is free to continue.
    if (instance_exists(obj_kid_icarus_blob_caster)) {
        return false;
    }
    var _blob = noone;
    with (_shot) {
        _blob = instance_place(x, y, obj_kid_icarus_blob);
    }
    if (_blob == noone) {
        return false;
    }
    if (_blob.image_xscale <= 0.8) {
        instance_destroy(_blob);
        return false;
    }

    audio_play_sound(snd_mario_bump, 1, false);
    if (++_blob.hits >= 3) {
        // G832–836 create two new blobs at the old hotspot when large enough.
        if (_blob.image_xscale >= 1.5) {
            var _scale = _blob.image_xscale * 0.62;
            for (var _direction = 1; _direction >= -1; _direction -= 2) {
                var _child = instance_create_layer(_blob.x, _blob.y, _blob.layer, obj_kid_icarus_blob);
                _child.image_xscale = _scale;
                _child.image_yscale = _scale;
                _child.horizontal_direction = _direction;
                _child.moving = true;
            }
        }
        instance_destroy(_blob);
    }
    return true;
}

function kid_icarus_enemies_step(_player, _steps) {
    // G779–797, G814–815, G854–855.
    with (obj_kid_icarus_rotating_spike) {
        image_angle = (initial_angle + _steps * rotation_step) mod 360;
    }
    var _hazards = layer_get_id("Hazards");
    with (obj_kid_icarus_egg_thrower) {
        if (!retreating) {
            var _offsets = [];
            switch (++attack_age) {
                case 10: _offsets = [-14, 32]; break;
                case 50: _offsets = [-14, 4]; break;
                case 90: _offsets = [4, 18, 32]; break;
                case 130: _offsets = [-14, -1, 14]; break;
                case 160: attack_age = 0; break;
            }
            for (var _index = 0; _index < array_length(_offsets); ++_index) {
                instance_create_layer(x - 8, y + _offsets[_index], _hazards, obj_kid_icarus_egg);
            }
            if (kid_icarus_enemy_zone(_player, trigger_zone)) {
                retreating = true;
            }
        }
        if (retreating) {
            y -= 2;
            x += floor(dcos((_steps * 20) div 3) * 5);
            if (y + sprite_height <= 0) {
                instance_destroy();
            }
        }
    }
    with (obj_kid_icarus_egg) {
        x -= 3;
        // Fusion keeps actives alive within a 480px horizontal playfield margin.
        if (bbox_right < -480) {
            instance_destroy();
        }
    }

    if (_steps mod 15 == 0) {
        with (obj_kid_icarus_rain_emitter) {
            if (kid_icarus_enemy_zone(_player, trigger_zone)) {
                instance_create_layer(x + irandom(spawn_width - 1), y, layer, obj_kid_icarus_green_drop);
            }
        }
    }
    kid_icarus_blob_encounter_step(_player);

    // G905–909. The authored Captain Falcon stays placed until the corridor triggers his punch.
    with (obj_kid_icarus_falcon) {
        if (!punch_started && kid_icarus_enemy_zone(_player, trigger_zone)) {
            punch_started = true;
            audio_play_sound(snd_kid_icarus_falcon, 1, false);
        }
        if (punch_started) {
            ++punch_age;
            if (punch_age == 45) {
                audio_stop_sound(snd_kid_icarus_falcon);
                audio_play_sound(snd_kid_icarus_falcon_punch, 1, false);
            }
            if (punch_age >= 45 && punch_age <= 55) {
                x -= 10;
            }
            if (punch_age >= 90 && punch_age <= 100) {
                x += 10;
            }
        }
    }

    // G1152–1158. Reveal after the exact corridor trigger, then repeat at age 185.
    with (obj_kid_icarus_spider) {
        if (!attack_started && kid_icarus_enemy_zone(_player, trigger_zone)) {
            attack_started = true;
            audio_play_sound(snd_kid_icarus_spider_scream, 1, false);
        }
        if (attack_started) {
            image_xscale = 2;
            image_yscale = 2;
            if (attack_age < 35) {
                y += 10;
                image_angle = floor(dsin(_steps * 20) * 20);
            }
            ++attack_age;
            if (attack_age >= 35 && attack_age < 70) {
                y -= 20;
                image_angle = floor(dsin((_steps * 20) div 3) * 10);
            }
            if (attack_age == 185) {
                y -= 20;
                audio_stop_sound(snd_kid_icarus_spider_scream);
                audio_play_sound(snd_kid_icarus_spider_scream, 1, false);
            }
            if (attack_age >= 185) {
                y += 40;
                image_angle = 0;
                if (bbox_top > room_height + 300) {
                    instance_destroy();
                }
            }
        }
    }
}

function kid_icarus_blob_encounter_step(_player) {
    var _camera = view_camera[0];
    var _left = camera_get_view_x(_camera);
    var _right = _left + camera_get_view_width(_camera);

    // G826–829, G837–839. Scale determines the upward rebound speed.
    with (obj_kid_icarus_blob) {
        if (moving) {
            y = floor(y + vertical_speed);
            vertical_speed += 0.4;
        }
        if (y > 6607 && place_meeting(x, y, obj_player_backdrop)) {
            vertical_speed = -10 / image_xscale - 8;
        }
        if (moving) {
            x += horizontal_direction;
        }
        if (x <= _left) {
            horizontal_direction = 1;
        }
        if (x >= _right) {
            horizontal_direction = -1;
        }
        if (y <= 6255) {
            vertical_speed += 1;
        }
    }

    // G840–848. The caster advances its 300-step sequence even after a player death.
    with (obj_kid_icarus_blob_caster) {
        if (cast_age == 0 && kid_icarus_enemy_zone(_player, trigger_zone) && !_player.input_locked) {
            ++cast_age;
            ++cast_interval;
            _player.input_locked = true;
            _player.hsp = 0;
        } else if (cast_age > 0) {
            ++cast_age;
            ++cast_interval;
        }

        if (cast_age > 0) {
            var _blob = instance_find(obj_kid_icarus_blob, 0);
            if (cast_age >= 20 && cast_age < 220 && cast_interval >= 15 && _blob != noone) {
                var _spell = instance_create_layer(x, y, layer_get_id("Hazards"), obj_kid_icarus_blob_spell);
                _spell.image_angle = floor(point_direction(x, y, _blob.x, _blob.y));
                audio_play_sound(snd_kid_icarus_blob_cast, 1, false);
                cast_interval = 0;
                image_angle = (image_angle + 45) mod 360;
                image_xscale += 0.8;
            }
            if (cast_age == 300) {
                if (_player != noone) {
                    _player.input_locked = false;
                }
                with (obj_kid_icarus_blob) {
                    moving = true;
                }
                instance_destroy();
            } else {
                if (cast_age <= 20) {
                    x += 20;
                }
                if (cast_age >= 220) {
                    x -= 20;
                }
                image_xscale *= 0.97;
                image_yscale = image_xscale;
            }
        }
    }

    // G844 processes spell hits before applying ballistic motion in G849–850.
    with (obj_kid_icarus_blob_spell) {
        var _blob = instance_place(x, y, obj_kid_icarus_blob);
        if (_blob != noone) {
            _blob.image_xscale += 0.85;
            _blob.image_yscale = _blob.image_xscale;
            audio_play_sound(snd_kid_icarus_blob_growth, 1, false);
            instance_destroy();
        } else {
            x = floor(motion_x);
            y = floor(motion_y);
            motion_x += lengthdir_x(spell_speed, image_angle);
            motion_y += lengthdir_y(spell_speed, image_angle) + vertical_acceleration;
            if (bbox_right < -480 || bbox_left > room_width + 480
                || bbox_bottom < -300 || bbox_top > room_height + 300) {
                instance_destroy();
            }
        }
    }
    with (obj_kid_icarus_green_drop) {
        if (image_index >= 7) {
            image_index = 7;
            image_speed = 0;
            y = floor(y + fall_speed);
            fall_speed += 0.5;
        }
        if (place_meeting(x, y, obj_player_backdrop) || bbox_top >= room_height) {
            instance_destroy();
        }
    }
    if (!instance_exists(obj_kid_icarus_blob)) {
        with (obj_kid_icarus_blob_gate) {
            instance_destroy();
        }
    }
}
