game_controller = instance_find(obj_game, 0);
music_tracks = [snd_wow_legends, snd_wow_mulgore, snd_wow_stormwind];
music_cue = -1;
trigger_finger_age = -1;
page_left = 0;
page_top = 0;

stop_stage_music = function() {
    game_controller.remember_stage_music();
    game_controller.stop_stage_music();
};

resume_stage_music = function() {
    if (music_cue >= 0) {
        game_controller.start_stage_music(music_tracks[music_cue]);
    }
};

update_view = function(_player) {
    // G637 and G643 crop the 640 by 480 screen around its native page center.
    page_left = (_player.x div 640) * 640;
    page_top = (_player.y div 480) * 480;
    camera_set_view_size(view_camera[0], 640, 481);
    camera_set_view_pos(view_camera[0], page_left - 1, page_top - 2);
};

update_music = function(_player, _cue) {
    // G1055 and G1062–1063 retire their triggers after the player enters.
    // G1098 uses the stored channel position on the login screen.
    with (obj_wow_music_trigger) {
        if (cue == _cue && _player.boshy_mask_meeting(id)) {
            other.music_cue = cue;
            var _saved_position = global.run.music_position;
            if (cue == 1) {
                global.run.music_position = 0;
            }
            other.resume_stage_music();
            global.run.music_position = _saved_position;
            if (cue == 2) {
                with (obj_wow_music_trigger) {
                    if (cue == 2) {
                        instance_destroy();
                    }
                }
            } else {
                instance_destroy();
            }
            break;
        }
    }
};

// G61 plays the entry voice, and the music region selects the track on spawn.
play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
var _player = instance_find(obj_player, 0);
if (_player != noone) {
    update_view(_player);
}
