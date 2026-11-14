shot_spent = false;
impact_steps = 0;
missile_fall = 0;
image_speed = 0;
if (!variable_instance_exists(id, "shot_kind")) {
    shot_kind = GradiusShot.Normal;
}
shot_damage = shot_kind == GradiusShot.Normal ? 1 : 2;

// Groups 881–882 scale the laser and standard shot. Missiles use their original size.
image_xscale = shot_kind == GradiusShot.Missile ? 1 : 2;
image_yscale = image_xscale;

switch (shot_kind) {
    case GradiusShot.Laser: sprite_index = spr_gradius_laser; break;
    case GradiusShot.Missile: sprite_index = spr_gradius_missile; break;
    default: sprite_index = spr_gradius_bullet; break;
}

gradius_player_shot_hit = function() {
    shot_spent = true;
    sprite_index = spr_gradius_shot_impact;
    image_index = 0;
};
