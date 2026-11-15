var _player = instance_find(obj_player, 0);
var _game = instance_find(obj_game, 0);
var _stage = room == rm_prehistorik ? instance_find(obj_prehistorik, 0) : noone;
var _green_stage = room == rm_green_greens ? instance_find(obj_green_greens, 0) : noone;
var _boss = noone;
switch (room) {
    case rm_king_dedede: _boss = instance_find(obj_king_dedede, 0); break;
    case rm_ryu: _boss = instance_find(obj_ryu, 0); break;
    case rm_gastly: _boss = instance_find(obj_gastly, 0); break;
    case rm_secret_jtv: _boss = instance_find(obj_secret_jtv_encounter, 0); break;
    case rm_cheetah_men: _boss = instance_find(obj_cheetah_men, 0); break;
    case rm_mario: _boss = instance_find(obj_mario, 0); break;
    case rm_biollante: _boss = instance_find(obj_biollante, 0); break;
    case rm_sanicz: _boss = instance_find(obj_sanicz, 0); break;
    case rm_skeleton_king: _boss = instance_find(obj_skeleton_king, 0); break;
    case rm_mega_man: _boss = instance_find(obj_mega_man, 0); break;
    case rm_shang_tsung: _boss = instance_find(obj_shang_tsung, 0); break;
    case rm_bomberman: _boss = instance_find(obj_bomberman, 0); break;
    case rm_missingno: _boss = instance_find(obj_missingno, 0); break;
    case rm_solgryn: _boss = instance_find(obj_solgryn, 0); break;
}
var _sleeping_spider = noone;
if (_stage != noone && _stage.cave_web_spider_wake_steps < 0) {
    _sleeping_spider = _stage.cave_web_spider;
}
var _start_x = x;
var _start_y = y;
var _reflected = reflected;
var _direction_x = _reflected ? dcos(reflection_angle) : travel_direction;
var _direction_y = _reflected ? -dsin(reflection_angle) : 0;
// The native Shoot movement scales displacement by elapsed time.
var _travel_speed = travel_speed * delta_time / 20000;
if (room == rm_milon) {
    // G704 adds four pixels of rightward travel to every bullet during flight.
    var _ride = instance_find(obj_milon_ride, 0);
    if (_ride != noone && _ride.mounted) {
        var _horizontal = _direction_x * _travel_speed + 4;
        var _vertical = _direction_y * _travel_speed;
        _travel_speed = point_distance(0, 0, _horizontal, _vertical);
        if (_travel_speed > 0) {
            _direction_x = _horizontal / _travel_speed;
            _direction_y = _vertical / _travel_speed;
        }
    }
}

