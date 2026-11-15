game_controller = instance_find(obj_game, 0);
stage_steps = 0;
page_left = 640;
page_top = 8160;
portal = noone;
portal_age = 0;
portal_sound = -1;

update_view = function(_player, _pickup_age) {
    // G638–640 use 640 × 480 pages. The shared Viewport crops the current page.
    page_left = floor(_player.x / 640) * 640;
    page_top = floor(_player.y / 480) * 480;
    var _camera = view_camera[0];
    camera_set_view_size(_camera, 640, 480);
    camera_set_view_pos(_camera, clamp(page_left, 0, room_width - 640), clamp(page_top, 0, room_height - 480));
    chest_view_update(game_controller, _player, _pickup_age);
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

game_controller.start_stage_music(snd_kid_icarus_music, true, true, 48000);
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
