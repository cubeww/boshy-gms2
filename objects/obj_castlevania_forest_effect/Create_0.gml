if (!variable_instance_exists(id, "forest_effect")) {
    forest_effect = CastlevaniaForestEffect.GhoulSparks;
}
if (!variable_instance_exists(id, "effect_left")) {
    effect_left = false;
}
if (!variable_instance_exists(id, "horizontal_speed")) {
    horizontal_speed = 0;
    vertical_speed = 0;
}
castlevania_forest_effect_setup(forest_effect);
