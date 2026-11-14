++room_steps;
++formation_steps;
++formation_spacing;

// Groups 886–897 pick a formation and reuse its counters until that pass ends.
if (formation_steps == 10) {
    formation_kind = irandom_range(1, 4);
}
if (formation_steps >= 50) {
    switch (formation_kind) {
        case 1:
            if (formation_steps == 50) {
                formation_y = irandom_range(80, 479);
            }
            if (formation_steps < 150 && formation_spacing >= 10) {
                formation_spacing = 0;
                spawn_formation_enemy(formation_kind);
            }
            if (formation_steps >= 250) {
                formation_steps = 0;
            }
            break;
        case 2:
        case 3:
            formation_y = irandom_range(100, 379);
            var _divers = formation_kind == 2;
            var _spawn_end = _divers ? 200 : 150;
            var _spawn_spacing = _divers ? 20 : 10;
            var _formation_end = _divers ? 280 : 250;
            if (formation_steps < _spawn_end && formation_spacing >= _spawn_spacing) {
                formation_spacing = 0;
                spawn_formation_enemy(formation_kind);
            }
            if (formation_steps >= _formation_end) {
                formation_steps = 0;
            }
            break;
        case 4:
            if (formation_steps == 50) {
                formation_spacing = 0;
                spawn_formation_enemy(formation_kind);
            }
            if (formation_steps >= 80) {
                formation_steps = 0;
            }
            break;
    }
}

gradius_enemies_step();

// Group 967's strict timer gate starts the independent ten-second countdown.
if (room_steps > 2250 && (room_steps - 2250) mod 500 == 0) {
    rush_steps = 120;
}
if (rush_steps > 0) {
    --rush_steps;
    ++rush_spacing;
    if (rush_steps > 0 && rush_spacing >= 15) {
        rush_spacing = 0;
        spawn_formation_enemy(irandom_range(1, 4));
    }
}

gradius_enemy_shots_step();

// Group 979 counts only live frames. Group 980 reads the marker before groups 981–982 update it.
var _player = instance_find(obj_gradius_player, 0);
if (_player == noone || _player.dead) {
    exit;
}
++elapsed_steps;
var _exit_marker = instance_find(obj_gradius_exit_marker, 0);
if (_exit_marker == noone) {
    exit;
}
if (_exit_marker.visible && _player.x >= 560) {
    gradius_return_to_castlevania();
    exit;
}
_exit_marker.visible = elapsed_steps >= exit_steps;
