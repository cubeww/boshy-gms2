if (attack_kind == SkeletonKingAttack.BlobFlyer) {
    exit;
}
++attack_age;

switch (attack_kind) {
    case SkeletonKingAttack.FloorWave:
        // Group 662 checks the position after group 661 moves the sweep.
        if (x > 1300) {
            x -= 3;
        }
        if (x <= 1300) {
            x -= 2;
        }
        exit;

    case SkeletonKingAttack.Lightning:
        image_index = (attack_age - 1) div 2;
        if (image_index >= image_number) {
            instance_destroy();
        }
        exit;

    case SkeletonKingAttack.FallingSkeleton:
        // Groups 819–820 reverse the falling velocity below the arena floor.
        if (y > 470) {
            vertical_speed = -vertical_speed;
        }
        y = floor(y + vertical_speed);
        x += travel_speed;
        vertical_speed += 0.5;
        image_index = ((attack_age - 1) div 10) mod image_number;
        break;

    case SkeletonKingAttack.FireWarning:
        y -= 2;
        if (attack_age >= 35) {
            // Groups 821–822 turn the warning into a rising fireball with .09 gravity.
            var _fireball = skeleton_king_spawn_attack(SkeletonKingAttack.Fireball, spr_skeleton_king_fireball,
                x, y, 90 - irandom(9) + irandom(9), 10);
            _fireball.fireball_gravity = 0.09;
            audio_play_sound(snd_skeleton_king_fire, 1, false);
            instance_destroy();
        }
        exit;

    case SkeletonKingAttack.FireballImpact:
        if (attack_age >= 10) {
            instance_destroy();
        }
        exit;

    case SkeletonKingAttack.Stone:
        y = floor(y + vertical_speed);
        vertical_speed += 0.4;
        // G764 checks impact immediately after G763 advances the falling stone.
        var _player = instance_find(obj_player, 0);
        if (_player != noone && _player.boshy_mask_meeting(id)) {
            _player.die();
        }
        break;

    case SkeletonKingAttack.SpinningDiamond:
        // Group 763 translates and rotates these diamonds while their directional movement flag is off.
        x -= 3;
        image_angle = (image_angle + 2) mod 360;
        var _appear_frame = (attack_age - 1) div 2;
        if (_appear_frame < sprite_get_number(spr_skeleton_king_ember_appear)) {
            image_index = _appear_frame;
        } else if (sprite_index != spr_skeleton_king_ember) {
            sprite_index = spr_skeleton_king_ember;
            image_index = 0;
        }
        break;

    case SkeletonKingAttack.Fireball:
    case SkeletonKingAttack.Diamond:
        // G773 checks the existing position before G826 advances the diamond.
        if (attack_kind == SkeletonKingAttack.Diamond && x < 1249) {
            skeleton_king_set_attack_platform(inst_skeleton_king_falling_platform, -1);
            instance_destroy();
            exit;
        }
        // Groups 682 and 826 display integer positions while retaining the travel fractions.
        x = floor(travel_x);
        y = floor(travel_y);
        travel_x += dcos(image_angle) * travel_speed;
        travel_y -= dsin(image_angle) * travel_speed;
        if (attack_kind == SkeletonKingAttack.Fireball) {
            image_index = (((attack_age - 1) * 2) div 5) mod image_number;
            travel_y += vertical_speed;
            vertical_speed += fireball_gravity;
        }
        break;
}

// Fusion removes ordinary sprites outside the playfield and its kill margins.
if (bbox_right < -480 || bbox_left > room_width + 480
    || bbox_bottom < -300 || bbox_top > room_height + 300) {
    instance_destroy();
}
