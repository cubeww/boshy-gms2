++stage_steps;
var _player = instance_find(obj_player, 0);
if (room == rm_milon) {
    with (obj_milon_ride) {
        advance_milon_ride(_player, other.stage_steps);
    }
    _player = instance_find(obj_player, 0);
    // G909–910 count cumulative time in the castle's secret music zone.
    if (_player != noone && _player.x >= 5577 && _player.x < 6402 && ++milon_secret_steps == 10850) {
        game_controller.start_stage_music(snd_milon_secret_music, false, false);
    }
}

if (_player == noone) {
    game_controller.fade_stage_music();
} else {
    update_view(_player);
}

if (room == rm_milon) {
    update_rotation(_player);
} else {
    milon_depth_guards_step(_player);
}
