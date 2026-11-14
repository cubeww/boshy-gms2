enum NinjaGaidenRyuPose {
    Idle,
    Run,
    Jump,
    Defeated
}

function ninja_ryu_set_pose(_pose) {
    var _sprite = spr_ninja_gaiden_ryu_idle;
    switch (_pose) {
        case NinjaGaidenRyuPose.Idle:
            _sprite = ryu_facing_left ? spr_ninja_gaiden_ryu_idle_left : spr_ninja_gaiden_ryu_idle;
            break;
        case NinjaGaidenRyuPose.Run:
            _sprite = ryu_facing_left ? spr_ninja_gaiden_ryu_run_left : spr_ninja_gaiden_ryu_run;
            break;
        case NinjaGaidenRyuPose.Jump:
            _sprite = ryu_facing_left ? spr_ninja_gaiden_ryu_jump_left : spr_ninja_gaiden_ryu_jump;
            break;
        case NinjaGaidenRyuPose.Defeated:
            _sprite = spr_ninja_gaiden_ryu_defeated;
            break;
    }
    if (sprite_index != _sprite) {
        sprite_index = _sprite;
        image_index = 0;
    }
}

function ninja_ryu_player_in_zone(_player, _left, _top, _right, _bottom) {
    return _player != noone && _player.x >= _left && _player.x < _right
        && _player.y >= _top && _player.y < _bottom;
}

function ninja_ryu_cameo_step(_player) {
    if (!ryu_active) {
        ryu_active = ninja_ryu_player_in_zone(_player, 1, 3, 633, 480);
        if (!ryu_active) {
            return;
        }
    }

    // G923–934 update integer positions before selecting the next jump.
    ++ryu_steps;
    x = floor(x + cameo_dx);
    y = floor(y + cameo_dy);
    switch (ryu_steps) {
        case 25:
            cameo_dx = 2;
            ninja_ryu_set_pose(NinjaGaidenRyuPose.Run);
            break;
        case 65:
            cameo_dy = -3;
            ninja_ryu_set_pose(NinjaGaidenRyuPose.Jump);
            break;
        case 125:
        case 206:
            cameo_dy = 0;
            ninja_ryu_set_pose(NinjaGaidenRyuPose.Run);
            break;
        case 150:
            cameo_dy = -5;
            ninja_ryu_set_pose(NinjaGaidenRyuPose.Jump);
            break;
        case 225:
            cameo_dx = 4;
            cameo_dy = -9;
            ninja_ryu_set_pose(NinjaGaidenRyuPose.Jump);
            break;
        case 295:
            instance_destroy();
            return;
    }
    if ((ryu_steps >= 65 && ryu_steps < 125) || (ryu_steps >= 150 && ryu_steps < 206) || ryu_steps >= 225) {
        cameo_dy += 0.2;
    }
}

function ninja_ryu_shuriken(_offset_y, _angle, _speed) {
    instance_create_layer(x, y + _offset_y, "Hazards", obj_ninja_gaiden_ryu_shuriken, {
        image_angle: floor(_angle),
        travel_speed: _speed
    });
}

function ninja_ryu_sword_sound(_active_steps, _interval_ms) {
    // Each Every condition advances only while its preceding age checks pass.
    var _elapsed = _active_steps * 20;
    if ((_elapsed div _interval_ms) != ((_elapsed - 20) div _interval_ms)) {
        audio_play_sound(snd_ninja_gaiden_ryu_sword, 1, false);
    }
}

function ninja_ryu_say(_text, _sound) {
    instance_create_layer(x - 20, y + 5, "Foreground Gameplay", obj_ninja_gaiden_ryu_dialogue, {
        line: _text
    });
    audio_play_sound(_sound, 1, false);
}

