open_x = 398;
open_y = 248;
destination_room = rm_teleporter;
destination_x = 320;
destination_y = 240;
image_alpha = 0;

update_exit = function(_player) {
    // G1245 places the additive portal by its top-left hotspot and fades it in.
    x = open_x;
    y = open_y;
    image_alpha = min(1, image_alpha + 5 / 255);
    if (_player != noone && _player.boshy_mask_meeting(id)) {
        // G1299 switches straight to the hub without the standard pad animation.
        game_travel_by_teleporter(destination_room, destination_x, destination_y, false);
    }
};
