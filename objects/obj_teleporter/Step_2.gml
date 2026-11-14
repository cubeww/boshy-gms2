var _player = instance_find(obj_player, 0);
if (_player == noone) {
    game_controller.fade_stage_music();
    exit;
}

sonic_notice_age = max(0, sonic_notice_age - 1);
// G1204 ejects the native Sonic costume from the Boss Rush wing.
if (global.profile.character_id == 88 && _player.boshy_mask_meeting(obj_teleporter_rush_boundary)) {
    _player.x = 1862;
    _player.y = 427;
    _player.refresh_collision_probes();
    sonic_notice_age = 150;
}
page_left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
camera_set_view_pos(view_camera[0], page_left, 0);

var _label = teleporter_portal_label(_player);
if (_label != noone) {
    label_portal = _label;
}
if (active_portal == noone) {
    exit;
}

++warp_age;
teleporter_warp_motion(_player, active_portal, warp_age);
teleporter_apply_exit_mosaic(game_controller, warp_age);
if (warp_age >= 80) {
    var _route = active_portal.route;
    game_travel_by_teleporter(_route.room_id, _route.x, _route.y);
}
