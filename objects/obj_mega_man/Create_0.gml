game_controller = instance_find(obj_game, 0);
var _difficulty = game_campaign_difficulty();
if (_difficulty < 0) {
    _difficulty = 1;
}
var _health_by_difficulty = [60, 90, 90, 170];
max_health = _health_by_difficulty[_difficulty];
hit_points = max_health;
easy_mode = _difficulty == 0;
show_boss_health = game_has_item("Scouter");
show_boss_timer = game_has_item("Timer");

fight_age = -80;
scene_steps = 0;
attempt_start_steps = 0;
attempt_steps = 0;
intro_cover = 0;
facing = 1;
final_form = false;
spiral_angle = 0;
spiral_sound_steps = 0;
hit_flash_age = 0;
shake_strength = 0;
shake_x = 0;
shake_y = 0;
blur_strength = 0;
blur_angle = 0;
image_speed = 0;
pose_animation = -1;
pose_clock = 0;

mega_man_set_pose = function(_animation, _direction) {
    if (pose_animation == _animation && facing == _direction) {
        return;
    }
    pose_animation = _animation;
    facing = _direction;
    image_index = 0;
    pose_clock = 0;
    switch (_animation) {
        case 3: sprite_index = spr_mega_man_teleport; break;
        case 13: sprite_index = facing < 0 ? spr_mega_man_bomb_glide_left : spr_mega_man_bomb_glide; break;
        case 14: sprite_index = spr_mega_man_run_left; break;
        case 15: sprite_index = spr_mega_man_giant; break;
        case 16: sprite_index = spr_mega_man_defeated; break;
        default: sprite_index = facing < 0 ? spr_mega_man_idle_left : spr_mega_man_idle; break;
    }
};

mega_man_change_mask = function() {
    // The regular-sized sprite waits behind the arena's foreground ornament.
    x = 623;
    y = 152;
    image_angle = 0;
    mega_man_set_pose(15, -1);
};

mega_man_reveal_final_form = function() {
    x = 800;
    y = 309;
    image_xscale = 15;
    image_yscale = 15;
    final_form = true;
};

take_player_shot = function(_bullet) {
    if (victory_age >= 0 || _bullet.reflected) {
        return false;
    }
    if (y > 200 || _bullet.object_index == obj_gastly_companion_shot) {
        var _boss = id;
        var _hit = false;
        with (_bullet) {
            _hit = place_meeting(x, y, _boss);
        }
        if (_hit) {
            // G691 and G810 damage the main health counter, independent of the secondary meter.
            audio_play_sound(snd_mario_bump, 1, false);
            if (hit_flash_age == 0) {
                hit_flash_age = 1;
            }
            hit_points = max(0, hit_points - 1);
            return true;
        }
    }
    return mega_man_attack_shot(_bullet);
};

mega_man_set_pose(0, 1);
mega_man_attacks_setup();
mega_man_victory_setup();
game_controller.start_stage_music(snd_mega_man_music, false, true);
entrance_voice = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
