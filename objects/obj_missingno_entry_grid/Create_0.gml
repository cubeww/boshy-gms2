// Fusion places a full 40 by 30 grid of 16-pixel tiles on Layer 5.
entry_cells = [];
for (var _column = 0; _column < 40; ++_column) {
    for (var _row = 0; _row < 30; ++_row) {
        var _tile_x = _column * 16;
        var _tile_y = _row * 16;
        // G703 converts atan2(320 - X, 240 - Y) + 90 to the departure angle.
        var _angle = darctan2(320 - _tile_x, 240 - _tile_y) + 90;
        array_push(entry_cells, {
            tile_x: _tile_x, tile_y: _tile_y, scale: 1, moving: false,
            dx: dcos(_angle) * 15, dy: -dsin(_angle) * 15
        });
    }
}

draw_grid = function(_left, _top) {
    var _count = array_length(entry_cells);
    for (var _i = 0; _i < _count; ++_i) {
        var _cell = entry_cells[_i];
        if (!_cell.moving) {
            draw_sprite(spr_missingno_entry_tile, 0, _left + x + _cell.tile_x, _top + y + _cell.tile_y);
        }
    }
    // G737 brings departing tiles in front of the tiles still covering the room.
    for (var _i = 0; _i < _count; ++_i) {
        var _cell = entry_cells[_i];
        if (_cell.moving && _cell.tile_x < 640 && _cell.tile_y < 480
            && _cell.tile_x + 16 * _cell.scale > 0 && _cell.tile_y + 16 * _cell.scale > 0) {
            draw_sprite_ext(spr_missingno_entry_tile, 0, _left + x + _cell.tile_x, _top + y + _cell.tile_y,
                _cell.scale, _cell.scale, 0, c_white, 1);
        }
    }
};
