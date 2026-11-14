game_controller = instance_find(obj_game, 0);
page_left = 0;
active_portal = noone;
label_portal = noone;
warp_age = -1;
warp_sound = -1;
sonic_notice_age = 0;

begin_warp = function(_portal, _player) {
    active_portal = _portal;
    warp_age = 0;
    _portal.image_index = 1;
    _player.input_locked = true;
    _player.hsp = 0;
    warp_sound = audio_play_sound(snd_tutorial_teleport, 1, false);
};

game_controller.start_stage_music(snd_teleporter_music);
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
