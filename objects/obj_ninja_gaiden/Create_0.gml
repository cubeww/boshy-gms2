game_controller = instance_find(obj_game, 0);
stage_steps = 0;
page_left = 0;
page_top = 0;
view_center_x = 320;
view_center_y = 240;
view_width = 640;
entrance_sound = -1;
scene_track_active = false;

update_page = function(_player) {
    page_left = floor(_player.x / 640) * 640;
    page_top = floor(_player.y / 480) * 480;
};

update_view = function(_player, _pickup_age) {
    // G640–642 use the player's page for the normal crop and the underlying scroll.
    update_page(_player);
    var _target_width = 640;
    if (_pickup_age >= 0) {
        _target_width = 640 - min(_pickup_age, 200) * 2;
    }

    if (_target_width == 640 && view_width >= 639) {
        view_width = 640;
        view_center_x = page_left + 320;
        view_center_y = page_top + 240;
    } else {
        view_width = lerp(view_width, _target_width, 0.2) + sign(_target_width - view_width);
        if (_target_width < 640) {
            view_center_x = lerp(view_center_x, _player.x, 0.2) + sign(_player.x - view_center_x);
            view_center_y = lerp(view_center_y, _player.y - 8, 0.2) + sign(_player.y - 8 - view_center_y);
        } else {
            view_center_x = page_left + 320;
            view_center_y = page_top + 240;
        }
    }

    var _width = clamp(round(view_width), 240, 640);
    var _height = round(_width * 0.75);
    var _left = round(view_center_x - _width / 2);
    var _top = round(view_center_y - _height / 2);
    if (_pickup_age < 0) {
        _left = clamp(_left, 0, room_width - _width);
        _top = clamp(_top, 0, room_height - _height);
    }
    var _camera = view_camera[0];
    camera_set_view_size(_camera, _width, _height);
    camera_set_view_pos(_camera, _left, _top);
};

play_stage_track = function() {
    var _cd = global.run.ninja_gaiden_cd;
    if (_cd > 0) {
        var _entry = ninja_gaiden_selected_cd();
        if (!is_undefined(_entry)) {
            game_controller.start_stage_music(_entry[2], true, true, _entry[3]);
            return;
        }
        global.run.ninja_gaiden_cd = 0;
        global.run.music_position = 0;
    }
    game_controller.start_stage_music(snd_ninja_gaiden_music);
};

set_scene_track = function(_sound) {
    if (!scene_track_active) {
        game_controller.remember_stage_music();
    }
    scene_track_active = true;
    if (_sound == noone) {
        if (game_controller.stage_music_instance != -1) {
            audio_stop_sound(game_controller.stage_music_instance);
            game_controller.stage_music_instance = -1;
        }
    } else {
        // The prologue, resumed Ninja fight cue and MissingNo. intro each play once.
        game_controller.start_stage_music(_sound, false, false);
    }
};

restore_stage_track = function(_restart = false) {
    scene_track_active = false;
    if (_restart) {
        // G1053 restarts the normal track even when a CD was selected at entry.
        global.run.music_position = 0;
        game_controller.start_stage_music(snd_ninja_gaiden_music, true, global.run.ninja_gaiden_cd == 0);
    } else {
        play_stage_track();
    }
};

update_cd = function() {
    // G117–128 return to the original track on the first CD key press.
    if (ninja_gaiden_toggle_cd()) {
        play_stage_track();
    }
};
