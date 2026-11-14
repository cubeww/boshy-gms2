enum TitlePage {
    Prompt,
    Main,
    Slots,
    Difficulty,
    DeleteSlot
}

game_controller = instance_find(obj_game, 0);
var _returning = game_take_title_return();
menu_page = _returning ? TitlePage.Main : TitlePage.Prompt;
menu_index = 0;
slot_index = 0;
delete_confirmed = false;
notice_steps = 0;

attract_steps = _returning ? 610 : 0;
prompt_steps = 0;
actor_x = -113;
actor_y = 2345;
actor_vsp = -14;
camera_x = 320;
camera_y = 2160;
camera_width = 640;
logo_scale = _returning ? 1.5 : 1;

main_choices = [
    { sprite: spr_title_game, x: 310, y: 244, size: 1 },
    { sprite: spr_title_options, x: 313, y: 295, size: 1 },
    { sprite: spr_title_online, x: 318, y: 350, size: 1 }
];
slot_choices = [
    { sprite: spr_title_slot_1, x: 246, y: 351, size: 1 },
    { sprite: spr_title_slot_2, x: 317, y: 351, size: 1 },
    { sprite: spr_title_slot_3, x: 396, y: 351, size: 1 }
];
difficulty_choices = [
    { sprite: spr_title_difficulty_ez, x: 169, y: 185, size: 1 },
    { sprite: spr_title_difficulty_average, x: 219, y: 218, size: 1 },
    { sprite: spr_title_difficulty_hardon, x: 193, y: 263, size: 1 },
    { sprite: spr_title_difficulty_rage, x: 256, y: 309, size: 1 }
];
spikes_up = [[436, 1680], [0, 1174], [32, 1174], [64, 1174]];
spikes_down = [[404, 1806], [500, 1838], [16, 1333], [112, 1300]];

storm_wait = 0;
storm_transparency = 0;
thunder_sounds = [snd_title_thunder_1, snd_title_thunder_2, snd_title_thunder_3, snd_title_thunder_4, snd_title_thunder_5];
thunder_voice = -1;
jump_voice = -1;
camping_voice = -1;
boshy_voice = -1;
var _music_offset = _returning ? 14 : 0;
title_music = audio_play_sound(snd_title_music, 0, false, global.settings.music_volume / 100, _music_offset);

settle_title = function(_skip) {
    attract_steps = 610;
    if (_skip) {
        audio_sound_set_track_position(title_music, 14);
        if (jump_voice != -1) {
            audio_stop_sound(jump_voice);
        }
        if (camping_voice != -1) {
            audio_stop_sound(camping_voice);
        }
        menu_page = TitlePage.Main;
    }
    boshy_voice = play_boshy_voice(snd_tutorial_entrance);
};
