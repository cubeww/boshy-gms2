game_controller = instance_find(obj_game, 0);
effect_depth = layer_get_depth("Player") - 1;
boss = inst_secret_jtv_scope_boss;
barrier = inst_secret_jtv_arena_barrier;
left_gate = inst_secret_jtv_arena_gate_left;
giant_bow = inst_secret_jtv_arena_bow;
fire_overlay = inst_secret_jtv_arena_screen;
boss.visible = false;
giant_bow.visible = false;
arena_started = false;
arena_cleared = false;
fight_age = 0;
shot_timer = 0;
victory_steps = -1;
scene_steps = 0;
hit_flash_steps = 0;
blur_strength = 0;
max_hp = 100;
hp = max_hp;
attack_y_target = 1850;
spectators = [
    inst_secret_jtv_arena_spectator_160, inst_secret_jtv_arena_spectator_163,
    inst_secret_jtv_arena_spectator_167, inst_secret_jtv_arena_spectator_172,
    inst_secret_jtv_arena_spectator_173, inst_secret_jtv_arena_spectator_174,
    inst_secret_jtv_arena_spectator_175
];
// G933 assigns each flame its own animation speed.
for (var _i = 0; _i < array_length(spectators); ++_i) {
    var _flame = spectators[_i];
    _flame.flame_frames_per_step = irandom_range(25, 64) * 0.01;
}
secret_jtv_dialogue_setup();

arena_start = function() {
    arena_started = true;
    var _difficulty = game_campaign_difficulty();
    max_hp = _difficulty == 0 ? 50 : (_difficulty == 3 ? 200 : 100);
    hp = max_hp;
    boss.x = 1959;
    boss.y = 1839;
    boss.sprite_index = spr_secret_jtv_scope_boss_right;
    barrier.x = 1889;
    barrier.y = 1486;
    barrier.sprite_index = spr_secret_jtv_arena_barrier;
    instance_destroy(inst_secret_jtv_arena_intro_prop);
    game_controller.start_stage_music(snd_secret_jtv_encounter_music, true, false);
};

arena_impact = function(_shake, _blur) {
    inst_secret_jtv_controller.shake_view(_shake);
    blur_strength = max(blur_strength, _blur);
};

take_player_shot = function(_shot) {
    if (fight_age < 130 || victory_steps >= 0 || !instance_exists(boss)) {
        return false;
    }
    var _target = boss;
    var _hit = false;
    with (_shot) {
        _hit = place_meeting(x, y, _target);
    }
    if (!_hit) {
        return false;
    }
    --hp;
    hit_flash_steps = hit_flash_steps == 0 ? 10 : hit_flash_steps;
    audio_play_sound(snd_mario_bump, 1, false);
    return true;
};

arena_launch_scopes = function(_player, _fast_pattern) {
    for (var _eye = 0; _eye < 2; ++_eye) {
        var _x = boss.x + (_eye == 0 ? 13 : -28);
        var _y = boss.y + 12;
        var _angle = point_direction(_x, _y, _player.x, _player.y);
        var _speed = _fast_pattern ? 6 + _eye : 10;
        instance_create_depth(_x, _y, effect_depth, obj_secret_jtv_scope_shot, {
            image_angle: _angle, shot_speed: _speed
        });
    }
    audio_play_sound(snd_secret_jtv_scope_shoot, 1, false);
    arena_impact(15, 2);
};

arena_charge_scopes = function() {
    instance_create_depth(boss.x + 13, boss.y + 12, effect_depth, obj_secret_jtv_scope_charge, { eye_offset: 13 });
    instance_create_depth(boss.x - 28, boss.y + 12, effect_depth, obj_secret_jtv_scope_charge, { eye_offset: -28 });
    audio_play_sound(snd_secret_jtv_scope_charge, 1, false);
};

arena_begin_victory = function() {
    victory_steps = 0;
    if (game_controller.stage_music_instance != -1) {
        audio_stop_sound(game_controller.stage_music_instance);
        game_controller.stage_music_instance = -1;
    }
};
