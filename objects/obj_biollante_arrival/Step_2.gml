if (arrival_frame >= sprite_get_number(spr_tutorial_portal_transition)) {
    if (!audio_is_playing(arrival_sound)) {
        instance_destroy();
    }
    exit;
}

// Fusion groups 605–606 and 610 play the teleport animation in reverse.
arrival_frame = floor(++arrival_steps * 0.6);
if (arrival_frame >= sprite_get_number(spr_tutorial_portal_transition)) {
    game_controller.teleport_mosaic_columns = 0;
    game_controller.teleport_mosaic_rows = 0;
    visible = false;
    exit;
}
var _grid_size = arrival_frame * 31;
game_controller.teleport_mosaic_columns = _grid_size;
game_controller.teleport_mosaic_rows = _grid_size;
