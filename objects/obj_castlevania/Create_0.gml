game_controller = instance_find(obj_game, 0);
stage_steps = 0;
page_left = 0;
page_top = 960;

update_view = function(_player) {
    if (_player == noone) {
        return;
    }

    // Groups 642–648 advance the full source page before the pickup crop.
    page_left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
    page_top = clamp(floor(_player.y / 480) * 480, 0, room_height - 480);
    camera_set_view_size(view_camera[0], 640, 480);
    camera_set_view_pos(view_camera[0], page_left, page_top);
};

game_controller.start_stage_music(snd_castlevania_music, true, true, 48000);
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
update_view(instance_find(obj_player, 0));
