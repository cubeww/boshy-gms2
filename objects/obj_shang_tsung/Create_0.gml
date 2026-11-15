game_controller = instance_find(obj_game, 0);
var _difficulty = game_campaign_difficulty();
easy_mode = _difficulty == 0;
var _health = [75, 150, 150, 300];
max_health = _health[_difficulty < 0 ? 1 : _difficulty];
hit_points = max_health;
show_boss_health = game_has_item("Scouter");
show_boss_timer = game_has_item("Timer");

fight_age = -80;
scene_steps = 0;
timer_base_seconds = global.run.boss_entry_seconds;
hit_flash_age = 0;
shake_strength = 0;
shake_x = 0;
shake_y = 0;
blur_strength = 0;
blur_angle = 0;
dialogue_lines = [];
death_handled = false;
defeat_announcement = -1;

add_dialogue = function(_lines) {
    var _letters = 0;
    for (var _i = 0; _i < array_length(_lines); ++_i) {
        _letters += string_length(_lines[_i]);
    }
    array_push(dialogue_lines, {
        lines: _lines, length: _letters + array_length(_lines) - 1,
        shown: 0, hold_steps: 0, x: x - 47, y: y - 100, age: 0, bob: 0
    });
    audio_play_sound(snd_shang_tsung_dialogue_open, 2, false);
};

take_player_shot = function(_shot) {
    if (fight_age < 490 || _shot.reflected) {
        return false;
    }
    var _boss = id;
    var _hit = false;
    with (_shot) {
        _hit = place_meeting(x, y, _boss);
    }
    if (!_hit) {
        return false;
    }
    if (hit_points <= 0) {
        return shang_tsung_victory_take_shot(_shot);
    }

    // G690 and G822 apply one point of damage and share the same flash sequence.
    --hit_points;
    audio_play_sound(snd_mario_bump, 1, false);
    if (hit_flash_age == 0) {
        hit_flash_age = 1;
    }
    return true;
};

shang_tsung_attacks_setup();
shang_tsung_victory_setup();
intro_music = -1;
if (game_selected_cd() == 0) {
    // G673 plays the introduction outside channel 2 when no CD is queued at entry.
    intro_music = audio_play_sound(snd_shang_tsung_intro_music, 1, false, global.settings.music_volume / 100);
}
entrance_voice = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
