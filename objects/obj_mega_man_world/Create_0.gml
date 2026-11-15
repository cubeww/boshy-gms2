game_controller = instance_find(obj_game, 0);
portal_age = -1;
portal_frame = 0;
portal_sound = -1;
portal_contact = false;

update_view = function(_player) {
    // G645–647 select the 640 × 480 page that the Viewport samples.
    var _page_left = floor(_player.x / 640) * 640;
    var _page_top = floor(_player.y / 480) * 480;
    var _camera = view_camera[0];
    camera_set_view_size(_camera, 640, 480);
    camera_set_view_pos(_camera, clamp(_page_left, 0, room_width - 640), clamp(_page_top, 0, room_height - 480));

    var _rewards = instance_find(obj_mega_man_world_rewards, 0);
    var _pickup_age = _rewards != noone && _rewards.prehistorik_pickup_slot >= 0 ? _rewards.prehistorik_pickup_age : -1;
    chest_view_update(game_controller, _player, _pickup_age);
};

game_controller.start_stage_music(snd_mega_man_world_music);
entrance_voice = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
