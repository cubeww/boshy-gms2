page_left = 0;
conveyor_frame = 0;
shake_steps = 0;
portal = inst_tutorial_portal;
portal_steps = -1;
portal_duration = 80;
portal_frame = 0;
trigger_finger_age = -1;
game_controller = instance_find(obj_game, 0);

// Original Active 4, Active 5, and Active 13 strips, from left to right.
recovery_strips = [
    { left: 1664, right: 1920, return_x: 1370, return_y: 400 },
    { left: 1920, right: 2624, return_x: 2127, return_y: 249 },
    { left: 2624, right: 3360, return_x: 2671, return_y: 313 }
];

update_page = function(_player) {
    if (_player != noone) {
        page_left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
    }

    var _view_x = page_left;
    var _view_y = 0;
    if (shake_steps > 0) {
        --shake_steps;
        _view_x += irandom_range(-shake_steps, shake_steps);
        _view_y += irandom_range(-shake_steps, shake_steps);
    }

    camera_set_view_pos(view_camera[0], _view_x, _view_y);
    layer_x("Background", _view_x);
    layer_y("Background", _view_y);
};

game_controller.start_stage_music(snd_tutorial_music);
entrance_instance = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
update_page(instance_find(obj_player, 0));
