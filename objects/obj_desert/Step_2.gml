++stage_steps;
var _player = instance_find(obj_player, 0);
desert_moving_terrain_step(_player);
_player = instance_find(obj_player, 0);

var _route = instance_find(obj_desert_route, 0);
var _pickup_age = -1;
if (_route != noone) {
    _route.advance_route(_player);
    if (_route.prehistorik_pickup_slot >= 0) {
        _pickup_age = _route.prehistorik_pickup_age;
    }
    if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
        _route.show_trophy("TRIGGER FINGER!!");
    }
    _player = instance_find(obj_player, 0);
}
if (_player != noone) {
    update_view(_player, _pickup_age);
}
with (obj_desert_background_haze) {
    advance_haze(other.page_left);
}
if (_player == noone) {
    game_controller.fade_stage_music();
    exit;
}

if (_player.input_locked) {
    exit;
}
if (ninja_gaiden_toggle_cd()) {
    play_stage_track();
}
if (_route != noone) {
    // G500/G526 use the Player hotspot and half-open zones.
    if (_player.x >= 7899 && _player.x < 7977 && _player.y >= 244 && _player.y < 921
        && game_trophy_unlock("World11clear")) {
        _route.show_trophy("WORLD 11 CLEAR!");
    }
    if (_player.x >= 7719 && _player.x < 7797 && _player.y >= 245 && _player.y < 922
        && global.run.world_deaths <= 15 && game_trophy_unlock("World11PROMODE")) {
        _route.show_trophy("WORLD 11 PRO\nMODE!");
    }
}
