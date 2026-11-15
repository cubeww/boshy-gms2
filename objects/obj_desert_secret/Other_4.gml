game_controller.start_stage_music(snd_desert_secret_music);
// G60 gives every room start its own pitched entrance call.
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);

var _player = instance_find(obj_player, 0);
if (_player != noone) {
    var _floor = instance_find(obj_desert_secret_rising_floor, 0);
    if (_floor != noone) {
        _floor.y = _player.y + 32;
    }
    update_view(_player, _floor);
}
