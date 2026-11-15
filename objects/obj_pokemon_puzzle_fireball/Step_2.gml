// G926 and G929–930 move from fractional coordinates and cull at the frame edge.
var _stage = inst_pokemon_puzzle_controller;
if (bbox_right < _stage.page_left - 50 || bbox_left >= _stage.page_left + 690
    || bbox_bottom < _stage.page_top - 50 || bbox_top >= _stage.page_top + 530) {
    instance_destroy();
    exit;
}

x = floor(travel_x);
y = floor(travel_y);
travel_x += lengthdir_x(travel_speed, image_angle);
travel_y += lengthdir_y(travel_speed, image_angle);
