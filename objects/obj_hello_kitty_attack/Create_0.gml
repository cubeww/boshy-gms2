enum HelloKittyAttack {
    OpeningClone,
    FallingClone,
    AimedHeart,
    SpiralHeart,
    Laser,
    HeartTrail,
    LaserSpark,
    DeathFlash,
    Explosion
}

age = 0;
horizontal_speed = lengthdir_x(travel_speed, heading);
vertical_speed = lengthdir_y(travel_speed, heading);
lethal = false;
additive = false;
image_speed = 0;
image_xscale = draw_scale;
image_yscale = draw_scale;

switch (attack_kind) {
    case HelloKittyAttack.OpeningClone:
    case HelloKittyAttack.FallingClone:
        sprite_index = spr_hello_kitty_small;
        image_index = 19;
        lethal = attack_kind == HelloKittyAttack.FallingClone;
        break;
    case HelloKittyAttack.AimedHeart:
    case HelloKittyAttack.SpiralHeart:
        sprite_index = spr_hello_kitty_heart;
        lethal = true;
        if (attack_kind == HelloKittyAttack.SpiralHeart) {
            image_angle = heading;
        }
        break;
    case HelloKittyAttack.Laser:
        sprite_index = spr_hello_kitty_laser_charge;
        additive = true;
        break;
    case HelloKittyAttack.HeartTrail:
    case HelloKittyAttack.LaserSpark:
        sprite_index = spr_hello_kitty_heart_blue;
        additive = attack_kind == HelloKittyAttack.LaserSpark;
        image_alpha = additive ? 0.5 : 1;
        image_angle = heading;
        break;
    case HelloKittyAttack.DeathFlash:
        sprite_index = spr_hello_kitty_death_flash;
        additive = true;
        break;
    case HelloKittyAttack.Explosion:
        sprite_index = spr_hello_kitty_explosion;
        additive = true;
        image_angle = heading;
        break;
}
