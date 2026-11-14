++age;

switch (attack_kind) {
    case HelloKittyAttack.OpeningClone:
        x += horizontal_speed;
        y += vertical_speed;
        vertical_speed += 0.2;
        if (vertical_speed >= 6 && y >= 320) {
            vertical_speed = -5;
            horizontal_speed = irandom(1) - irandom(1);
        }
        image_angle = dsin(boss.age_steps * 20 / 3) * 25;
        break;
    case HelloKittyAttack.FallingClone:
        x += horizontal_speed;
        y += vertical_speed;
        vertical_speed += 0.5;
        if (vertical_speed >= 8) {
            vertical_speed = -3;
            horizontal_speed = irandom(1) - irandom(2);
        }
        break;
    case HelloKittyAttack.AimedHeart:
    case HelloKittyAttack.SpiralHeart:
        x += horizontal_speed;
        y += vertical_speed;
        image_index = age mod sprite_get_number(sprite_index);
        if (attack_kind == HelloKittyAttack.AimedHeart && boss.age_steps mod 5 == 0) {
            var _trail_angle = heading + 180 + irandom(89) - irandom(89);
            boss.spawn_attack(HelloKittyAttack.HeartTrail, x, y, _trail_angle, 2);
        }
        break;
    case HelloKittyAttack.Laser:
        // The warning plays its ten frames, then repeats frames 5–9 six times at 80% speed.
        if (age < 50) {
            var _frame = floor(age * 0.8);
            image_index = _frame < 10 ? _frame : 5 + ((_frame - 10) mod 5);
        } else if (age < 80) {
            if (age == 50) {
                sprite_index = spr_hello_kitty_laser_active;
                lethal = true;
                audio_play_sound(snd_hello_kitty_laser, 1, false, 0.4);
            }
            image_index = (age - 50) mod sprite_get_number(sprite_index);
            boss.shake_steps = 10;
            boss.stage_controller.blur_strength = 2.5;
            boss.spawn_attack(HelloKittyAttack.LaserSpark,
                x + irandom(199) - irandom(199), y, irandom(359), 2 + irandom(5), 4);
        } else {
            if (age == 80) {
                sprite_index = spr_hello_kitty_laser_fire;
                lethal = false;
            }
            image_index = age - 80;
            if (image_index >= sprite_get_number(sprite_index)) {
                instance_destroy();
            }
        }
        break;
    case HelloKittyAttack.HeartTrail:
    case HelloKittyAttack.LaserSpark:
        x += horizontal_speed;
        y += vertical_speed;
        image_angle += 5 + irandom(14);
        image_xscale *= 0.98;
        image_yscale = image_xscale;
        if (age >= (attack_kind == HelloKittyAttack.LaserSpark ? 70 : 40)) {
            instance_destroy();
        }
        break;
    case HelloKittyAttack.DeathFlash:
        image_xscale = draw_scale * (1 + random(0.38));
        image_yscale = image_xscale;
        image_alpha = 1 - age / 20;
        if (age >= 20) {
            instance_destroy();
        }
        break;
    case HelloKittyAttack.Explosion:
        image_index = floor(age * 0.45);
        if (image_index >= sprite_get_number(sprite_index)) {
            instance_destroy();
        }
        break;
}

if ((lethal || attack_kind == HelloKittyAttack.OpeningClone)
    && (x < -100 || x > room_width + 100 || y < -100 || y > room_height + 150)) {
    instance_destroy();
}
