game_controller = instance_find(obj_game, 0);
stage_steps = 0;
page_left = 0;
view_width = 640;
view_center_x = 320;
view_center_y = 240;
portal_steps = -1;
portal_sound = -1;
portal_touching = false;

var _chests = [inst_prize_room_chest_solgryn.pickup, inst_prize_room_chest_dark_boshy.pickup,
    inst_prize_room_chest_sonic.pickup];
prehistorik_pickups_setup(_chests, spr_prize_room_chest_reveals, noone);
game_controller.start_stage_music(snd_prize_room_music);
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