function ninja_ryu_encounter_step(_player, _stage) {
    // The first timer starts at -80 on this authored actor (G845–846).
    if (!ryu_active && ninja_ryu_player_in_zone(_player, 4489, 0, 4848, 494)) {
        ryu_active = true;
        _stage.set_scene_track(snd_ninja_gaiden_prologue);
        instance_create_layer(4443, -2, "Solid Platforms", obj_ninja_gaiden_wall_jump_solid, {
            image_yscale: 10
        });
    }
    if (ryu_active) {
        ++ryu_steps;
        ++wave_interval;
        ++paired_interval;
    }
    var _age = ryu_steps;
    // G847–856 precede the integer easing in G857.
    switch (_age) {
        case -25:
            ryu_facing_left = true;
            ninja_ryu_set_pose(NinjaGaidenRyuPose.Idle);
            ninja_ryu_say("What the...", snd_ninja_gaiden_wall_hit);
            break;
        case 50:
            target_y -= 50;
            ninja_ryu_set_pose(NinjaGaidenRyuPose.Jump);
            audio_play_sound(snd_ninja_gaiden_ryu_jump, 1, false);
            _stage.set_scene_track(snd_ninja_gaiden_music);
            break;
    }
    if (_age >= 50 && _age < 60) {
        target_y -= 5;
    }
    if (_age >= 50 && _age < 150) {
        ninja_ryu_sword_sound(_age - 49, 150);
        ninja_ryu_shuriken(0, -_age * 70, 5);
        ninja_ryu_shuriken(0, -_age * 70 + 35, 5);
    }
    if (_age >= 200 && _age <= 300) {
        target_x -= 10;
        --target_y;
        ninja_ryu_sword_sound(_age - 199, 150);
        if (sword_clock > 2) {
            ninja_ryu_shuriken(0, -_age * 10, 5);
            sword_clock = 0;
        }
    }

    // G857 adds the sign of the target coordinate before quantizing each position.
    x = floor(x + (target_x - x) * 0.2 + clamp(target_x, -1, 1));
    y = floor(y + (target_y - y) * 0.2 + clamp(target_y, -1, 1));
    ++sword_clock;

    if (_age == 300) {
        target_x = 4950;
        target_y = 159;
        wave_interval = 0;
    }
    if (_age >= 300 && _age <= 650) {
        ninja_ryu_sword_sound(_age - 299, 150);
        if (paired_interval > 2) {
            var _sweep = dsin(sword_clock * 2) * 12;
            ninja_ryu_shuriken(-16, 170 + _sweep, 5);
            ninja_ryu_shuriken(16, 190 + _sweep, 5);
            paired_interval = 0;
        }
        if (wave_interval == 30) {
            instance_create_layer(x, y, "Solid Platforms", obj_ninja_gaiden_ryu_platform);
        }
        if (wave_interval == 45) {
            wave_interval = 0;
        }
    }
    switch (_age) {
        case 720:
            target_x -= 150;
            target_y += 80;
            audio_play_sound(snd_ninja_gaiden_ryu_power_up, 1, false);
            break;
        case 800:
            x = 4589;
            y = -51;
            target_x = 4689;
            target_y = -51;
            ninja_ryu_set_pose(NinjaGaidenRyuPose.Jump);
            break;
        case 830:
            target_y += 90;
            break;
        case 2000:
            x = 5048;
            y = 239;
            target_x = 5049;
            target_y = 239;
            _stage.set_scene_track(noone);
            ninja_ryu_say("What the...", snd_ninja_gaiden_enemy_kill);
            ninja_ryu_set_pose(NinjaGaidenRyuPose.Defeated);
            break;
        case 2100:
            ninja_ryu_say("I'm defeated...", snd_ninja_gaiden_wall_hit);
            break;
        case 2200:
            ninja_ryu_say("This can't be true...", snd_ninja_gaiden_enemy_kill);
            break;
        case 2400:
            ninja_ryu_say("HYA!", snd_ninja_gaiden_ryu_jump);
            target_y -= 300;
            ninja_ryu_set_pose(NinjaGaidenRyuPose.Jump);
            instance_create_layer(4786, 272, "Props", obj_ninja_gaiden_wall_jump);
            break;
    }
    if (_age >= 740 && _age < 800) {
        ninja_ryu_set_pose(NinjaGaidenRyuPose.Run);
        target_x -= 15;
    }
    if (_age >= 860 && _age < 890) {
        ninja_ryu_sword_sound(_age - 859, 80);
        ninja_ryu_shuriken(16, -90 + dsin(sword_clock * 10) * 64, 1);
    }
    if (_age >= 1050 && _age < 1150) {
        ninja_ryu_sword_sound(_age - 1049, 80);
        ninja_ryu_shuriken(16, sword_clock * 16, 2);
    }
    if (_age >= 1200 && _age < 2000) {
        target_x = 4650 + dcos(sword_clock * 10) * 250;
        target_y = (_player != noone ? _player.y : 0) - dsin(sword_clock * 10) * 250;
        if (_age >= 1300 && _player != noone) {
            var _period = _age < 1500 ? 25 : (_age < 1700 ? 13 : 10);
            var _speed = _age < 1500 ? 1 : (_age < 1700 ? 2 : 3);
            if (wave_interval >= _period) {
                // G875–877 aim with ATan2(dx, dy) - 90 from Ryu's hotspot.
                var _angle = point_direction(x, y, _player.x, _player.y);
                ninja_ryu_shuriken(16, _angle, _speed);
                wave_interval = 0;
                audio_play_sound(snd_ninja_gaiden_ryu_sword, 1, false);
            }
        }
    }

    if (ninja_ryu_player_in_zone(_player, 5100, -8, 5459, 486)) {
        instance_destroy();
    }
}
