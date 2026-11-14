game_controller = instance_find(obj_game, 0);
stage_steps = 0;
page_left = 640;
page_top = 8160;
view_center_x = 960;
view_center_y = 8400;
view_width = 640;
portal = noone;
portal_age = 0;
portal_sound = -1;

update_view = function(_player, _pickup_age) {
    page_left = floor(_player.x / 640) * 640;
    page_top = floor(_player.y / 480) * 480;
    if (_pickup_age < 0) {
        // G638–640 use 640 × 480 pages. The underlying scroll position is six pixels below the crop.
        view_width = 640;
        view_center_x = page_left + 320;
        view_center_y = page_top + 240;
    } else if (_pickup_age < 200) {
        // G597 holds the final zoom through age 359 and G600 restores the page at 360.
        view_width = 640 - _pickup_age * 2;
        view_center_x = lerp(view_center_x, _player.x, 0.2) + sign(_player.x - view_center_x);
        view_center_y = lerp(view_center_y, _player.y, 0.2) + sign(_player.y - view_center_y);
    }

    var _width = view_width;
    var _height = round(_width * 3 / 4);
    var _camera = view_camera[0];
    camera_set_view_size(_camera, _width, _height);
    camera_set_view_pos(_camera,
        clamp(round(view_center_x - _width / 2), 0, room_width - _width),
        clamp(round(view_center_y - _height / 2), 0, room_height - _height));
};

play_stage_track = function() {
    switch (global.run.kid_icarus_cd) {
        case 9: game_controller.start_stage_music(snd_mega_man_world_wily_cd); break;
        case 10: game_controller.start_stage_music(snd_kid_icarus_live_cd); break;
        default: game_controller.start_stage_music(snd_kid_icarus_music, true, true, 48000); break;
    }
};

update_cd = function() {
    var _key = -1;
    var _keys = global.settings.keys;
    if (keyboard_check_pressed(ord("9")) && !game_key_is_bound(_keys, ord("9")) && game_has_item("Wily CD")) {
        _key = 9;
    } else if (keyboard_check_pressed(ord("0")) && !game_key_is_bound(_keys, ord("0")) && game_has_item("LIVE CD")) {
        _key = 10;
    }
    if (_key != -1) {
        global.run.kid_icarus_cd = global.run.kid_icarus_cd == _key ? 0 : _key;
        global.run.music_position = 0;
        play_stage_track();
    }
};

reset_portal = function() {
    if (portal != noone) {
        portal.image_index = 0;
        portal = noone;
    }
    portal_age = 0;
    game_controller.teleport_mosaic_columns = 0;
    game_controller.teleport_mosaic_rows = 0;
    if (portal_sound != -1) {
        audio_stop_sound(portal_sound);
        portal_sound = -1;
    }
};

if (!struct_exists(global.run, "kid_icarus_cd")) {
    global.run.kid_icarus_cd = 0;
}
play_stage_track();
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
