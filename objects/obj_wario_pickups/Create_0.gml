game_controller = instance_find(obj_game, 0);
trophy_title = "";
trophy_steps = -1;

wario_show_trophy = function(_title) {
    trophy_title = _title;
    trophy_steps = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
};

prehistorik_pickups_setup([
    inst_wario_chest_barrel_roll.pickup,
    inst_wario_chest_cake.pickup,
    inst_wario_chest_sagat.pickup
], spr_wario_pickup_reveals, wario_show_trophy);
