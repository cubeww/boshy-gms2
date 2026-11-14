age_steps = 0;
fall_speed = 0;
left_speed = 0;
orbit_angle = 0;
image_speed = 0;
image_xscale = attack_scale;
image_yscale = attack_scale;

switch (attack_kind) {
    case GreenGreensKrackoAttack.Lightning:
        sprite_index = spr_green_greens_kracko_lightning;
        image_yscale = 1;
        break;
    case GreenGreensKrackoAttack.Minion:
        sprite_index = spr_green_greens_kracko_minion;
        left_speed = 2 + irandom(4);
        break;
    case GreenGreensKrackoAttack.FallingStar:
        sprite_index = spr_green_greens_kracko_star;
        break;
    case GreenGreensKrackoAttack.SwingStar:
        sprite_index = spr_green_greens_kracko_swing;
        orbit_angle = -2 * (boss.attack_age - 949);
        break;
}
