enum PlayerPose {
    Idle,
    Run,
    Rise,
    Fall,
    Shoot
}

function boshy_character() {
    static _character = {
        sprite_right: spr_boshy_right,
        sprite_left: spr_boshy_left,
        projectile_sprite: spr_boshy_bullet,
        muzzle_x: 8,
        muzzle_y: -10,
        jump_sound: snd_jump,
        air_jump_sound: snd_air_jump,
        shoot_sound: snd_shoot,
        death_lines: [
            { text: "Damnit!", sound: snd_boshy_death_damnit, sample_rate: 48000 },
            { text: "Aww!", sound: snd_boshy_death_aww, sample_rate: 48000 },
            { text: "Noo!", sound: snd_boshy_death_noo, sample_rate: 48000 },
            { text: "So fucking close!", sound: snd_boshy_death_so_close, sample_rate: 48000 },
            { text: "Fuck...", sound: snd_boshy_death_fuck, sample_rate: 48000 },
            { text: "God Damnit...", sound: snd_boshy_death_god_damnit, sample_rate: 48000 },
            { text: "Nya! The hell?!...", sound: snd_boshy_death_nya, sample_rate: 44100 }
        ],
        movement: {
            run_speed: 3,
            acceleration: 1,
            deceleration: 1,
            gravity: 0.45,
            jump_speed: 7
        },
        poses: [
            { frames: [0, 1], rate: 0.07, loop: true },
            { frames: [0, 2, 3, 2, 0, 4, 5, 4], rate: 0.2, loop: true },
            { frames: [0, 2, 6], rate: 0.2, loop: false },
            { frames: [2, 7], rate: 0.2, loop: false },
            { frames: [0, 0], rate: 0.25, loop: false }
        ]
    };
    return _character;
}
