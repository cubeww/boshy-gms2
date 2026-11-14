game_controller = instance_find(obj_game, 0);
trophy_title = "";
trophy_steps = -1;
portal_steps = -1;
portal_frame = 0;
portal_sound = -1;

milon_show_trophy = function(_title) {
    trophy_title = _title;
    trophy_steps = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
};

var _entries = [];
with (obj_secret_chest) {
    array_push(_entries, pickup);
}
prehistorik_pickups_setup(_entries, spr_milon_pickup_reveals, milon_show_trophy);
