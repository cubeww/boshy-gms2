game_controller = instance_find(obj_game, 0);
var _difficulty = game_campaign_difficulty();
if (_difficulty < 0) {
    _difficulty = 1;
}
easy_mode = _difficulty == 0;
var _health_by_difficulty = [50, 100, 100, 200];
max_health = _health_by_difficulty[_difficulty];
hit_points = max_health;
scene_steps = 0;
fight_age = 0;
attempt_start_second = -1;
spawn_counter = 0;
lava_amplitude = 10;
vertical_speed = 0;
chase_speed = 0;
chase_target_direction = 0;
roll_direction = 0;
shake_strength = 0;
blur_strength = 0;
hit_flash_age = -1;
facing = 1;
defeated = false;
victory_age = 0;
exit_age = -1;
exit_pipe = noone;
arena_floor = noone;
intro_koopa = noone;
koopa_squash_age = -1;
mario_trails = [];
trophy_titles = [];
trophy_index = 0;
trophy_steps = 0;
show_boss_health = game_has_item("Scouter");
show_boss_timer = game_has_item("Timer");
image_speed = 0;
sprite_index = spr_mario_idle;

mario_projectiles_setup();
mario_victory_setup();
if (game_selected_cd() == 0) {
    game_controller.start_stage_music(snd_mario_music, true, false);
}

mario_set_pose = function(_right, _left) {
    var _sprite = facing < 0 ? _left : _right;
    if (sprite_index != _sprite) {
        sprite_index = _sprite;
        image_index = 0;
    }
};

mario_set_scale = function(_scale) {
    image_xscale = _scale;
    image_yscale = _scale;
};

take_player_shot = function(_bullet) {
    if (defeated) {
        return mario_victory_take_shot(_bullet);
    }
    if (fight_age <= 400) {
        return false;
    }
    var _boss = id;
    var _hit = false;
    with (_bullet) {
        _hit = place_meeting(x, y, _boss);
    }
    if (!_hit) {
        return false;
    }

    take_hit(1);
    return true;
};

take_hit = function(_damage) {
    hit_points = max(0, hit_points - _damage);
    audio_play_sound(snd_mario_bump, 1, false);
    if (hit_flash_age < 0) {
        hit_flash_age = 0;
    }
    if (hit_points > 0) {
        return;
    }

    // Groups 756–759 restore the floor and change Mario into the death animation.
    defeated = true;
    image_angle = 0;
    sprite_index = spr_mario_transition;
    image_index = 0;
    vertical_speed = -10;
    if (instance_exists(arena_floor)) {
        arena_floor.set_floor_open(false);
    }
    if (game_controller.stage_music_instance != -1) {
        audio_stop_sound(game_controller.stage_music_instance);
        game_controller.stage_music_instance = -1;
    }
    audio_play_sound(snd_mario_die, 1, false);

    var _seconds = game_controller.frame_seconds - attempt_start_second;
    var _progress = game_current_progress();
    if (_seconds < _progress.mario_best_time) {
        _progress.mario_best_time = _seconds;
        global.profile.dirty = true;
        audio_play_sound(snd_hello_kitty_new_record, 1, false);
    }
    if (_seconds < 105 && game_trophy_unlock("MarioSpeed")) {
        array_push(trophy_titles, "Mario Speedrun!");
    }
    if (game_trophy_unlock("Mario")) {
        array_push(trophy_titles, "It's-a me!");
    }
    game_profile_save();
};
