enum CastlevaniaForestTrap {
    CurseSign,
    FlamingOrb,
    SlidingSpike,
    Pillar
}

enum CastlevaniaForestEffect {
    GhoulSparks,
    GhoulFade,
    PillarFade,
    PillarDebris
}

function castlevania_forest_trap_setup(_kind) {
    trap_kind = _kind;
    trap_active = false;
    image_speed = 1;
    switch (_kind) {
        case CastlevaniaForestTrap.CurseSign:
            sprite_index = spr_castlevania_curse_sign;
            vertical_speed = 15;
            break;
        case CastlevaniaForestTrap.FlamingOrb:
            sprite_index = spr_castlevania_flaming_orb;
            vertical_speed = 0;
            break;
        case CastlevaniaForestTrap.SlidingSpike:
            sprite_index = spr_castlevania_sliding_spike;
            image_xscale = 10;
            image_yscale = 10;
            break;
        case CastlevaniaForestTrap.Pillar:
            sprite_index = spr_castlevania_pillar;
            break;
    }
}

function castlevania_forest_effect_setup(_kind) {
    forest_effect = _kind;
    image_speed = 0;
    image_index = 0;
    effect_steps = 0;
    switch (_kind) {
        case CastlevaniaForestEffect.GhoulSparks:
            sprite_index = spr_castlevania_ghoul_sparks;
            effect_left = choose(false, true);
            break;
        case CastlevaniaForestEffect.GhoulFade:
            sprite_index = effect_left ? spr_castlevania_ghoul_disappear_left : spr_castlevania_ghoul_disappear;
            break;
        case CastlevaniaForestEffect.PillarFade:
            sprite_index = spr_castlevania_pillar_disappear;
            break;
        case CastlevaniaForestEffect.PillarDebris:
            sprite_index = spr_castlevania_pillar_debris;
            break;
    }
}

function castlevania_forest_spawner_setup(_variant) {
    widget_variant = _variant;
    if (_variant == 4) {
        sprite_index = spr_castlevania_ghoul_spawner;
    } else {
        sprite_index = spr_castlevania_skeleton_spawner;
    }
}
