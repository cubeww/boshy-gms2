if (!variable_instance_exists(id, "hazard_kind")) {
    hazard_kind = CheetahMenPhaseThreeHazard.SlantedDrop;
}
if (!variable_instance_exists(id, "travel_x")) {
    travel_x = 0;
}
drop_active = false;

switch (hazard_kind) {
    case CheetahMenPhaseThreeHazard.BounceTarget:
        sprite_index = spr_cheetah_men_phase3_bounce_target;
        break;
    case CheetahMenPhaseThreeHazard.FallingTarget:
        sprite_index = spr_cheetah_men_phase3_falling_target;
        break;
}
