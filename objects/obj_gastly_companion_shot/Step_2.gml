var _boss = noone;
switch (room) {
    case rm_hello_kitty: _boss = instance_find(obj_hello_kitty, 0); break;
    case rm_king_dedede: _boss = instance_find(obj_king_dedede, 0); break;
    case rm_ryu: _boss = instance_find(obj_ryu, 0); break;
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
var _direction_y = _reflected ? lengthdir_y(1, direction) : 0;
for (var _distance = 1; _distance <= 13; ++_distance) {
    var _travel = min(_distance, 12.5);
    x = _start_x + _travel * _direction_x;
    y = _start_y + _travel * _direction_y;
    if ((room == rm_shang_tsung || room == rm_bomberman || room == rm_ninja_gaiden || room == rm_missingno
        || room == rm_desert || room == rm_desert_secret || room == rm_final_path || room == rm_solgryn)
        && place_meeting(x, y, obj_player_backdrop)) {
        instance_destroy();
        exit;
    }
    if (room == rm_ninja_gaiden) {
        if (ninja_enemy_take_shot(id, true)) {
            instance_destroy();
            exit;
        }
        if (!_reflected && reflected) {
            direction = reflection_angle;
            image_angle = direction;
            break;
        }
    }
    if (_boss != noone && (room == rm_skeleton_king || room == rm_mega_man || room == rm_missingno || room == rm_solgryn
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
                        audio_stop_sound(_game.stage_music_instance);
                        _game.stage_music_instance = -1;
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
            image_angle = direction;
            break;
        }
    }
}

var _camera = view_camera[0];
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
if (bbox_right < _left || bbox_left > _left + camera_get_view_width(_camera)
    || bbox_bottom < _top || bbox_top > _top + camera_get_view_height(_camera)) {
    instance_destroy();
}
