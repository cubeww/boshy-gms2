var _boss = noone;
switch (room) {
    case rm_hello_kitty: _boss = instance_find(obj_hello_kitty, 0); break;
    case rm_king_dedede: _boss = instance_find(obj_king_dedede, 0); break;
    case rm_ryu: _boss = instance_find(obj_ryu, 0); break;
    case rm_secret_jtv: _boss = instance_find(obj_secret_jtv_encounter, 0); break;
    case rm_cheetah_men: _boss = instance_find(obj_cheetah_men, 0); break;
    case rm_mario:
        _boss = instance_find(obj_mario, 0);
        if (_boss != noone && _boss.defeated) {
            _boss = noone;
        }
        break;
    case rm_green_greens: _boss = instance_find(obj_green_greens_kracko, 0); break;
    case rm_biollante: _boss = instance_find(obj_biollante, 0); break;
    case rm_sanicz: _boss = instance_find(obj_sanicz, 0); break;
    case rm_skeleton_king: _boss = instance_find(obj_skeleton_king, 0); break;
    case rm_mega_man: _boss = instance_find(obj_mega_man, 0); break;
    case rm_shang_tsung: _boss = instance_find(obj_shang_tsung, 0); break;
    case rm_bomberman: _boss = instance_find(obj_bomberman, 0); break;
    case rm_missingno: _boss = instance_find(obj_missingno, 0); break;
    case rm_solgryn: _boss = instance_find(obj_solgryn, 0); break;
}

var _start_x = x;
var _start_y = y;
var _reflected = reflected;
var _direction_x = lengthdir_x(1, direction);
var _direction_y = lengthdir_y(1, direction);
for (var _distance = 1; _distance <= 13; ++_distance) {
    var _travel = min(_distance, 12.5);
    x = _start_x + _travel * _direction_x;
    y = _start_y + _travel * _direction_y;
    // The shared RattataShoot event tests backdrops in every playable frame.
    if (place_meeting(x, y, obj_player_backdrop)) {
        instance_destroy();
        exit;
    }
    if (room == rm_pokemon_puzzle && pokemon_puzzle_spike_hit()) {
        instance_destroy();
        exit;
    }
    if (room == rm_castlevania && castlevania_widget_hit(id)) {
        instance_destroy();
        exit;
    }
    if (room == rm_ninja_gaiden) {
        ninja_enemy_take_shot(id, true);
        if (!_reflected && reflected) {
            direction = reflection_angle;
            break;
        }
    }
    if (_boss != noone && (room == rm_secret_jtv || room == rm_cheetah_men || room == rm_skeleton_king || room == rm_mega_man
        || room == rm_missingno || room == rm_solgryn
        || place_meeting(x, y, _boss))) {
        var _hit = false;
        switch (room) {
            case rm_hello_kitty:
                if (_boss.combat_active && !_boss.defeated) {
                    _boss.take_hit(1);
                    _hit = true;
                }
                break;
            case rm_green_greens:
                if (_boss.phase_hits < 6 && _boss.hit_points > 0) {
                    ++_boss.phase_hits;
                    _boss.hit_points = max(0, _boss.hit_points - _boss.shot_damage);
                    if (_boss.hit_flash_age < 0) {
                        _boss.hit_flash_age = 1;
                    }
                    if (_boss.hit_points == 0) {
                        _boss.target_y = _boss.y;
                        var _game = _boss.stage_controller.game_controller;
                        _game.stop_stage_music();
                    }
                    _hit = true;
                }
                break;
            default:
                _hit = _boss.take_player_shot(id);
                break;
        }
        if (_hit) {
            instance_destroy();
            exit;
        }
        if (!_reflected && reflected) {
            direction = reflection_angle;
            break;
        }
    }
}

// Fusion's bullet movement culls against the frame bounds plus 64 pixels.
if (x < -64 || x > room_width + 64 || y < -64 || y > room_height + 64) {
    instance_destroy();
}
