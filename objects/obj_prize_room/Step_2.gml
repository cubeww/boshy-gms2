var _player = instance_find(obj_player, 0);
prehistorik_pickups_step(_player);
var _previous_page = page_left;
if (_player != noone && !_player.dead) {
    page_left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
}
var _page_change = page_left - _previous_page;
with (obj_prize_room_background) {
    if (scroll_speed != 0) {
        // G980–988 use the pending page edges before Fusion scrolls the layer.
        x -= scroll_speed;
        if (x <= _page_change - wrap_left_margin) {
            x += scroll_period;
        }
        if (x > _page_change + 640 + 100) {
            x -= scroll_period;
        }
    }
}
if (_player == noone || _player.dead) {
    chest_view_update(game_controller, noone, -1);
    game_controller.fade_stage_music();
    exit;
}

camera_set_view_size(view_camera[0], 640, 480);
camera_set_view_pos(view_camera[0], page_left, 0);
var _pickup_age = prehistorik_pickup_slot >= 0 ? prehistorik_pickup_age : -1;
chest_view_update(game_controller, _player, _pickup_age);

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
