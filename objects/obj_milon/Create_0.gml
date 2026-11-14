game_controller = instance_find(obj_game, 0);
stage_steps = 0;
page_left = 0;
page_top = room == rm_milon ? 960 : 1440;
view_width = 640;
view_center_x = 320;
view_center_y = page_top + 240;
rotation_amount = 0;
rotation_steps = 0;
rotation_sign = 1;
milon_secret_steps = 0;
milon_guard_question_steps = 10;
depth_phase_flipped = false;

update_view = function(_player) {
    // The Fusion frames scroll in 640 × 480 pages and zoom in for secret pickups.
    page_left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
    page_top = clamp(floor(_player.y / 480) * 480, 0, room_height - 480);
    var _pickups = instance_find(obj_milon_pickups, 0);
    if (_pickups != noone && _pickups.prehistorik_pickup_slot >= 0) {
        var _age = min(_pickups.prehistorik_pickup_age, 200);
        view_width = lerp(view_width, 640 - _age * 2, 0.2);
        view_center_x = lerp(view_center_x, _player.x, 0.2);
        view_center_y = lerp(view_center_y, _player.y + 6, 0.2);
    } else {
        view_width = 640;
        view_center_x = page_left + 320;
        view_center_y = page_top + 240;
    }

    var _width = round(view_width / 4) * 4;
    var _height = _width * 3 / 4;
    var _camera = view_camera[0];
    camera_set_view_size(_camera, _width, _height);
    camera_set_view_pos(_camera,
        clamp(round(view_center_x - _width / 2), 0, room_width - _width),
        clamp(round(view_center_y - _height / 2), 0, room_height - _height));
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
