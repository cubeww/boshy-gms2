if (!portal_unlocked || stage_controller == noone) {
    exit;
}
if (stage_controller.active_portal == id) {
    image_index = 1;
    exit;
}

image_index = 0;
var _player = instance_find(obj_player, 0);
var _touching = _player != noone && !_player.dead && _player.boshy_mask_meeting(id);
if (_touching && !portal_touching && !_player.input_locked && stage_controller.active_portal == noone) {
    // The authored pads trigger on a fresh silhouette collision without an action key.
    stage_controller.begin_warp(id, _player);
    image_index = 1;
}
portal_touching = _touching;
