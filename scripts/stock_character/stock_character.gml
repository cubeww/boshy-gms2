function stock_character_definition(_right, _left, _projectile, _poses, _poses_left,
    _jump, _air_jump, _shoot, _walk, _land, _movement, _walk_sound_always = false) {
    var _base = boshy_character();
    return {
        sprite_right: _right,
        sprite_left: _left,
        projectile_sprite: _projectile,
        muzzle_x: _base.muzzle_x,
        muzzle_y: _base.muzzle_y,
        jump_sound: _jump,
        air_jump_sound: _air_jump,
        shoot_sound: _shoot,
        walk_sound: _walk,
        walk_sound_always: _walk_sound_always,
        land_sound: _land,
        death_lines: _base.death_lines,
        movement: is_undefined(_movement) ? _base.movement : _movement,
        poses: _poses,
        poses_left: is_undefined(_poses_left) ? _poses : _poses_left
    };
}

function stock_character(_id) {
    // The original License/Character ID identifies the actor independently of menu order.
    static _characters = {
        c16: stock_character_definition(
            spr_stock_kid_right, spr_stock_kid_left, spr_stock_kid_shot, [
                { frames: [0, 1, 2, 3], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [4, 5, 6, 7, 8], rate: 0.35, loop: true, loop_start: 0 },
                { frames: [9, 10], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [11, 12], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [13], rate: 0.5, loop: true, loop_start: 0 }
            ], undefined,
            snd_jump, snd_air_jump, snd_shoot, noone, noone, undefined
        ),
        c20: stock_character_definition(
            spr_stock_kirby_right, spr_stock_kirby_left, spr_stock_kirby_shot, [
                { frames: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1], rate: 0.4, loop: true, loop_start: 0 },
                { frames: [2, 3, 4], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [5], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [6, 6, 6, 6, 7], rate: 0.3, loop: true, loop_start: 4 },
                { frames: [8, 9], rate: 0.25, loop: false, loop_start: 0 }
            ], undefined,
            snd_stock_kirby_jump, snd_stock_kirby_air_jump, snd_stock_kirby_shoot, noone, noone, undefined
        ),
        c24: stock_character_definition(
            spr_stock_blob_right, spr_stock_blob_left, spr_stock_blob_shot, [
                { frames: [0, 1, 2, 3, 4, 5, 4, 1, 0], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [6, 7, 8, 9, 10, 9, 8, 7, 6, 11, 12, 13, 14, 15, 12, 11], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [16], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [17, 18, 19, 20, 21, 22, 23, 24, 25, 26], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [27], rate: 0.5, loop: true, loop_start: 0 }
            ], undefined,
            snd_stock_blob_jump, snd_stock_blob_air_jump, snd_stock_blob_shoot, noone, noone, undefined
        ),
        c28: stock_character_definition(
            spr_stock_pedobear_right, spr_stock_pedobear_left, spr_stock_pedobear_shot, [
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [1, 2, 1, 3], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [5, 6], rate: 0.45, loop: false, loop_start: 0 }
            ], [
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [1, 2, 1, 3], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [5, 6], rate: 0.5, loop: false, loop_start: 0 }
            ],
            snd_stock_pedobear_jump, snd_stock_pedobear_air_jump, snd_stock_pedobear_shoot, noone, noone, undefined
        ),
        c32: stock_character_definition(
            spr_stock_mario_right, spr_stock_mario_left, spr_stock_mario_shot, [
                { frames: [0], rate: 0.5, loop: false, loop_start: 0 },
                { frames: [1, 2, 3], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [5, 5], rate: 0.25, loop: false, loop_start: 0 }
            ], undefined,
            snd_stock_mario_jump, snd_stock_mario_air_jump, snd_stock_mario_shoot, noone, noone, undefined
        ),
        c36: stock_character_definition(
            spr_stock_ash_right, spr_stock_ash_left, spr_stock_ash_shot, [
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [1, 0], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [2, 3, 2, 4], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [5, 6, 5, 7], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [8], rate: 0.5, loop: true, loop_start: 0 }
            ], undefined,
            snd_stock_ash_jump, snd_stock_ash_air_jump, snd_stock_ash_shoot, noone, noone, undefined
        ),
        c40: stock_character_definition(
            spr_stock_spike_right, spr_stock_spike_left, spr_stock_spike_shot, [
                { frames: [0, 1, 1, 2, 3, 4, 5], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [0, 6, 7, 8, 3, 9, 10, 11], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [0, 1, 1, 2, 3, 4, 5], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [12, 13, 13, 14, 15, 16, 17], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [18], rate: 0.5, loop: true, loop_start: 0 }
            ], [
                { frames: [0, 1, 1, 2, 3, 4, 5], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [0, 6, 7, 8, 3, 9, 10, 11], rate: 0.4, loop: true, loop_start: 0 },
                { frames: [0, 1, 1, 2, 3, 4, 5], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [12, 13, 13, 14, 15, 16, 17], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [18], rate: 0.5, loop: true, loop_start: 0 }
            ],
            snd_stock_spike_jump, snd_stock_spike_air_jump, snd_stock_spike_shoot, noone, noone, undefined
        ),
        c44: stock_character_definition(
            spr_stock_bob_right, spr_stock_bob_left, spr_stock_bob_shot, [
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [0, 1, 2, 3], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [4, 5], rate: 0.1, loop: true, loop_start: 0 },
                { frames: [6, 7], rate: 0.1, loop: true, loop_start: 0 },
                { frames: [8, 8], rate: 0.3, loop: false, loop_start: 0 }
            ], undefined,
            snd_stock_bob_jump, snd_stock_bob_air_jump, snd_stock_bob_shoot, noone, noone, undefined
        ),
        c48: stock_character_definition(
            spr_stock_link_right, spr_stock_link_left, spr_stock_link_shot, [
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [1, 0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [1], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [2, 2], rate: 0.1, loop: false, loop_start: 0 }
            ], undefined,
            snd_stock_link_jump, snd_stock_link_air_jump, snd_stock_link_shoot, noone, noone, undefined
        ),
        c52: stock_character_definition(
            spr_stock_black_mage_right, spr_stock_black_mage_left, spr_stock_black_mage_shot, [
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [0, 1], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [2], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [3], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [4, 4], rate: 0.5, loop: true, loop_start: 0 }
            ], [
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [0, 1], rate: 0.2, loop: true, loop_start: 0 },
                { frames: [2], rate: 0.2, loop: true, loop_start: 0 },
                { frames: [3], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [4, 4], rate: 0.5, loop: true, loop_start: 0 }
            ],
            snd_stock_black_mage_jump, snd_stock_black_mage_air_jump, snd_stock_black_mage_shoot, noone, noone, undefined
        ),
        c56: stock_character_definition(
            spr_stock_dig_dug_right, spr_stock_dig_dug_left, spr_stock_dig_dug_shot, [
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [0, 1], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [2], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [2], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [3, 3], rate: 0.5, loop: true, loop_start: 0 }
            ], undefined,
            snd_stock_dig_dug_jump, snd_stock_dig_dug_air_jump, snd_stock_dig_dug_shoot, snd_stock_dig_dug_walk, noone, undefined
        ),
        c60: stock_character_definition(
            spr_stock_ness_right, spr_stock_ness_left, spr_stock_ness_shot, [
                { frames: [0, 1], rate: 0.15, loop: true, loop_start: 0 },
                { frames: [2, 3], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [5], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [6, 7], rate: 0.5, loop: true, loop_start: 0 }
            ], [
                { frames: [0, 1], rate: 0.15, loop: true, loop_start: 0 },
                { frames: [2, 3], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [3], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [5, 6], rate: 0.5, loop: true, loop_start: 0 }
            ],
            snd_stock_ness_jump, snd_stock_ness_air_jump, snd_stock_ness_shoot, noone, noone, undefined
        ),
        c64: stock_character_definition(
            spr_stock_kappa_right, spr_stock_kappa_left, spr_stock_kappa_shot, [
                { frames: [0], rate: 0.15, loop: true, loop_start: 0 },
                { frames: [0, 1, 2, 3, 4, 5, 0, 6, 7, 8, 9, 10], rate: 0.55, loop: true, loop_start: 0 },
                { frames: [11, 12, 13, 14, 15, 16], rate: 0.7, loop: true, loop_start: 5 },
                { frames: [0, 17, 18, 17, 0, 19, 20, 19], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [0], rate: 0.15, loop: false, loop_start: 0 }
            ], undefined,
            snd_stock_kappa_jump, snd_stock_kappa_air_jump, snd_stock_kappa_shoot, noone, noone, undefined
        ),
        c68: stock_character_definition(
            spr_stock_mega_man_right, spr_stock_mega_man_left, spr_stock_mega_man_shot, [
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [1, 2, 3, 2], rate: 0.2, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [5], rate: 0.5, loop: true, loop_start: 0 }
            ], undefined,
            noone, snd_stock_mega_man_air_jump, snd_stock_mega_man_shoot, noone, snd_stock_mega_man_land, undefined
        ),
        c72: stock_character_definition(
            spr_stock_pit_right, spr_stock_pit_left, spr_stock_pit_shot, [
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [1, 2, 3], rate: 0.2, loop: true, loop_start: 0 },
                { frames: [4, 4, 4, 4, 4, 4, 5, 6], rate: 0.25, loop: true, loop_start: 6 },
                { frames: [7, 8], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [9, 9], rate: 0.5, loop: true, loop_start: 0 }
            ], [
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [1, 2, 3], rate: 0.2, loop: true, loop_start: 0 },
                { frames: [4, 4, 4, 4, 4, 4, 5, 6], rate: 0.25, loop: true, loop_start: 6 },
                { frames: [7, 8], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [4, 4], rate: 0.5, loop: true, loop_start: 0 }
            ],
            snd_stock_pit_jump, snd_stock_pit_air_jump, snd_stock_pit_shoot, noone, noone, undefined
        ),
        c76: stock_character_definition(
            spr_stock_luigi_right, spr_stock_luigi_left, spr_stock_luigi_shot, [
                { frames: [0], rate: 0.5, loop: false, loop_start: 0 },
                { frames: [0, 1], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [1], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [1], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [2, 2], rate: 0.25, loop: false, loop_start: 0 }
            ], undefined,
            snd_stock_luigi_jump, snd_stock_luigi_air_jump, snd_stock_luigi_shoot, noone, noone, undefined
        ),
        c80: stock_character_definition(
            spr_stock_solgryn_right, spr_stock_solgryn_left, spr_stock_solgryn_shot, [
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [0, 1, 2, 1, 0, 3, 4, 3], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [5, 6, 5], rate: 0.5, loop: true, loop_start: 0 }
            ], undefined,
            snd_stock_solgryn_jump, snd_stock_solgryn_jump, snd_stock_solgryn_shoot, noone, noone, undefined
        ),
        c84: stock_character_definition(
            spr_stock_dark_boshy_right, spr_stock_dark_boshy_left, spr_stock_dark_boshy_shot, [
                { frames: [0, 1], rate: 0.07, loop: true, loop_start: 0 },
                { frames: [2, 3, 4, 3, 2, 5, 6, 5], rate: 0.2, loop: true, loop_start: 0 },
                { frames: [0, 7, 8], rate: 0.2, loop: true, loop_start: 2 },
                { frames: [7, 9], rate: 0.2, loop: true, loop_start: 1 },
                { frames: [10, 11, 0], rate: 0.25, loop: true, loop_start: 2 }
            ], [
                { frames: [0, 1], rate: 0.07, loop: true, loop_start: 0 },
                { frames: [2, 3, 4, 3, 2, 5, 6, 5], rate: 0.2, loop: true, loop_start: 0 },
                { frames: [0, 7, 8], rate: 0.2, loop: true, loop_start: 2 },
                { frames: [9, 10], rate: 0.2, loop: true, loop_start: 1 },
                { frames: [11, 12, 0], rate: 0.25, loop: true, loop_start: 2 }
            ],
            snd_stock_dark_boshy_jump, snd_stock_dark_boshy_air_jump, snd_stock_dark_boshy_shoot, noone, noone, undefined
        ),
        c88: stock_character_definition(
            spr_stock_sonic_right, spr_stock_sonic_left, spr_stock_sonic_shot, [
                { frames: [0, 0, 0, 0, 0, 1, 2], rate: 0.07, loop: true, loop_start: 5 },
                { frames: [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], rate: 0.5, loop: true, loop_start: 12 },
                { frames: [19, 19, 19, 20, 21, 22, 21, 23, 21, 24, 21], rate: 0.4, loop: true, loop_start: 5 },
                { frames: [25, 26, 27, 28, 29, 26, 30, 28], rate: 1, loop: true, loop_start: 0 },
                { frames: [31], rate: 0.25, loop: true, loop_start: 0 }
            ], undefined,
            snd_stock_sonic_jump, snd_stock_sonic_air_jump, snd_stock_sonic_shoot, noone, noone, { run_speed: 6, acceleration: 0.5, deceleration: 0.5, gravity: 0.45, jump_speed: 9 }
        ),
        c92: stock_character_definition(
            spr_stock_excitebike_right, spr_stock_excitebike_left, spr_stock_excitebike_shot, [
                { frames: [0], rate: 0.07, loop: true, loop_start: 0 },
                { frames: [1, 2], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [3, 4, 5, 6, 7, 8], rate: 0.4, loop: true, loop_start: 5 },
                { frames: [8, 7, 6, 5, 4, 3, 9, 10, 11, 12], rate: 0.7, loop: true, loop_start: 9 },
                { frames: [3, 13, 3], rate: 0.25, loop: true, loop_start: 2 }
            ], undefined,
            snd_stock_excitebike_jump, snd_stock_excitebike_air_jump, snd_stock_excitebike_shoot, snd_stock_excitebike_walk, noone, undefined
        ),
        c96: stock_character_definition(
            spr_stock_meat_boy_right, spr_stock_meat_boy_left, spr_stock_meat_boy_shot, [
                { frames: [0], rate: 0.07, loop: true, loop_start: 0 },
                { frames: [0, 1], rate: 0.2, loop: true, loop_start: 0 },
                { frames: [1], rate: 0.2, loop: true, loop_start: 0 },
                { frames: [0], rate: 0.2, loop: true, loop_start: 0 },
                { frames: [0, 1], rate: 0.2, loop: true, loop_start: 0 }
            ], undefined,
            snd_stock_meat_boy_jump, snd_stock_meat_boy_air_jump, snd_stock_meat_boy_shoot, noone, snd_stock_meat_boy_land, undefined
        ),
        c100: stock_character_definition(
            spr_stock_quadrick_right, spr_stock_quadrick_left, spr_stock_quadrick_shot, [
                { frames: [0, 1, 0, 1, 0, 2, 3, 1, 4, 1], rate: 0.05, loop: true, loop_start: 0 },
                { frames: [0, 5, 6, 5, 0, 7, 8, 7], rate: 0.35, loop: true, loop_start: 0 },
                { frames: [9, 10, 11], rate: 0.3, loop: true, loop_start: 2 },
                { frames: [9, 12, 13], rate: 0.3, loop: true, loop_start: 2 },
                { frames: [14, 15, 16, 17, 16, 15, 14], rate: 0.7, loop: false, loop_start: 0 }
            ], [
                { frames: [0, 1, 0, 1, 0, 2, 3, 1, 4, 1], rate: 0.05, loop: true, loop_start: 0 },
                { frames: [0, 5, 6, 5, 0, 7, 8, 7], rate: 0.35, loop: true, loop_start: 0 },
                { frames: [9, 10, 11], rate: 0.3, loop: true, loop_start: 2 },
                { frames: [9, 12, 13], rate: 0.5, loop: true, loop_start: 2 },
                { frames: [14, 15, 16, 17, 16, 15, 14], rate: 0.7, loop: false, loop_start: 0 }
            ],
            snd_stock_quadrick_jump, snd_stock_quadrick_jump, snd_stock_quadrick_shoot, noone, noone, undefined
        ),
        c104: stock_character_definition(
            spr_stock_ope_right, spr_stock_ope_left, spr_stock_ope_shot, [
                { frames: [0, 1, 0, 2], rate: 0.1, loop: true, loop_start: 0 },
                { frames: [0, 3, 4, 5, 6, 7], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [8, 9, 10], rate: 0.25, loop: false, loop_start: 0 },
                { frames: [10, 9, 8], rate: 0.25, loop: false, loop_start: 0 },
                { frames: [0], rate: 0.3, loop: true, loop_start: 0 }
            ], undefined,
            snd_stock_ope_jump, snd_stock_ope_air_jump, snd_stock_ope_shoot, noone, noone, undefined
        ),
        c108: stock_character_definition(
            spr_stock_ice_climbers_right, spr_stock_ice_climbers_left, spr_stock_ice_climbers_shot, [
                { frames: [0], rate: 0.5, loop: false, loop_start: 0 },
                { frames: [1, 2, 1, 3], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.5, loop: false, loop_start: 0 },
                { frames: [5], rate: 0.5, loop: false, loop_start: 0 },
                { frames: [6, 7, 8], rate: 0.5, loop: true, loop_start: 0 }
            ], undefined,
            snd_stock_ice_climbers_jump, snd_stock_ice_climbers_air_jump, snd_stock_ice_climbers_shoot, noone, noone, undefined
        ),
        c112: stock_character_definition(
            spr_stock_simon_right, spr_stock_simon_left, spr_stock_simon_shot, [
                { frames: [0], rate: 0.5, loop: false, loop_start: 0 },
                { frames: [0, 1, 2, 3], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [0, 0, 4], rate: 0.15, loop: true, loop_start: 1 },
                { frames: [4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [5, 6, 7], rate: 0.35, loop: true, loop_start: 2 }
            ], [
                { frames: [0], rate: 0.5, loop: false, loop_start: 0 },
                { frames: [0, 1, 2, 1], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [0, 0, 3], rate: 0.15, loop: true, loop_start: 1 },
                { frames: [3], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [4, 5, 6], rate: 0.35, loop: true, loop_start: 2 }
            ],
            snd_stock_simon_jump, snd_stock_simon_air_jump, snd_stock_simon_shoot, noone, noone, undefined
        ),
        c116: stock_character_definition(
            spr_stock_nyan_right, spr_stock_nyan_left, spr_stock_nyan_shot, [
                { frames: [0, 1, 2, 3, 4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [5, 6, 7, 8, 9], rate: 0.35, loop: true, loop_start: 0 },
                { frames: [10], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [11], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [12, 13, 14, 15, 16, 17], rate: 0.75, loop: false, loop_start: 0 }
            ], undefined,
            snd_stock_nyan_jump, snd_stock_nyan_air_jump, snd_stock_nyan_shoot, noone, noone, undefined
        ),
        c120: stock_character_definition(
            spr_stock_golden_pedobear_right, spr_stock_golden_pedobear_left, spr_stock_golden_pedobear_shot, [
                { frames: [0], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [1, 2, 3, 2], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.5, loop: true, loop_start: 0 },
                { frames: [5, 5], rate: 0.45, loop: false, loop_start: 0 }
            ], undefined,
            snd_stock_pedobear_jump, snd_stock_pedobear_air_jump, snd_stock_pedobear_shoot, noone, noone, undefined
        ),
        c124: stock_character_definition(
            spr_stock_game_and_watch_right, spr_stock_game_and_watch_left, spr_stock_game_and_watch_shot, [
                { frames: [0, 1], rate: 0.07, loop: true, loop_start: 0 },
                { frames: [0, 2, 3, 4], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [5, 6, 7, 8, 9, 10], rate: 0.25, loop: true, loop_start: 5 },
                { frames: [10, 10, 10, 10, 11, 12], rate: 0.3, loop: true, loop_start: 5 },
                { frames: [13, 14], rate: 0.25, loop: true, loop_start: 1 }
            ], undefined,
            snd_stock_game_and_watch_jump, snd_stock_game_and_watch_air_jump, snd_stock_game_and_watch_shoot, noone, noone, undefined
        ),
        c128: stock_character_definition(
            spr_stock_logibear_right, spr_stock_logibear_left, spr_stock_logibear_shot, [
                { frames: [0, 1, 2, 3], rate: 0.15, loop: true, loop_start: 0 },
                { frames: [4, 5, 6, 7, 8, 6], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [9], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [10], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [10], rate: 0.25, loop: true, loop_start: 0 }
            ], undefined,
            snd_stock_logibear_jump, snd_stock_logibear_air_jump, snd_stock_logibear_shoot, noone, noone, undefined
        ),
        c132: stock_character_definition(
            spr_stock_yoshi_right, spr_stock_yoshi_left, spr_stock_yoshi_shot, [
                { frames: [0, 0, 1, 2, 1, 2, 0, 0, 0], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [3, 4, 5, 4], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [6, 7, 6, 8], rate: 0.25, loop: true, loop_start: 2 },
                { frames: [9, 10], rate: 0.1, loop: true, loop_start: 1 },
                { frames: [11, 12], rate: 0.25, loop: true, loop_start: 0 }
            ], undefined,
            snd_stock_yoshi_jump, snd_stock_yoshi_air_jump, snd_stock_yoshi_shoot, noone, noone, undefined
        ),
        c136: stock_character_definition(
            spr_stock_yoshi_alt_right, spr_stock_yoshi_alt_left, spr_stock_yoshi_alt_shot, [
                { frames: [0, 1, 2, 3], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [4, 5, 6, 7, 8], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [9, 10, 11], rate: 0.25, loop: true, loop_start: 2 },
                { frames: [12, 13], rate: 0.1, loop: true, loop_start: 1 },
                { frames: [14, 15, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 15, 14], rate: 1, loop: false, loop_start: 6 }
            ], undefined,
            snd_stock_yoshi_alt_jump, snd_stock_yoshi_alt_jump, snd_stock_yoshi_alt_shoot, noone, noone, undefined
        ),
        c140: stock_character_definition(
            spr_stock_quote_right, spr_stock_quote_left, spr_stock_quote_shot, [
                { frames: [0], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [0, 1, 0, 2], rate: 0.4, loop: true, loop_start: 0 },
                { frames: [3], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.25, loop: true, loop_start: 0 },
                { frames: [5, 6, 7, 8, 9], rate: 0.6, loop: true, loop_start: 0 }
            ], undefined,
            snd_stock_quote_jump, snd_stock_quote_air_jump, snd_stock_quote_shoot, snd_stock_quote_walk, noone, undefined, true
        ),
        c144: stock_character_definition(
            spr_stock_orc_right, spr_stock_orc_left, spr_stock_orc_shot, [
                { frames: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24], rate: 0.8, loop: true, loop_start: 0 },
                { frames: [25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37], rate: 0.7, loop: true, loop_start: 0 },
                { frames: [38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53], rate: 0.7, loop: true, loop_start: 15 },
                { frames: [54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66], rate: 0.7, loop: true, loop_start: 0 },
                { frames: [67, 68, 69, 70, 71], rate: 1, loop: false, loop_start: 0 }
            ], undefined,
            snd_stock_orc_jump, snd_stock_orc_air_jump, snd_stock_orc_shoot, noone, noone, undefined
        ),
        c148: stock_character_definition(
            spr_stock_sagat_right, spr_stock_sagat_left, spr_stock_sagat_shot, [
                { frames: [0, 1, 2, 3], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [4, 5, 6, 7, 8, 9], rate: 0.4, loop: true, loop_start: 0 },
                { frames: [10, 11, 12, 13], rate: 0.6, loop: true, loop_start: 3 },
                { frames: [13, 13, 13, 14, 15, 16], rate: 0.5, loop: true, loop_start: 5 },
                { frames: [17, 18, 19], rate: 0.6, loop: false, loop_start: 0 }
            ], undefined,
            snd_stock_sagat_jump, snd_stock_sagat_air_jump, snd_stock_sagat_jump, noone, noone, undefined
        ),
        c152: stock_character_definition(
            spr_stock_arthur_right, spr_stock_arthur_left, spr_stock_arthur_shot, [
                { frames: [0], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [0, 1, 0, 2], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [3], rate: 0.6, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.6, loop: true, loop_start: 0 },
                { frames: [5, 5, 6, 6], rate: 0.6, loop: true, loop_start: 3 }
            ], [
                { frames: [0], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [0, 1, 2, 3], rate: 0.3, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.6, loop: true, loop_start: 0 },
                { frames: [4], rate: 0.6, loop: true, loop_start: 0 },
                { frames: [5, 5, 6, 6], rate: 0.6, loop: true, loop_start: 3 }
            ],
            snd_stock_arthur_jump, snd_stock_arthur_air_jump, snd_stock_arthur_shoot, noone, noone, undefined
        )
    };
    var _key = "c" + string(_id);
    return struct_exists(_characters, _key) ? struct_get(_characters, _key) : undefined;
}

