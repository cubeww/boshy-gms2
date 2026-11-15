function cheetah_men_victory_step(_player) {
    // G1239–1241 increase the blast frequency around the large Cheetah.
    if (fight_age >= 6100 && fight_age <= 6500) {
        var _early = fight_age <= 6300 && attack_clock >= 20;
        var _middle = fight_age >= 6300 && fight_age <= 6400 && attack_clock >= 10;
        var _final = fight_age >= 6400 && attack_clock >= 5;
        if (_early || _middle || _final) {
            attack_clock = 0;
            cheetah_men_spawn(CheetahMenAttack.Blast,
                phase_two.x - irandom(93) + irandom(93), phase_two.y - irandom(263));
            audio_play_sound(snd_green_greens_kracko_explosion, 1, false);
            if (!_early) {
                phase_two.image_angle = irandom(14) - irandom(14);
            }
        }
    }
    if (fight_age == 6500) {
        // G1242 ends the explosions on a full-screen flash.
        inst_cheetah_men_flash.flash_alpha = 1;
        audio_play_sound(snd_bomberman_victory_explosion, 1, false);
        with (obj_cheetah_men_actor) {
            actor_active = false;
        }
    } else if (fight_age == 6700 && _player != noone) {
        game_controller.start_stage_music(snd_cheetah_men_victory_music, false, false);
    }

    inst_cheetah_men_reward.update_reward(_player, fight_age, game_controller);
    if (fight_age >= 6900) {
        inst_cheetah_men_exit.update_exit(_player);
    }
}
