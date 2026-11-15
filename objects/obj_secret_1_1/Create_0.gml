game_controller = instance_find(obj_game, 0);
scroll_center_x = 736;
scroll_center_y = 240;
scroll_view_left = scroll_center_x - 320;
scroll_view_top = scroll_center_y - 240;
trophy_title = "";
trophy_steps = -1;

game_controller.start_stage_music(snd_secret_1_1_music);
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);

show_trophy = function(_title) {
    trophy_title = _title;
    trophy_steps = 0;
};
prehistorik_pickups_setup([inst_secret_1_1_mario_chest.pickup], spr_secret_1_1_mario_reveal, show_trophy);

update_view = function(_player) {
    // G626–630 move the horizontal camera only when the player gets ahead of it.
    if (_player.x > scroll_center_x + 50 && _player.hsp > 0) {
        scroll_center_x = floor(scroll_center_x + _player.hsp);
    }
    if (_player.x > scroll_center_x + 75) {
        scroll_center_x += 15;
    }
    if (_player.y > 340) {
        scroll_center_y = _player.y - 40;
    } else if (_player.y < 340) {
        scroll_center_y = 240;
    }

    // G628 uses the 640 by 480 scrolling window for the invisible Camera 3 solid.
    scroll_view_left = clamp(scroll_center_x - 320, 0, room_width - 640);
    scroll_view_top = clamp(scroll_center_y - 240, 0, room_height - 480);
    inst_secret_1_1_scroll_wall.x = scroll_view_left + 215;
    inst_secret_1_1_scroll_wall.y = scroll_view_top;

    camera_set_view_size(view_camera[0], 640, 480);
    camera_set_view_pos(view_camera[0], scroll_view_left, scroll_view_top);
    chest_view_update(game_controller, _player, prehistorik_pickup_slot >= 0 ? prehistorik_pickup_age : -1);
};

var _player = instance_find(obj_player, 0);
if (_player != noone) {
    update_view(_player);
}
