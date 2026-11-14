game_controller = instance_find(obj_game, 0);
game_controller.start_stage_music(snd_king_dedede_music, true, false);
entrance_voice = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);

if (game_campaign_difficulty() == 0) {
    x += 60;
}
image_speed = 0;
room_steps = 0;
hit_flash_steps = 0;
dedede_falling = false;
dedede_defeated = false;
defeat_steps = 0;
defeat_start_x = 0;
cutscene_king = noone;
cutscene_vsp = 0;
knight = noone;
hadoken = noone;
hadoken_age = 0;
exit_open = false;
trophy_pending = false;
trophy_steps = -1;

king_dedede_attacks_setup();

take_player_shot = function(_bullet) {
    var _beam = dedede_wrong_effect;
    if (instance_exists(_beam) && _beam.sprite_index == spr_king_dedede_wrong_effect) {
        var _blocked = false;
        with (_bullet) {
            _blocked = place_meeting(x, y, _beam);
        }
        if (_blocked) {
            return true;
        }
    }
    if (!dedede_answer_correct || dedede_falling || dedede_defeated) {
        return false;
    }
    if (collision_rectangle(_bullet.bbox_left, _bullet.bbox_top, _bullet.bbox_right, _bullet.bbox_bottom,
        id, true, false) == noone) {
        return false;
    }

    // The native RIGHT?! window moves the King two pixels per shot.
    x += 2;
    dedede_falling = x > 560;
    if (hit_flash_steps == 0) {
        hit_flash_steps = 10;
    }
    audio_play_sound(snd_hello_kitty_hit, 1, false);
    return true;
};
