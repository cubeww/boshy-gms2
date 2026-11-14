// Fusion G1114–1116 advances both offsets every 50 ms and wraps on a tile boundary.
var _offset = (elapsed_steps * 20 div 50) mod 32;
draw_sprite(sprite_index, 0, x + _offset, y + _offset);
