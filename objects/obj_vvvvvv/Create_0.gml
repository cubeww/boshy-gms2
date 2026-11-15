game_controller = instance_find(obj_game, 0);
page_left = 0;
page_top = 0;
trophy_title = "";
trophy_steps = -1;
portal_steps = -1;
portal_sound = -1;

vvvvvv_show_trophy = function(_title) {
    trophy_title = _title;
    trophy_steps = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
};

wrap_camera_page = function(_position, _page_size, _wrapped_page) {
    var _page = floor(_position / _page_size) * _page_size;
    if (!is_undefined(_wrapped_page) && _page != _wrapped_page
        && _position >= _wrapped_page - 32 && _position < _wrapped_page + _page_size + 32) {
        // A wrap marker can overlap Boshy's silhouette while the hotspot is still beyond the seam.
        return _wrapped_page;
    }
    return undefined;
};

update_view = function(_player) {
    if (_player == noone) {
        chest_view_update(game_controller, noone, -1);
        return;
    }

    // Fusion groups 698–700 follow the hotspot. Keep the same page while an in-page wrap clears the seam.
    _player.wrap_page_x = wrap_camera_page(_player.x, 640, _player.wrap_page_x);
    _player.wrap_page_y = wrap_camera_page(_player.y, 480, _player.wrap_page_y);
    var _left = is_undefined(_player.wrap_page_x) ? floor(_player.x / 640) * 640 : _player.wrap_page_x;
    var _top = is_undefined(_player.wrap_page_y) ? floor(_player.y / 480) * 480 : _player.wrap_page_y;
    page_left = clamp(_left, 0, room_width - 640);
    page_top = clamp(_top, 0, room_height - 480);
    camera_set_view_size(view_camera[0], 640, 480);
    camera_set_view_pos(view_camera[0], page_left, page_top);
    var _pickup_age = prehistorik_pickup_slot >= 0 ? prehistorik_pickup_age : -1;
    chest_view_update(game_controller, _player, _pickup_age);
};

prehistorik_pickups_setup([inst_vvvvvv_chest_chocolate.pickup, inst_vvvvvv_chest_timer.pickup],
    spr_vvvvvv_pickup_reveals, vvvvvv_show_trophy);
game_controller.start_stage_music(snd_vvvvvv_music);
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
update_view(instance_find(obj_player, 0));
