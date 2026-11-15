game_controller = instance_find(obj_game, 0);
stage_steps = 0;
page_left = 0;
page_top = 0;
entrance_sound = -1;
scene_track_active = false;

update_page = function(_player) {
    page_left = floor(_player.x / 640) * 640;
    page_top = floor(_player.y / 480) * 480;
};

update_view = function(_player, _pickup_age) {
    // G640–642 select the page that the Viewport samples.
    update_page(_player);
    var _camera = view_camera[0];
    camera_set_view_size(_camera, 640, 480);
    camera_set_view_pos(_camera, clamp(page_left, 0, room_width - 640), clamp(page_top, 0, room_height - 480));
    chest_view_update(game_controller, _player, _pickup_age);
};

set_scene_track = function(_sound) {
    if (!scene_track_active) {
        game_controller.remember_stage_music();
    }
    scene_track_active = true;
    if (_sound == noone) {
        game_controller.stop_stage_music();
    } else {
        // The prologue, resumed Ninja fight cue and MissingNo. intro each play once.
        game_controller.start_stage_music(_sound, false, false);
    }
};

restore_stage_track = function(_restart = false) {
    scene_track_active = false;
    if (_restart) {
        // G1053 explicitly runs the original stage's startMusic event.
        global.run.music_position = 0;
    }
    game_controller.start_stage_music(snd_ninja_gaiden_music);
};
