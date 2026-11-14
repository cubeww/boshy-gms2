var _waves = instance_find(obj_gradius_waves, 0);
var _progress_x = _waves == noone ? x : floor(640 * _waves.elapsed_steps / _waves.exit_steps);
draw_sprite(sprite_index, 0, _progress_x, y);
