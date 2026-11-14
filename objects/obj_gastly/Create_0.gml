game_controller = instance_find(obj_game, 0);
already_caught = game_has_item("Gastly");
if (!already_caught) {
    game_controller.start_stage_music(snd_gastly_music, true, false);
}

has_awesome_sauce = game_has_item("AwesomeSauce");
battle_age = -150;
transition_age = 0;
gastly_x = x;
gastly_y = y;
gastly_scale = 1;
gastly_sprite = spr_gastly_approach;
gastly_angle = 0;
gastly_hp = 24;
capturing = false;
caught = false;
dialogue = "";
dialogue_letters = 0;
reward_notice_age = -1;

set_dialogue = function(_text) {
    dialogue = _text;
    dialogue_letters = 0;
};

take_player_shot = function(_shot) {
    if (!has_awesome_sauce || battle_age < 650 || capturing || caught || already_caught) {
        return false;
    }
    var _hit_x = (_shot.x - (gastly_x + 3)) / 26;
    var _hit_y = (_shot.y - (gastly_y - 4)) / 25;
    if (sqr(_hit_x) + sqr(_hit_y) > 1) {
        return false;
    }

    // Fusion rewinds to 651 to give every capture the same Poké Ball shake.
    capturing = true;
    battle_age = 651;
    gastly_y += 8;
    gastly_sprite = spr_gastly_capture;
    return true;
};
