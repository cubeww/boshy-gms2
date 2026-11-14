game_controller = instance_find(obj_game, 0);
view_width = 640;
view_center_x = 960;
view_center_y = 240;
portal_age = -1;
portal_frame = 0;
portal_sound = -1;
portal_contact = false;
exit_notice = "";
exit_notice_steps = 0;

update_view = function(_player) {
    var _rewards = instance_find(obj_mega_man_world_rewards, 0);
    if (_rewards != noone && _rewards.prehistorik_pickup_slot >= 0) {
        // G598 shrinks the view for 199 steps and eases its center toward the player.
        var _age = _rewards.prehistorik_pickup_age;
        view_width = 640 - min(_age, 199) * 2;
        view_center_x = lerp(view_center_x, _player.x, 0.2);
        view_center_y = lerp(view_center_y, _player.y, 0.2);
    } else {
        // G645–647 use 640 × 480 pages. The underlying frame scrolls six pixels below the crop.
        view_width = 640;
        view_center_x = (floor(_player.x / 640) + 0.5) * 640;
        view_center_y = (floor(_player.y / 480) + 0.5) * 480;
    }

    var _width = round(view_width / 4) * 4;
    var _height = _width * 3 / 4;
    var _camera = view_camera[0];
    camera_set_view_size(_camera, _width, _height);
    camera_set_view_pos(_camera,
        clamp(round(view_center_x - _width / 2), 0, room_width - _width),
        clamp(round(view_center_y - _height / 2), 0, room_height - _height));
};

set_stage_track = function(_play_cd) {
    var _track = _play_cd ? snd_mega_man_world_wily_cd : snd_mega_man_world_music;
    game_controller.start_stage_music(_track);
};

show_exit_notice = function(_text) {
    exit_notice = _text;
    exit_notice_steps = 100;
};

if (!struct_exists(global.run, "mega_man_world_wily_cd")) {
    global.run.mega_man_world_wily_cd = false;
}
set_stage_track(global.run.mega_man_world_wily_cd);
entrance_voice = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
