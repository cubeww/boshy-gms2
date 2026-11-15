game_controller = instance_find(obj_game, 0);
page_left = 0;
page_top = 0;
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
        page_left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
        page_top = clamp(floor(_player.y / 480) * 480, 0, room_height - 480);
    }
    camera_set_view_size(view_camera[0], 640, 480);
    camera_set_view_pos(view_camera[0], page_left, page_top);
    var _pickup_age = prehistorik_pickup_slot >= 0 ? prehistorik_pickup_age : -1;
    chest_view_update(game_controller, _player, _pickup_age);
};

cheetahmen_early_setup();
cheetahmen_late_setup();
prehistorik_pickups_setup([inst_cheetahmen_chest_rickroll.pickup, inst_cheetahmen_chest_quote.pickup],
    spr_cheetahmen_rickroll_reveal, cheetahmen_show_trophy);
game_controller.start_stage_music(snd_cheetahmen_music);
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
update_view(live_player());
