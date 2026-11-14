++stage_steps;

var _player = instance_find(obj_player, 0);
prehistorik_pickups_step(_player);
if (_player == noone || _player.dead) {
    game_controller.fade_stage_music();
    exit;
}

page_left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
if (prehistorik_pickup_slot >= 0) {
    // The source zooms toward the character chest during the reveal.
    var _age = min(prehistorik_pickup_age, 200);
    view_width = lerp(view_width, 640 - _age * 2, 0.2);
    view_center_x = lerp(view_center_x, _player.x, 0.2);
    view_center_y = lerp(view_center_y, _player.y + 5, 0.2);
} else {
    view_width = 640;
    view_center_x = page_left + 320;
    view_center_y = 240;
}
var _width = round(view_width / 4) * 4;
var _height = _width * 3 / 4;
var _camera = view_camera[0];
camera_set_view_size(_camera, _width, _height);
camera_set_view_pos(_camera, clamp(round(view_center_x - _width / 2), 0, room_width - _width),
    clamp(round(view_center_y - _height / 2), 0, room_height - _height));

var _portal = inst_prize_room_hub_portal;
if (portal_steps >= 0) {
    // G971–976 align and lift the player before the native hub handoff.
    teleporter_warp_motion(_player, _portal, ++portal_steps);
    teleporter_apply_exit_mosaic(game_controller, portal_steps);
    if (portal_steps >= 80) {
        game_travel_by_teleporter(_portal.destination_room, _portal.destination_x, _portal.destination_y);
    }
    exit;
}

var _touching = _player.boshy_mask_meeting(_portal);
if (_touching && !portal_touching && !_player.input_locked) {
    portal_steps = 0;
    _player.input_locked = true;
    _player.hsp = 0;
    _portal.image_index = 1;
    portal_sound = audio_play_sound(snd_tutorial_teleport, 1, false);
}
portal_touching = _touching;
