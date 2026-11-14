combat_steps = -1;
terrain_pieces = [
    { sprite: spr_hello_kitty_starting_floor, y: 441, combat_y: 441, phase: 0, tilt: 1 }
];
for (var _y = 96; _y <= 336; _y += 80) {
    array_push(terrain_pieces, {
        sprite: spr_prehistorik_backdrop_131, y: _y, combat_y: _y + 5, phase: 0, tilt: 2
    });
}
background_y = 0;
background_next_y = 2047;
background_speed = 20;
