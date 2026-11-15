++stage_steps;
var _player = instance_find(obj_player, 0);
if (_player == noone) {
    game_controller.fade_stage_music();
}
update_view(_player);
