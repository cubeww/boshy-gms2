switch (attack_kind) {
    case SkeletonKingAttack.FireWarning:
        gpu_set_blendmode(bm_add);
        draw_sprite(spr_skeleton_king_fire_warning, 0, x, y);
        gpu_set_blendmode(bm_normal);
        break;

    case SkeletonKingAttack.Lightning:
        gpu_set_blendmode(bm_add);
        draw_self();
        gpu_set_blendmode(bm_normal);
        break;

    case SkeletonKingAttack.FireballImpact:
        draw_sprite_ext(spr_skeleton_king_fireball_impact, (attack_age * 2) div 5, x, y,
            1, 1, image_angle, c_white, 1);
        break;

    default:
        draw_self();
        break;
}
