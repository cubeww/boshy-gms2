event_inherited();

activate = function() {
    teleporter_rush_reset();
    game_profile_save();
    if (image_index == 0) {
        image_index = 1;
    }
};
