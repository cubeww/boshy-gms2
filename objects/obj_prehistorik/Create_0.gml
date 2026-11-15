game_controller = instance_find(obj_game, 0);
background_controller = instance_find(obj_prehistorik_clouds, 0);
trophy_title = "";
trophy_steps = -1;
arrival_steps = -1;
arrival_frame = 0;
arrival_sound = -1;
page_left = 0;
page_top = 0;

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
        page_left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
        page_top = clamp(floor(_player.y / 480) * 480, 0, room_height - 480);
    }
    camera_set_view_size(view_camera[0], 640, 480);
    camera_set_view_pos(view_camera[0], page_left, page_top);
    var _pickup_age = prehistorik_pickup_slot >= 0 ? prehistorik_pickup_age : -1;
    chest_view_update(game_controller, _player, _pickup_age);

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
