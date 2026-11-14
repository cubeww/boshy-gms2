var _count = array_length(entry_cells);
if (_count == 0) {
    instance_destroy();
    exit;
}

// G735–736 draw eight times from the live tile list, including tiles already moving.
repeat (8) {
    var _tile = entry_cells[irandom(_count - 1)];
    _tile.moving = true;
}
for (var _i = _count - 1; _i >= 0; --_i) {
    var _cell = entry_cells[_i];
    if (!_cell.moving) {
        continue;
    }
    _cell.tile_x = floor(_cell.tile_x + _cell.dx);
    _cell.tile_y = floor(_cell.tile_y + _cell.dy);
    _cell.scale += 0.2;

    // Match Fusion's automatic destruction at its horizontal and vertical kill borders.
    var _size = 16 * _cell.scale;
    if (_cell.tile_x + _size < -480 || _cell.tile_x > 1120
        || _cell.tile_y + _size < -300 || _cell.tile_y > 780) {
        array_delete(entry_cells, _i, 1);
    }
}
