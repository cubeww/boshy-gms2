game_controller = instance_find(obj_game, 0);
page_left = 0;
page_top = 0;
shake_steps = 0;
trigger_finger_age = -1;

shake_view = function(_steps) {
    shake_steps = max(shake_steps, _steps);
};

update_view = function(_player) {
    // G630–642 track the player's page and use the Viewport to crop it.
    page_left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
    page_top = clamp(floor(_player.y / 480) * 480, 0, room_height - 480);
    var _camera = view_camera[0];
    camera_set_view_size(_camera, 640, 481);
    camera_set_view_pos(_camera, page_left - 1, page_top - 2);
};

// G61 plays the entry voice and starts the stage's Grasstown loop.
game_controller.start_stage_music(snd_secret_jtv_music);
play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);

var _player = instance_find(obj_player, 0);
if (_player != noone) {
    update_view(_player);
}
