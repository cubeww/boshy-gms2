enum SkeletonKingAttack {
    FloorWave,
    Lightning,
    FallingSkeleton,
    Fireball,
    FireballImpact,
    FireWarning,
    Diamond,
    SpinningDiamond,
    Stone,
    BlobFlyer
}

enum SkeletonKingTimer {
    Skeletons,
    HandFire,
    FloorFire,
    AimedDiamonds,
    SpinningDiamonds,
    Stones,
    FastStones,
    DiamondBarrage,
    BlobDiamonds
}

function skeleton_king_attacks_setup() {
    // Each Fusion Every condition has its own countdown and is evaluated in condition order.
    skeleton_king_attack_periods = [35, 5, 60, 35, 10, 35, 7.5, 3, 5];
    skeleton_king_attack_wait = [35, 5, 60, 35, 10, 35, 7.5, 3, 5];
}

function skeleton_king_attack_due(_timer) {
    skeleton_king_attack_wait[_timer] -= 1;
    if (skeleton_king_attack_wait[_timer] > 0) {
        return false;
    }
    skeleton_king_attack_wait[_timer] += skeleton_king_attack_periods[_timer];
    return true;
}

function skeleton_king_spawn_attack(_kind, _sprite, _x, _y, _angle = 0, _speed = 0) {
    return instance_create_depth(floor(_x), floor(_y), depth - 1, obj_skeleton_king_attack, {
        attack_kind: _kind,
        sprite_index: _sprite,
        image_angle: _angle - frac(_angle),
        travel_speed: _speed
    });
}

function skeleton_king_set_attack_platform(_platform, _sprite) {
    _platform.sprite_index = _sprite;
    _platform.visible = _sprite >= 0;
}

function skeleton_king_attack_point(_x, _y, _angle, _offset) {
    var _cosine = dcos(_angle);
    var _sine = dsin(_angle);
    return {
        x: _x + round(_offset[0] * _cosine + _offset[1] * _sine),
        y: _y + round(_offset[1] * _cosine - _offset[0] * _sine)
    };
}

function skeleton_king_left_action_point() {
    static _offsets = [[-17, 76], [-22, 70], [-27, 63], [-31, 56], [-26, 63], [-22, 70]];
    // Group 813 rotates the arm after group 742 samples its action point.
    var _angle = king_age >= 500 && king_age < 520 ? king_left_angle - 25 : king_left_angle;
    return skeleton_king_attack_point(king_left_x, king_left_y, _angle, _offsets[king_left_frame]);
}

function skeleton_king_body_action_point() {
    static _idle = [[-44, -103], [-42, -103], [-40, -104], [-41, -105]];
    static _talk = [[-43, -103], [-43, -103], [-41, -102], [-39, -101], [-40, -101], [-41, -103], [-42, -103]];
    var _offset = [-40, -104];
    switch (king_body_sprite) {
        case spr_skeleton_king_body_left: _offset = _idle[king_body_frame]; break;
        case spr_skeleton_king_body_talk_left: _offset = _talk[king_body_frame]; break;
    }
    return skeleton_king_attack_point(king_body_x, king_body_y, king_body_angle, _offset);
}

function skeleton_king_aim_attack(_x, _y, _player) {
    return _player == noone ? 180 : darctan2(_x - _player.x, _y - _player.y) + 90;
}

function skeleton_king_attack_voice() {
    static _voices = [
        snd_skeleton_king_attack_voice_1, snd_skeleton_king_attack_voice_2, snd_skeleton_king_attack_voice_3,
        snd_skeleton_king_attack_voice_4, snd_skeleton_king_attack_voice_5, snd_skeleton_king_attack_voice_6,
        snd_skeleton_king_attack_voice_7, snd_skeleton_king_attack_voice_8
    ];
    audio_play_sound(_voices[irandom(7)], 1, false);
}

