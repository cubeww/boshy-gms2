var _collected = game_has_item(item_key);
var _alpha = _collected && fade_collected ? 105 / 255 : 1;
draw_sprite_ext(sprite_index, _collected ? 1 : 0, x, y, 1, 1, 0, c_white, _alpha);
