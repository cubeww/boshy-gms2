game_controller.start_stage_music(snd_final_path_music);

entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
var _player = instance_find(obj_player, 0);
if (_player != noone) {
    update_view(_player, true);
}
