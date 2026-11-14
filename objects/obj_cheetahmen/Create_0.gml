game_controller = instance_find(obj_game, 0);
page_left = 0;
page_top = 0;
view_width = 640;
view_center_x = 320;
view_center_y = 240;
trophy_title = "";
trophy_steps = -1;
pipe_steps = -1;
pipe_sound = -1;

live_player = function() {
    var _player = instance_find(obj_player, 0);
    return _player == noone || _player.dead ? noone : _player;
};

player_overlaps = function(_player, _left, _top, _right, _bottom) {
    return _player.bbox_left < _right && _player.bbox_right >= _left
        && _player.bbox_top < _bottom && _player.bbox_bottom >= _top;
};

cheetahmen_show_trophy = function(_title) {
    trophy_title = _title;
    trophy_steps = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
};

update_view = function(_player) {
    if (_player != noone) {
        var _left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
        var _top = clamp(floor(_player.y / 480) * 480, 0, room_height - 480);
        if (page_left != _left || page_top != _top) {
            page_left = _left;
            page_top = _top;
            view_width = 640;
            view_center_x = _left + 320;
            view_center_y = _top + 240;
        }
        if (prehistorik_pickup_slot >= 0) {
            view_width = lerp(view_width, 640 - min(prehistorik_pickup_age, 200) * 2, 0.2);
            view_center_x = lerp(view_center_x, _player.x, 0.2);
            view_center_y = lerp(view_center_y, _player.y + 5, 0.2);
        } else {
            view_width = 640;
            view_center_x = _left + 320;
            view_center_y = _top + 240;
        }
    }

    var _width = round(view_width / 4) * 4;
    var _height = _width * 3 / 4;
    camera_set_view_size(view_camera[0], _width, _height);
    camera_set_view_pos(view_camera[0], clamp(round(view_center_x - _width / 2), 0, room_width - _width),
        clamp(round(view_center_y - _height / 2), 0, room_height - _height));
};

cheetahmen_early_setup();
cheetahmen_late_setup();
prehistorik_pickups_setup([inst_cheetahmen_chest_rickroll.pickup, inst_cheetahmen_chest_quote.pickup],
    spr_cheetahmen_rickroll_reveal, cheetahmen_show_trophy);
game_controller.start_stage_music(snd_cheetahmen_music);
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
update_view(live_player());
