var _player = instance_find(obj_player, 0);
if (is_cameo) {
    ninja_ryu_cameo_step(_player);
} else {
    var _stage = instance_find(obj_ninja_gaiden, 0);
    if (_stage != noone) {
        ninja_ryu_encounter_step(_player, _stage);
    }
}