function skeleton_king_attacks_step(_player) {
    if (king_age >= 0) {
        skeleton_king_run_attack_pattern(_player);
    }
    if (blob_age >= 0) {
        skeleton_king_run_blob_pattern();
    }
}

function skeleton_king_run_attack_pattern(_player) {
    var _age = king_age;
    if (_age == 260 || _age == 310) {
        // Groups 733–734 rotate the additive six-frame lightning clip about its source hotspot.
        var _lightning = skeleton_king_spawn_attack(SkeletonKingAttack.Lightning, spr_skeleton_king_intro_lightning,
            king_body_x - 32, king_body_y - 105, -90);
        _lightning.image_xscale = 3;
        _lightning.image_yscale = 3;
        blur_strength = 5;
    }
    if (_age == 350) {
        audio_play_sound(snd_skeleton_king_roar, 1, false);
    }
    if (_age >= 380 && skeleton_king_attack_due(SkeletonKingTimer.Skeletons) && _age < 450) {
        var _hand = skeleton_king_left_action_point();
        var _minion = skeleton_king_spawn_attack(SkeletonKingAttack.FallingSkeleton,
            spr_castlevania_skeleton_left, _hand.x, _hand.y, 0, -3);
        _minion.vertical_speed = -5 - irandom(9);
        skeleton_king_attack_voice();
    }
    if (_age >= 500 && _age < 520 && skeleton_king_attack_due(SkeletonKingTimer.HandFire)) {
        var _hand = skeleton_king_left_action_point();
        skeleton_king_spawn_attack(SkeletonKingAttack.Fireball, spr_skeleton_king_fireball, _hand.x, _hand.y,
            skeleton_king_aim_attack(_hand.x - 58, _hand.y + 25, _player), 5);
        audio_play_sound(snd_skeleton_king_fire, 1, false);
    }
    if (_age >= 550 && skeleton_king_attack_due(SkeletonKingTimer.FloorFire) && _age < 900) {
        skeleton_king_spawn_attack(SkeletonKingAttack.FireWarning, -1, 1310 + irandom(299), 481);
    }
    if (_age >= 650 && skeleton_king_attack_due(SkeletonKingTimer.AimedDiamonds) && _age < 900) {
        var _mouth = skeleton_king_body_action_point();
        skeleton_king_spawn_attack(SkeletonKingAttack.Diamond, spr_skeleton_king_diamond, _mouth.x, _mouth.y,
            skeleton_king_aim_attack(_mouth.x - 15, _mouth.y - 15, _player), 5);
        king_talk_age = 0;
        skeleton_king_attack_voice();
    }
    if (_age >= 900 && skeleton_king_attack_due(SkeletonKingTimer.SpinningDiamonds) && _age < 1200) {
        var _mouth = skeleton_king_body_action_point();
        var _height = 49 + dsin(scene_steps * 10) * 120 - 32;
        skeleton_king_spawn_attack(SkeletonKingAttack.SpinningDiamond, spr_skeleton_king_ember_appear,
            _mouth.x + 49, _mouth.y + _height, irandom(29));
        audio_play_sound(snd_skeleton_king_spike_spawn, 1, false);
    }
    if (_age == 1200) {
        audio_play_sound(snd_skeleton_king_damage, 1, false);
    }
    if (_age == 1350) {
        audio_play_sound(snd_skeleton_king_you_will_die, 1, false);
    }
    if (_age >= 1600 && _age < 1850) {
        skeleton_king_set_attack_platform(inst_skeleton_king_falling_platform, spr_skeleton_king_platform);
    }
    var _stone_slow = _age >= 1640 && skeleton_king_attack_due(SkeletonKingTimer.Stones) && _age < 1790;
    var _stone_fast = _age >= 1800 && skeleton_king_attack_due(SkeletonKingTimer.FastStones) && _age < 1850;
    if ((_stone_slow || _stone_fast) && _player != noone) {
        skeleton_king_spawn_attack(SkeletonKingAttack.Stone, spr_skeleton_king_falling_stone,
            _player.x + irandom(31) - irandom(31), -81);
    }
    if (_age == 1880) {
        skeleton_king_set_attack_platform(inst_skeleton_king_lower_step, spr_castlevania_backdrop_1063);
        audio_play_sound(snd_skeleton_king_sleep, 1, false);
    }
    if (_age == 2000) {
        skeleton_king_set_attack_platform(inst_skeleton_king_falling_platform, -1);
        audio_play_sound(snd_skeleton_king_wake, 1, false);
    }
    if (_age >= 2000 && skeleton_king_attack_due(SkeletonKingTimer.DiamondBarrage) && _age < 2300) {
        // Groups 759–760 run fifteen iterations and skip index 12.
        var _mouth = skeleton_king_body_action_point();
        for (var _index = 0; _index < 15; ++_index) {
            if (_index != 12) {
                skeleton_king_spawn_attack(SkeletonKingAttack.Diamond, spr_skeleton_king_diamond, _mouth.x, _mouth.y,
                    140 + _index * 5, 15 + irandom(9));
            }
        }
        shake_strength = 15;
        blur_strength = 1;
    }
    if (_age == 2350) {
        skeleton_king_set_attack_platform(inst_skeleton_king_lower_step, -1);
        skeleton_king_spawn_attack(SkeletonKingAttack.FloorWave, spr_skeleton_king_floor_wave, 1926, 3);
    }
}

