++stage_steps;
var _player = instance_find(obj_player, 0);
var _rewards = instance_find(obj_ninja_gaiden_rewards, 0);
var _pickup_age = -1;
if (_rewards != noone) {
    _rewards.advance_rewards(_player);
    if (_rewards.prehistorik_pickup_slot >= 0) {
        _pickup_age = _rewards.prehistorik_pickup_age;
    }
}

_player = instance_find(obj_player, 0);
var _route = instance_find(obj_ninja_gaiden_route, 0);
if (_route != noone) {
    _route.advance_route(_player);
}
_player = instance_find(obj_player, 0);
if (_player == noone) {
    game_controller.fade_stage_music();
    exit;
}
update_view(_player, _pickup_age);

// G1053–54 test contact before discarding the invisible trigger behind the player.
with (obj_ninja_gaiden_music_trigger) {
    if (_player.boshy_mask_meeting(id)) {
        other.restore_stage_track(true);
        instance_destroy();
    } else if (x < _player.x) {
        instance_destroy();
    }
}
if (!_player.input_locked && !scene_track_active) {
    update_cd();
}
