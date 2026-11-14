image_speed = 0;
collapse_counter = 0;
// Group 1117 pastes the starting floor into the collision backdrop.
starting_backdrop = instance_create_layer(x, y, layer, obj_sanicz_arena_floor_backdrop);
starting_backdrop.sprite_index = sprite_index;
starting_backdrop.image_xscale = image_xscale;
starting_backdrop.image_yscale = image_yscale;
starting_backdrop.image_angle = image_angle;
