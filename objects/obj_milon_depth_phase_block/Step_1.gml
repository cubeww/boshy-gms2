var _stage = instance_find(obj_milon, 0);
var _solid = solid_in_resting_phase != _stage.depth_phase_flipped;
if (_solid != (sprite_index != -1)) {
    // Groups 919–921 move disabled tiles above the player and off the collision layer.
    sprite_index = _solid ? spr_milon_depth_phase_block_solid : -1;
    depth = _solid ? layer_get_depth("Gameplay") : layer_get_depth("Foreground Gameplay");
}
