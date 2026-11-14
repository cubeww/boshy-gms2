if (trophy_steps >= 0 && ++trophy_steps >= 226) {
    trophy_steps = -1;
}
if (arrival_steps >= 0) {
    arrival_frame = floor(++arrival_steps * 0.6);
    if (arrival_frame >= sprite_get_number(spr_tutorial_portal_transition)) {
        arrival_steps = -1;
        game_controller.teleport_mosaic_columns = 0;
        game_controller.teleport_mosaic_rows = 0;
    } else {
        // The reverse wipe sharpens both axes as its animation advances.
        var _grid_size = arrival_frame * 31;
        game_controller.teleport_mosaic_columns = _grid_size;
        game_controller.teleport_mosaic_rows = _grid_size;
    }
}
prehistorik_opening_step(live_player());
prehistorik_cave_step(live_player());
prehistorik_upper_step(live_player());
prehistorik_pickups_step(live_player());
prehistorik_exit_step(live_player());

var _player = live_player();
if (_player == noone) {
    game_controller.fade_stage_music();
}
update_view(_player);
