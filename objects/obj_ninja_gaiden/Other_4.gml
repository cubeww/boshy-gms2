if (!struct_exists(global.run, "ninja_gaiden_cd")) {
    global.run.ninja_gaiden_cd = game_current_progress().ninja_gaiden_cd;
}
play_stage_track();

// G61 plays the entrance call when the world opens.
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
var _player = instance_find(obj_player, 0);
if (_player != noone) {
    update_view(_player, -1);
}
