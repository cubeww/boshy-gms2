game_controller = instance_find(obj_game, 0);
page_left = 0;
page_top = 0;
kracko_shake_x = 0;
kracko_shake_y = 0;
view_rotation = 0;
rotating_view = false;
flip_view_steps = -1;
pickup_view_width = 640;
pickup_view_x = 320;
pickup_view_y = 240;
trophy_title = "";
trophy_steps = -1;

live_player = function() {
    var _player = instance_find(obj_player, 0);
    return _player == noone || _player.dead ? noone : _player;
};

green_greens_show_trophy = function(_title) {
    trophy_title = _title;
    trophy_steps = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
};

player_overlaps = function(_player, _left, _top, _right, _bottom) {
    return _player.bbox_left < _right && _player.bbox_right > _left
        && _player.bbox_top < _bottom && _player.bbox_bottom > _top;
};

update_view = function(_player) {
    if (_player != noone) {
        var _left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
        var _top = clamp(floor(_player.y / 480) * 480, 0, room_height - 480);
        if (_left != page_left || _top != page_top) {
            page_left = _left;
            page_top = _top;
            pickup_view_width = 640;
            pickup_view_x = _left + 320;
            pickup_view_y = _top + 240;
        }
        if (prehistorik_pickup_slot >= 0) {
            pickup_view_width = lerp(pickup_view_width, 640 - min(prehistorik_pickup_age, 200) * 2, 0.2);
            pickup_view_x = lerp(pickup_view_x, _player.x, 0.2);
            pickup_view_y = lerp(pickup_view_y, _player.y + 5, 0.2);
        } else {
            pickup_view_width = 640;
            pickup_view_x = _left + 320;
            pickup_view_y = _top + 240;
        }
    } else {
        kracko_shake_steps = 0;
        kracko_shake_x = 0;
        kracko_shake_y = 0;
    }

    var _size = round(pickup_view_width / 4);
    var _width = _size * 4;
    var _height = _size * 3;
    view_base_x = clamp(round(pickup_view_x - _width / 2), 0, room_width - _width);
    view_base_y = clamp(round(pickup_view_y - _height / 2), 0, room_height - _height);
    // Pan the world view, including the arena vignette and boss health bar.
    camera_set_view_size(view_camera[0], _width, _height);
    camera_set_view_pos(view_camera[0], view_base_x + kracko_shake_x, view_base_y + kracko_shake_y);

    // Fusion group 1045 rolls the offsets for the next frame after decaying the shake.
    kracko_shake_steps = max(0, kracko_shake_steps - 1);
    kracko_shake_x = 0;
    kracko_shake_y = 0;
    if (kracko_shake_steps > 0) {
        kracko_shake_x = irandom_range(-kracko_shake_steps, kracko_shake_steps - 1);
        kracko_shake_y = irandom_range(-kracko_shake_steps, kracko_shake_steps - 1);
    }
};

green_greens_events_setup();
green_greens_kracko_setup();
green_greens_pickups_setup();

var _player = live_player();
region_music = _player.x < 2550 ? snd_green_greens_music : snd_green_greens_plains;
game_controller.start_stage_music(region_music);
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
update_view(_player);