function skeleton_king_start_blob_flyer() {
    // G799 enables the authored flyer and moves its current X sixteen pixels left.
    if (!instance_exists(blob_flyer)) {
        blob_flyer = skeleton_king_spawn_attack(SkeletonKingAttack.BlobFlyer, spr_skeleton_king_blob_flyer, 2048, 77);
    }
    blob_flyer.x -= 16;
    audio_play_sound(snd_skeleton_king_hawk, 1, false);
}

function skeleton_king_run_blob_pattern() {
    // G800 updates the same flyer every step, including the step that activates it.
    with (blob_flyer) {
        var _angle = ((++attack_age * 15 + 1) div 4) mod 360;
        y = floor(200 + dsin(_angle) * 240);
        x -= 5;
        image_index = (max(0, (attack_age - 1) * 80 - 1) div 100) mod image_number;
    }
    if (blob_age >= 450 && skeleton_king_attack_due(SkeletonKingTimer.BlobDiamonds) && blob_age < 800) {
        var _diamond = skeleton_king_spawn_attack(SkeletonKingAttack.Diamond, spr_skeleton_king_diamond,
            1932, 50 + dsin(scene_steps * 10) * 400, 180, 5);
        _diamond.image_alpha = 1 - irandom(49) / 128;
    }
}

function skeleton_king_attacks_clear() {
    // Groups 774–775 lower the extra step and clear the King hazards. Lightning expires on its own.
    skeleton_king_set_attack_platform(inst_skeleton_king_lower_step, -1);
    with (obj_skeleton_king_attack) {
        switch (attack_kind) {
            case SkeletonKingAttack.Fireball:
                // Fusion's Destroy action plays animation 4 in place with collisions disabled.
                attack_kind = SkeletonKingAttack.FireballImpact;
                sprite_index = -1;
                attack_age = 0;
                break;

            case SkeletonKingAttack.Lightning:
            case SkeletonKingAttack.FireballImpact:
            case SkeletonKingAttack.BlobFlyer:
                break;

            default:
                instance_destroy();
                break;
        }
    }
}

function skeleton_king_attacks_draw() {
    if (easy_mode && king_body_sprite >= 0) {
        var _mouth = skeleton_king_body_action_point();
        var _angle = -45 + dsin(scene_steps * 4) * 10;
        // Groups 723 and 1031 keep the bow attached to the body action point.
        draw_sprite_ext(spr_ryu_giant_bow, 0, _mouth.x + 33, _mouth.y - 64,
            0.35, 0.35, _angle, c_white, 1);
    }
}
