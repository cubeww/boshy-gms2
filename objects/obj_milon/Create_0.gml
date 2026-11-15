game_controller = instance_find(obj_game, 0);
stage_steps = 0;
page_left = 0;
page_top = room == rm_milon ? 960 : 1440;
rotation_amount = 0;
rotation_steps = 0;
rotation_sign = 1;
milon_secret_steps = 0;
milon_guard_question_steps = 10;
depth_phase_flipped = false;

update_view = function(_player) {
    if (_player == noone) {
        return;
    }

    page_left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
    page_top = clamp(floor(_player.y / 480) * 480, 0, room_height - 480);
    camera_set_view_size(view_camera[0], 640, 480);
    camera_set_view_pos(view_camera[0], page_left, page_top);
};

update_rotation = function(_player) {
    // The trigger can touch Boshy's sprite before the camera reaches the rotation page.
    var _zone = instance_find(obj_milon_rotation_zone, 0);
    var _zone_on_page = _zone != noone && _zone.bbox_left < page_left + 640 && _zone.bbox_right >= page_left
        && _zone.bbox_top < page_top + 480 && _zone.bbox_bottom >= page_top;
    if (!_zone_on_page || (_player != noone && !_player.boshy_mask_meeting(_zone))) {
        game_controller.screen_rotation = 0;
        rotation_amount = 0;
        rotation_steps = 0;
        rotation_sign = 1;
        return;
    }

    // G643–652 apply the previous angle before G806–808 update the rotation trigger.
    game_controller.screen_rotation = rotation_sign * rotation_amount;
    if (rotation_amount > 0 && ++rotation_steps == 3) {
        rotation_steps = 0;
        rotation_sign = -rotation_sign;
        --rotation_amount;
    }
    if (_player != noone) {
        ++rotation_amount;
    }
};

var _music = room == rm_milon ? snd_milon_music : snd_milon_depths_music;
game_controller.start_stage_music(_music, true, true);
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
