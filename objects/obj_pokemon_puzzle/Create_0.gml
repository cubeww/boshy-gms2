game_controller = instance_find(obj_game, 0);
page_left = 0;
page_top = 0;
trigger_finger_age = -1;
room_warps = [inst_pokemon_puzzle_warp_lower, inst_pokemon_puzzle_warp_forward];

prehistorik_pickups_setup([inst_pokemon_puzzle_ash_chest.pickup], spr_pokemon_puzzle_ash_reveal, noone);

update_view = function(_player) {
    // G634–651 use a page-sized source region and let the chest sequence zoom it.
    page_left = clamp((_player.x div 640) * 640, 0, room_width - 640);
    page_top = clamp((_player.y div 480) * 480, 0, room_height - 480);
    camera_set_view_size(view_camera[0], 640, 481);
    camera_set_view_pos(view_camera[0], page_left - 1, page_top - 2);
    var _pickup_age = prehistorik_pickup_slot >= 0 ? prehistorik_pickup_age : -1;
    chest_view_update(game_controller, _player, _pickup_age);
};

// G61–62 start the CeladonTrance loop.
game_controller.start_stage_music(snd_pokemon_puzzle_music);
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);

var _player = instance_find(obj_player, 0);
if (_player != noone) {
    update_view(_player);
}
