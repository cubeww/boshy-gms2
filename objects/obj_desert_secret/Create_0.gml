game_controller = instance_find(obj_game, 0);
entrance_sound = -1;
exit_age = -1;
exit_door = noone;
shake_strength = 0;
page_left = 0;
page_top = 0;

play_stage_track = function() {
    var _cd = ninja_gaiden_selected_cd();
    if (!is_undefined(_cd)) {
        game_controller.start_stage_music(_cd[2], true, true, _cd[3]);
    } else {
        if (global.run.ninja_gaiden_cd > 0) {
            global.run.ninja_gaiden_cd = 0;
            global.run.music_position = 0;
        }
        game_controller.start_stage_music(snd_desert_secret_music);
    }
};

update_view = function(_player, _floor) {
    if (_player != noone) {
        page_left = floor(_player.x / 640) * 640;
        page_top = floor(_player.y / 480) * 480;
    }
    var _top = page_top;
    if (_floor != noone) {
        // G638 ties the viewport to the rising floor through the whole shaft.
        _top = max(0, _floor.y - 290);
    }

    var _shake_x = 0;
    var _shake_y = 0;
    if (shake_strength > 0) {
        // G800 decays the timer before choosing the offsets.
        --shake_strength;
        if (shake_strength > 0) {
            _shake_x = irandom(shake_strength * 2 - 1) - shake_strength;
            _shake_y = irandom(shake_strength * 2 - 1) - shake_strength;
        }
    }
    if (instance_exists(obj_desert_secret_stone_beam)) {
        shake_strength = 5;
    }
    camera_set_view_pos(view_camera[0], page_left + _shake_x, _top + _shake_y);
};
