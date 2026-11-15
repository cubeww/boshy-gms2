var _difficulty = game_campaign_difficulty();
max_health = 100;
switch (_difficulty) {
    case 0: max_health = 50; break;
    case 3: max_health = 200; break;
}
hit_points = max_health;
giant_bow = _difficulty == 0;

age_steps = 0;
opening_steps = 0;
attack_steps = 0;
attempt_start_second = -1;
opening_rise_timer = { interval_us: 50000, elapsed_us: 0 };
opening_clone_timer = { interval_us: 1000000, elapsed_us: 0 };
falling_clone_timer = { interval_us: 800000, elapsed_us: 0 };
spiral_heart_timer = { interval_us: 80000, elapsed_us: 0 };
defeat_explosion_timer = { interval_us: 100000, elapsed_us: 0 };
shake_steps = 0;
hit_flash_age = -1;
arena_revealed = false;
combat_active = false;
defeated = false;
exit_ready = false;
death_rumble = -1;
taunt_voice = -1;

image_speed = 0;
image_index = 1;

timer_tick = function(_timer) {
    _timer.elapsed_us += delta_time;
    if (_timer.elapsed_us < _timer.interval_us) {
        return false;
    }
    _timer.elapsed_us -= _timer.interval_us;
    return true;
};

spawn_attack = function(_kind, _x, _y, _direction = 0, _speed = 0, _scale = 1) {
    return instance_create_depth(_x, _y, depth - 1, obj_hello_kitty_attack, {
        boss: id,
        attack_kind: _kind,
        heading: _direction,
        travel_speed: _speed,
        draw_scale: _scale
    });
};

take_hit = function(_damage, _hit_sound = snd_hello_kitty_hit) {
    hit_points = max(0, hit_points - _damage);
    if (hit_flash_age < 0) {
        hit_flash_age = 0;
    }
    audio_play_sound(_hit_sound, 1, false);
    if (hit_points == 0) {
        defeated = true;
        stage_controller.boss_defeated(stage_controller.game_controller.frame_seconds - attempt_start_second);
    }
};
