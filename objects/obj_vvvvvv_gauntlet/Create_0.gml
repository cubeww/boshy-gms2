// The Text Blitter is drawn after the player and rails on the original Game layer.
depth -= 3;
gauntlet_duration = game_campaign_difficulty() == 0 ? 1500 : 3000;
gauntlet_remaining = gauntlet_duration;
gauntlet_volley_steps = 0;
gauntlet_started = false;
gauntlet_complete = false;

// Fusion groups 961–986 specify each volley relative to Active 60.
// Each row stores the recovery time, horizontal direction, and launch offsets.
gauntlet_volleys = [
    [0, -1, [[0, -80], [0, 80]]],
    [0, -1, [[0, -20], [0, 20]]],
    [0, 1, [[-630, -20], [-630, 20]]],
    [0, 1, [[-630, -80], [-630, 80]]],
    [0, 1, [[-630, 50]]],
    [0, -1, [[0, 50]]],
    [-80, -1, [[0, -32], [80, 0], [160, 32], [240, 64]]],
    [-80, 1, [[-630, 32], [-710, 0], [-790, -32], [-870, -64]]],
    [-20, 1, [[-662, 70], [-646, 40], [-630, -40], [-614, -70]]],
    [-20, -1, [[0, 70], [-16, 40], [-32, -40], [-46, -70]]]
];
