function sanicz_arena_set_view(_x, _y) {
    camera_set_view_pos(view_camera[0], _x, _y);
    // The source scenery layer has zero horizontal and vertical scroll coefficients.
    layer_x("Starfield", _x);
    layer_y("Starfield", _y);
    layer_x("Daytime Scenery", _x);
    layer_y("Daytime Scenery", _y);
}

function sanicz_arena_burn() {
    // Group 1152 removes the pasted floor and grass overlay when the central platform rises.
    var _backdrop = inst_sanicz_floor.starting_backdrop;
    if (instance_exists(_backdrop)) {
        instance_destroy(_backdrop);
    }
    if (instance_exists(inst_sanicz_grass)) {
        instance_destroy(inst_sanicz_grass);
    }
    if (inst_sanicz_floor.sprite_index != spr_sanicz_floor_collapse) {
        inst_sanicz_floor.sprite_index = spr_sanicz_floor_collapse;
        inst_sanicz_floor.image_index = 0;
    }
}
