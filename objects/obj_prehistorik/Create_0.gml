game_controller = instance_find(obj_game, 0);
background_controller = instance_find(obj_prehistorik_clouds, 0);
trophy_title = "";
trophy_steps = -1;
arrival_steps = -1;
arrival_frame = 0;
arrival_sound = -1;
page_left = 0;
page_top = 0;
pickup_view_width = 640;
pickup_view_x = 320;
pickup_view_y = 240;

game_controller.start_stage_music(snd_prehistorik_music);
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
if (variable_global_exists("prehistorik_portal_arrival") && global.prehistorik_portal_arrival) {
    global.prehistorik_portal_arrival = false;
    arrival_steps = 0;
    arrival_sound = audio_play_sound(snd_prehistorik_descend, 1, false);
}

live_player = function() {
    var _player = instance_find(obj_player, 0);
    return _player == noone || _player.dead ? noone : _player;
};

update_view = function(_player) {
    if (_player != noone) {
        var _page_left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
        var _page_top = clamp(floor(_player.y / 480) * 480, 0, room_height - 480);
        if (_page_left != page_left || _page_top != page_top) {
            page_left = _page_left;
            page_top = _page_top;
            pickup_view_width = 640;
            pickup_view_x = page_left + 320;
            pickup_view_y = page_top + 240;
        }
    }
    if (_player != noone && prehistorik_pickup_slot >= 0) {
        var _target_width = 640 - min(prehistorik_pickup_age, 200) * 2;
        pickup_view_width = lerp(pickup_view_width, _target_width, 0.2);
        pickup_view_x = lerp(pickup_view_x, _player.x, 0.2);
        pickup_view_y = lerp(pickup_view_y, _player.y + 5, 0.2);
    } else {
        pickup_view_width = 640;
        pickup_view_x = page_left + 320;
        pickup_view_y = page_top + 240;
    }

    // Keep exact 4:3 pixel dimensions throughout the native 20% easing.
    var _size = round(pickup_view_width / 4);
    var _width = _size * 4;
    var _height = _size * 3;
    var _left = clamp(round(pickup_view_x - _width / 2), 0, room_width - _width);
    var _top = clamp(round(pickup_view_y - _height / 2), 0, room_height - _height);
    camera_set_view_size(view_camera[0], _width, _height);
    camera_set_view_pos(view_camera[0], _left, _top);

    background_controller.page_left = page_left;
    background_controller.page_top = page_top;
    // The source sky layer moves at 5% of the horizontal camera travel and stays fixed vertically.
    layer_x("Background", round(page_left * 0.95));
    layer_y("Background", page_top);
};

prehistorik_show_trophy = function(_title) {
    trophy_title = _title;
    trophy_steps = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
};

prehistorik_opening_setup();
prehistorik_cave_setup();
prehistorik_upper_setup();
prehistorik_exit_setup();
prehistorik_pickups_setup();
update_view(live_player());
