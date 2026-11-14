game_controller = instance_find(obj_game, 0);
var _difficulty = game_campaign_difficulty();
var _health = [75, 150, 150, 300];
max_health = _health[_difficulty < 0 ? 1 : _difficulty];
hit_points = max_health;
show_boss_health = game_has_item("Scouter");
show_boss_timer = game_has_item("Timer");

fight_age = 0;
scene_steps = 0;
hit_flash_age = 0;
shake_strength = 0;
shake_x = 0;
shake_y = 0;
arrival_age = -1;
arrival_sound = -1;

take_player_shot = function(_shot) {
    if (!visible || hit_points <= 0 || _shot.reflected) {
        return false;
    }
    var _boss = id;
    var _hit = false;
    with (_shot) {
        _hit = place_meeting(x, y, _boss);
    }
    if (_hit) {
        --hit_points;
        bomberman_attack_sound(snd_bomberman_hit);
        if (hit_flash_age == 0) {
            hit_flash_age = 1;
        }
    }
    return _hit;
};

bomberman_pose_setup();
bomberman_attacks_setup();
bomberman_victory_setup();
