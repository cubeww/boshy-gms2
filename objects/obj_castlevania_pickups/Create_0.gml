game_controller = instance_find(obj_game, 0);
trophy_title = "";
trophy_steps = -1;

castlevania_show_trophy = function(_title) {
    trophy_title = _title;
    trophy_steps = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
};

prehistorik_pickups_setup([
    inst_castlevania_chest_keyboard_cat.pickup,
    inst_castlevania_chest_scouter.pickup,
    inst_castlevania_chest_simon_belmont.pickup
], spr_castlevania_pickup_reveals, castlevania_show_trophy);
