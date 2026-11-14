var _boss = instance_find(obj_hello_kitty, 0);
if (_boss == noone || !_boss.combat_active) {
    exit;
}

if (!_boss.exit_ready) {
    // Fusion advances each platform's phase after calculating its vertical offset.
    for (var _i = 0; _i < array_length(terrain_pieces); ++_i) {
        var _piece = terrain_pieces[_i];
        _piece.y = floor(_piece.combat_y + dsin(_piece.phase * 10) * 4);
        _piece.phase += 1 + irandom(1);
    }
}
++combat_steps;
background_y -= background_speed;
background_next_y -= background_speed;
if (background_y < -2048) {
    background_y = 2024;
}
if (background_next_y < -2048) {
    background_next_y = 2024;
}
if (_boss.defeated) {
    background_speed *= 0.8;
}
