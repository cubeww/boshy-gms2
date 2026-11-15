draw_self();
if (sprite_index != spr_secret_jtv_arena_screen) {
    exit;
}

var _fight = inst_secret_jtv_encounter;
// G844–845 drop the flames below the screen while the overlay stays.
if (_fight.victory_steps >= 351) {
    exit;
}
var _steps = _fight.scene_steps;
var _drop = max(0, _fight.victory_steps - 101);
var _flames = _fight.spectators;
gpu_set_blendmode(bm_add);
for (var _i = 0; _i < array_length(_flames); ++_i) {
    var _flame = _flames[_i];
    var _flame_y = floor(_flame.y - 50 + dsin(_steps * 20 / (6 - _flame.x)) * 30 + _drop);
    var _frame = floor(_steps * _flame.flame_frames_per_step) mod sprite_get_number(_flame.sprite_index);
    draw_sprite(_flame.sprite_index, _frame, _flame.x, _flame_y);
}
gpu_set_blendmode(bm_normal);
