game_controller = instance_find(obj_game, 0);
stage_steps = 0;
entrance_sound = -1;
page_left = 0;
page_top = 0;
view_width = 640;
view_center_x = 320;
view_center_y = 238;

update_page = function(_player) {
    page_left = floor(_player.x / 640) * 640;
    page_top = floor(_player.y / 480) * 480;
};

update_view = function(_player, _pickup_age) {
    update_page(_player);

    var _target_width = _pickup_age < 0 ? 640 : 640 - min(_pickup_age, 200) * 2;
    var _target_x = page_left + 320;
    var _target_y = page_top + 238;
    if (_target_width < 640) {
        _target_x = _player.x;
        _target_y = _player.y;
    }
    if (_target_width == 640 && view_width >= 639) {
        // Swap normal gameplay pages in one update, matching the discrete viewport.
        view_width = 640;
        view_center_x = _target_x;
        view_center_y = _target_y;
    } else {
        view_width = lerp(view_width, _target_width, 0.2) + sign(_target_width - view_width);
        view_center_x = lerp(view_center_x, _target_x, 0.2) + sign(_target_x - view_center_x);
        view_center_y = lerp(view_center_y, _target_y, 0.2) + sign(_target_y - view_center_y);
    }

    var _width = clamp(round(view_width), 240, 640);
    var _height = round(_width * 0.75);
    var _camera = view_camera[0];
    camera_set_view_size(_camera, _width, _height);
    camera_set_view_pos(_camera, round(view_center_x - _width / 2), round(view_center_y - _height / 2));
};

play_stage_track = function() {
    var _cd = ninja_gaiden_selected_cd();
    if (is_undefined(_cd)) {
        if (global.run.ninja_gaiden_cd > 0) {
            global.run.ninja_gaiden_cd = 0;
            global.run.music_position = 0;
        }
        game_controller.start_stage_music(snd_desert_music);
    } else {
        game_controller.start_stage_music(_cd[2], true, true, _cd[3]);
    }
};