function stock_character_select_sound(_id) {
    switch (_id) {
        case 12: return snd_tutorial_entrance;
        case 16: return snd_death_impact;
        case 20: return snd_tutorial_achievement_obtain;
        case 24: return snd_stock_select_blob;
        case 28: return snd_stock_pedobear_jump;
        case 32: return snd_stock_select_mario;
        case 36: return snd_stock_select_ash;
        case 40: return snd_stock_spike_jump;
        case 44: return snd_stock_bob_jump;
        case 48: return snd_stock_link_jump;
        case 52: return snd_stock_black_mage_jump;
        case 56: return snd_stock_dig_dug_jump;
        case 60: return snd_stock_ness_air_jump;
        case 64: return snd_stock_kappa_jump;
        case 68: return snd_stock_mega_man_land;
        case 72: return snd_stock_pit_shoot;
        case 76: return snd_stock_luigi_shoot;
        case 80: return snd_stock_select_solgryn;
        case 84: return snd_stock_dark_boshy_jump;
        case 88: return snd_stock_select_sonic;
        case 92: return snd_stock_excitebike_jump;
        case 96: return snd_stock_meat_boy_jump;
        case 100: return snd_stock_quadrick_jump;
        case 104: return snd_stock_ope_shoot;
        case 108: return snd_stock_ice_climbers_jump;
        case 112: return snd_stock_select_simon;
        case 116: return snd_stock_nyan_air_jump;
        case 120: return snd_tutorial_entrance;
        case 124: return snd_stock_game_and_watch_jump;
        case 128: return snd_stock_logibear_jump;
        case 132: return snd_stock_select_yoshi;
        case 136: return snd_stock_yoshi_alt_shoot;
        case 140: return snd_stock_quote_walk;
        case 144: return snd_stock_select_orc;
        case 148: return snd_stock_select_sagat;
        case 152: return snd_stock_arthur_shoot;
    }
    return noone;
}
