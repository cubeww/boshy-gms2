elapsed_steps = 0;
exit_steps = game_campaign_difficulty() == 0 ? 3000 : 6000;
room_steps = 0;
formation_kind = 0;
formation_steps = 0;
formation_spacing = 0;
formation_y = 0;
rush_steps = 0;
rush_spacing = 0;
entrance_sound = gradius_start_audio();

spawn_formation_enemy = function(_formation) {
    // The source gives each enemy a separate creation point off the right edge.
    switch (_formation) {
        case 1:
            gradius_spawn_enemy(GradiusEnemy.Wave, 626, formation_y, 4, 3);
            break;
        case 2:
            gradius_spawn_enemy(GradiusEnemy.Diver, 677, formation_y + irandom(79) - irandom(79), 0, 5);
            break;
        case 3:
            gradius_spawn_enemy(GradiusEnemy.Spinner, 680, formation_y + irandom(79) - irandom(79), 0, 3);
            break;
        case 4:
            gradius_spawn_enemy(GradiusEnemy.Gunner, 666, 480, 0, 10);
            break;
    }
};