// Check each crossed pixel so a shot cannot skip a checkpoint or backdrop.
for (var _distance = 0; _distance <= ceil(_travel_speed); ++_distance) {
    var _travel = min(_distance, _travel_speed);
    x = _start_x + _travel * _direction_x;
    y = _start_y + _travel * _direction_y;
    var _checkpoint = instance_place(x, y, obj_checkpoint);
    if (_checkpoint != noone && _player != noone) {
        _game.save_checkpoint(_player, _checkpoint);
        instance_destroy();
        exit;
    }
    if (_green_stage != noone && green_greens_middle_traps_shot(_green_stage)) {
        exit;
    }
    // These rooms destroy shots on backdrops. Active blocks have their own rules.
    if ((room == rm_shang_tsung || room == rm_kid_icarus || room == rm_bomberman || room == rm_ninja_gaiden || room == rm_missingno
        || room == rm_desert || room == rm_desert_secret || room == rm_final_path || room == rm_solgryn
        || room == rm_credits || room == rm_prize_room || room == rm_teleporter || room == rm_secret_jtv
        || room == rm_pokemon_puzzle || room == rm_wow || room == rm_cheetah_men)
        ? place_meeting(x, y, obj_player_backdrop) : place_meeting(x, y, [obj_solid, obj_player_backdrop])) {
        instance_destroy();
        exit;
    }
    if (room == rm_mega_man_world && place_meeting(x, y, obj_hazard)) {
        instance_destroy();
        exit;
    }
    if (room == rm_pokemon_puzzle && pokemon_puzzle_spike_hit()) {
        instance_destroy();
        exit;
    }
    if (room == rm_wow && place_meeting(x, y, obj_wow_bullet_blocker)) {
        instance_destroy();
        exit;
    }
    if (_boss != noone && _boss.take_player_shot(id)) {
        instance_destroy();
        exit;
    }
    if (room == rm_castlevania && castlevania_widget_hit(id)) {
        instance_destroy();
        exit;
    }
    if ((room == rm_milon && milon_hazard_shot()) || (room == rm_milon_depths && milon_depth_guard_shot())) {
        instance_destroy();
        exit;
    }
    if (room == rm_kid_icarus && kid_icarus_enemy_take_shot(id)) {
        instance_destroy();
        exit;
    }
    if (room == rm_bomberman && bomberman_ordnance_take_shot(id, _player)) {
        instance_destroy();
        exit;
    }
    if (room == rm_ninja_gaiden && ninja_enemy_take_shot(id)) {
        instance_destroy();
        exit;
    }
    if (room == rm_desert && (desert_switch_shot() || desert_boost_take_shot(_player))) {
        instance_destroy();
        exit;
    }
    if (!_reflected && reflected) {
        image_index = 1;
        break;
    }
    if (_sleeping_spider != noone && place_meeting(x, y, _sleeping_spider)) {
        with (_stage) {
            prehistorik_cave_wake_web_spider();
        }
        _sleeping_spider = noone;
    }
}

++age;
if (room == rm_shang_tsung || room == rm_kid_icarus || room == rm_bomberman || room == rm_ninja_gaiden
    || room == rm_desert || room == rm_desert_secret || room == rm_final_path || room == rm_solgryn
    || room == rm_credits || room == rm_prize_room || room == rm_teleporter || room == rm_secret_jtv
    || room == rm_pokemon_puzzle || room == rm_wow || room == rm_cheetah_men) {
    // Fusion culls these shots at the current window's 16-pixel margin.
    var _camera = view_camera[0];
    var _stage = noone;
    if (room == rm_ninja_gaiden) {
        _stage = instance_find(obj_ninja_gaiden, 0);
    } else if (room == rm_desert) {
        _stage = instance_find(obj_desert, 0);
    } else if (room == rm_secret_jtv) {
        _stage = instance_find(obj_secret_jtv, 0);
    } else if (room == rm_pokemon_puzzle) {
        _stage = instance_find(obj_pokemon_puzzle, 0);
    } else if (room == rm_wow) {
        _stage = instance_find(obj_wow, 0);
    }
    var _left = room == rm_bomberman ? 0 : camera_get_view_x(_camera);
    var _top = room == rm_bomberman ? 0 : camera_get_view_y(_camera);
    var _width = camera_get_view_width(_camera);
    var _height = camera_get_view_height(_camera);
    if (_stage != noone) {
        _left = _stage.page_left;
        _top = _stage.page_top;
        _width = 640;
        _height = 480;
    }
    if (room == rm_shang_tsung) {
        // G644 sets the logical window two pixels below the Viewport crop.
        _top += 2;
    }
    if (room == rm_solgryn && _boss != noone) {
        _left = _boss.view_left + 1;
        _top = _boss.view_top + 2;
    }
    if (age >= 60 || bbox_left <= _left - 16 || bbox_right >= _left + _width + 15
        || bbox_top <= _top - 16 || bbox_bottom >= _top + _height + 15) {
        instance_destroy();
    }
    exit;
}
if (age >= 60 || bbox_left <= -16 || bbox_right >= room_width + 15
    || bbox_top <= -16 || bbox_bottom >= room_height + 15) {
    instance_destroy();
}
