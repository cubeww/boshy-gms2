green_block = false;
block_sprite = spr_desert_switch_block_red;
outline_frame = 0;

refresh_block = function() {
    var _active = green_block == desert_switch_enabled();
    var _layer = layer_get_id(_active ? "Solid Platforms" : "Foreground Gameplay");
    if (layer != _layer) {
        layer = _layer;
    }
    sprite_index = _active ? block_sprite : -1;
    outline_frame = 0;
};
