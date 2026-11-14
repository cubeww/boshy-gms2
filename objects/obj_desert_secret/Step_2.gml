var _player = instance_find(obj_player, 0);
var _floor = instance_find(obj_desert_secret_rising_floor, 0);
if (_floor != noone) {
    _floor.advance(_player);
    _player = instance_find(obj_player, 0);
}
if (_player == noone) {
    game_controller.fade_stage_music();
    update_view(noone, _floor);
    exit;
}

if (exit_age < 0 && !_player.input_locked) {
    var _door = instance_find(obj_desert_secret_exit, 0);
    if (_door != noone && _player.boshy_mask_meeting(_door)) {
        // G967–968 hold the player inside the door until the destination is set.
        exit_door = _door;
        exit_age = 0;
        _player.input_locked = true;
        _player.hsp = 0;
        _player.vsp = 0;
    }
}
if (exit_age >= 0) {
    _player.x = exit_door.door_hold_x;
    _player.y = exit_door.door_hold_y;
    _player.refresh_collision_probes();
    if (++exit_age == 40) {
        // G969's storyboard handle 37 returns to Desert, physical frame 34.
        room_goto(rm_desert);
        exit;
    }
} else if (!_player.input_locked && ninja_gaiden_toggle_cd()) {
    play_stage_track();
}
update_view(_player, _floor);
