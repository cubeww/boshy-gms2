function teleporter_exploration_key(_room) {
    switch (_room) {
        case rm_prehistorik: return "W1";
        case rm_hello_kitty: return "B1";
        case rm_green_greens: return "W2";
        case rm_king_dedede: return "MB1";
        case rm_ryu: return "B2";
        case rm_cheetahmen: return "W3";
        case rm_mario: return "B3";
        case rm_vvvvvv: return "W4";
        case rm_biollante: return "B4";
        case rm_wario: return "W5";
        case rm_sanicz: return "B5";
        case rm_castlevania: return "W6";
        case rm_skeleton_king: return "B6";
        case rm_milon: return "W7";
        case rm_mega_man: return "B7";
        case rm_mega_man_world: return "W8";
        case rm_shang_tsung: return "B8";
        case rm_kid_icarus: return "W9";
        case rm_bomberman: return "B9";
        case rm_ninja_gaiden: return "W10";
        case rm_missingno: return "B10";
        case rm_desert: return "W11";
        case rm_final_path: return "W12";
        case rm_solgryn: return "B11";
        case rm_credits: return "P";
    }
    return "";
}

function game_has_explored(_key) {
    return _key == "" || struct_exists(game_current_progress().exploration, _key);
}

function game_mark_explored(_key) {
    if (!game_has_explored(_key)) {
        var _progress = game_current_progress();
        struct_set(_progress.exploration, _key, true);
        global.profile.dirty = true;
        return true;
    }
    return false;
}

function teleporter_restore_legacy_exploration(_slot, _room) {
    // Before this room was ported, ordinary campaign saves only advanced along the story route.
    static _story = [
        rm_prehistorik, rm_hello_kitty, rm_green_greens, rm_king_dedede, rm_ryu,
        rm_cheetahmen, rm_gastly, rm_mario, rm_vvvvvv, rm_biollante, rm_wario, rm_sanicz,
        rm_castlevania, rm_gradius, rm_skeleton_king, rm_milon, rm_milon_depths, rm_mega_man,
        rm_mega_man_world, rm_shang_tsung, rm_kid_icarus, rm_bomberman, rm_ninja_gaiden, rm_missingno,
        rm_desert, rm_desert_secret, rm_final_path, rm_solgryn, rm_credits, rm_prize_room
    ];
    var _limit = _slot.credits_seen ? array_length(_story) - 1 : -1;
    // The Milon return portal could save in Prehistorik again after W7 was reached.
    static _bosses = [
        [rm_hello_kitty, "HelloKitty"], [rm_ryu, "Ryu"], [rm_mario, "Mario"], [rm_biollante, "Biollante"],
        [rm_sanicz, "Sonic"], [rm_skeleton_king, "SkeletonKing"], [rm_mega_man, "MegaMan"],
        [rm_shang_tsung, "ShangTsung"], [rm_bomberman, "Ganon"], [rm_missingno, "Missingno"], [rm_solgryn, "Solgryn"]
    ];
    for (var _i = _limit + 1; _i < array_length(_story); ++_i) {
        if (_story[_i] == _room) {
            _limit = _i;
        }
        for (var _j = 0; _j < array_length(_bosses); ++_j) {
            if (_story[_i] == _bosses[_j][0] && struct_exists(_slot.trophies, _bosses[_j][1])) {
                _limit = _i;
                break;
            }
        }
    }
    for (var _i = 0; _i <= _limit; ++_i) {
        var _key = teleporter_exploration_key(_story[_i]);
        if (_key != "") {
            struct_set(_slot.exploration, _key, true);
        }
    }
}

function game_travel_by_teleporter(_room, _x = undefined, _y = undefined, _play_arrival = true, _boss_rush_key = "") {
    if (_room == rm_teleporter && (room == rm_ninja_gaiden || room == rm_desert || room == rm_final_path)
        && game_mark_explored("W10")) {
        game_profile_save();
    }
    var _position = undefined;
    if (!is_undefined(_x) && !is_undefined(_y) && (_x != 0 || _y != 0)) {
        _position = { x: _x, y: _y };
    }
    global.teleporter_travel = {
        destination: _room,
        position: _position,
        play_arrival: _play_arrival,
        boss_rush_key: _boss_rush_key
    };
    room_goto(_room);
}

function teleporter_warp_motion(_player, _portal, _age) {
    with (_player) {
        refresh_collision_probes();
        move_player_horizontal(false);
        move_player_vertical();
        if (vsp > 7) {
            --vsp;
        }
    }
    if (_player.x > _portal.x) {
        _player.x -= 5;
    }
    if (_player.x < _portal.x) {
        _player.x += 5;
    }
    if (_player.y > _portal.y - 20) {
        --_player.vsp;
    }
    _player.image_angle += _age;
}

function teleporter_apply_exit_mosaic(_game, _age) {
    var _pixel_size = max(1, floor(_age * 0.6));
    _game.teleport_mosaic_columns = 640 div _pixel_size;
    _game.teleport_mosaic_rows = 480 div _pixel_size;
}

function teleporter_draw_exit(_age) {
    var _camera = view_camera[0];
    var _left = camera_get_view_x(_camera);
    var _top = camera_get_view_y(_camera);
    var _scale = camera_get_view_width(_camera) / 640;
    var _frame = min(floor(_age * 0.6), sprite_get_number(spr_tutorial_portal_transition) - 1);
    draw_sprite_ext(spr_tutorial_portal_transition, _frame, _left, _top, _scale, _scale, 0, c_white, 1);
}
