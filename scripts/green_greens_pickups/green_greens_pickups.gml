function green_greens_pickups_setup() {
    // Frame 4 objects 402, 434, and 458 use the shared secret chest sequence.
    var _entries = [
        inst_green_greens_chest_rupees.pickup,
        inst_green_greens_chest_trololol_cd.pickup,
        inst_green_greens_chest_kirby.pickup
    ];
    prehistorik_pickups_setup(_entries, spr_green_greens_pickup_reveals, green_greens_show_trophy);
}

function green_greens_pickups_step(_player) {
    prehistorik_pickups_step(_player);
    if (_player == noone || _player.dead) {
        return;
    }

    // Groups 497 and 523 award the two world trophies in separate zones near the exit.
    if (point_in_rectangle(_player.x, _player.y, 6786, 1373, 6913, 1443)
        && game_has_item("Trololol CD") && game_has_item("Rupees") && game_trophy_unlock("World2clear")) {
        green_greens_show_trophy("World 2 CLEAR!");
    }
    if (point_in_rectangle(_player.x, _player.y, 6721, 1341, 6794, 1437)
        && global.run.world_deaths <= 10 && game_trophy_unlock("World2PROMODE")) {
        green_greens_show_trophy("World 2 PRO MODE!");
    }
}
